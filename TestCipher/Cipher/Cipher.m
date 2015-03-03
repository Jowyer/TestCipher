//
//  Cipher.m
//  TestCipher
//
//  Created by Jun Wang on 13-7-12.
//

/**
 Work with Java : http://watchitlater.com/blog/2010/02/java-and-iphone-aes-interoperability/
 Work with C# : http://automagical.rationalmind.net/2009/02/12/aes-interoperability-between-net-and-iphone/
 */

#import "Cipher.h"

@implementation Cipher

+ (instancetype)sharedCipher {
    static Cipher *_sharedCipher = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedCipher = [[self alloc] init];
    });
    
    return _sharedCipher;
}

- (NSData *) encrypt:(NSData *) plainText
{
    return [self transform:kCCEncrypt data:plainText];
}

- (NSData *) decrypt:(NSData *) cipherText
{
    return [self transform:kCCDecrypt data:cipherText];
}

/**
 *  Transform inputData to returnData by using given cryptor method.
 *
 *  @param encryptOrDecrypt Method to use. Either Encrypt or Decrypt.
 *  @param inputData        The given raw data.
 *
 *  @return Output data after cryptor manipulation.
 */
- (NSData *) transform:(CCOperation) encryptOrDecrypt data:(NSData *) inputData
{
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    /**
     1. AES Algorithm = 16 bytes
     2. Block cipher mode of operation : CBC (by the absence of the kCCOptionECBMode bit in the options flags)
     3. Padding : PKCS7
     */
    status = CCCryptorCreate(encryptOrDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                             self.keyData.bytes, kCCKeySizeAES128, self.ivData.bytes, &cryptor);
    
    if (status != kCCSuccess)
    {
        return nil;
    }
    
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[inputData length], true);
    
    void * buf = malloc(bufsize * sizeof(uint8_t));
    memset(buf, 0x0, bufsize);
    
    size_t bufused = 0;
    size_t bytesTotal = 0;
    
    status = CCCryptorUpdate(cryptor, [inputData bytes], (size_t)[inputData length],
                             buf, bufsize, &bufused);
    
    if (status != kCCSuccess)
    {
        free(buf);
        CCCryptorRelease(cryptor);
        return nil;
    }
    
    bytesTotal += bufused;
    
    status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
    
    if (status != kCCSuccess)
    {
        free(buf);
        CCCryptorRelease(cryptor);
        return nil;
    }
    
    bytesTotal += bufused;
    
    CCCryptorRelease(cryptor);
    
    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}

@end
