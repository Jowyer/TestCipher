//
//  Cipher.h
//  TestCipher
//
//  Created by Jun Wang on 13-7-12.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface Cipher : NSObject
{
    NSString* cipherKey;
}

@property (strong) NSString* cipherKey;

- (Cipher *) initWithKey:(NSString *) key;

- (NSData *) encrypt:(NSData *) plainText;
- (NSData *) decrypt:(NSData *) cipherText;

- (NSData *) transform:(CCOperation) encryptOrDecrypt data:(NSData *) inputData;

+ (NSData *) md5:(NSString *) stringToHash;

@end
