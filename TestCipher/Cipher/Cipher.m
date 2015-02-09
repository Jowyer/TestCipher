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

@synthesize cipherKey;

- (Cipher *) initWithKey:(NSString *) key
{
    self = [super init];
    if (self)
    {
        [self setCipherKey:key];
    }
    return self;
}

- (void)dealloc
{
    self.cipherKey = nil;
    [super dealloc];
}

- (NSData *) encrypt:(NSData *) plainText
{
    return [self transform:kCCEncrypt data:plainText];
}

- (NSData *) decrypt:(NSData *) cipherText
{
    return [self transform:kCCDecrypt data:cipherText];
}

- (NSData *) transform:(CCOperation) encryptOrDecrypt data:(NSData *) inputData
{
    // kCCKeySizeAES128 = 16 bytes
    // CC_MD5_DIGEST_LENGTH = 16 bytes
    NSData* secretKey = [Cipher md5:cipherKey];
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    uint8_t iv[kCCBlockSizeAES128];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    /**
     1. Block cipher mode of operation : CBC (by the absence of the kCCOptionECBMode bit in the options flags)
     2. Padding : PKCS7
     3. IV : a NULL (all zeroes) IV will be used. byte[] {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
     */
    status = CCCryptorCreate(encryptOrDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                             [secretKey bytes], kCCKeySizeAES128, iv, &cryptor);
    
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

+ (NSData *) md5:(NSString *) stringToHash
{
    const char *src = [stringToHash UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(src, (CC_LONG)strlen(src), result);
    
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

@end
