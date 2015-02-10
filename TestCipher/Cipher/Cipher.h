//
//  Cipher.h
//  TestCipher
//
//  Created by Jun Wang on 13-7-12.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

/**
 *  Cipher Class to encrypt/decrypt data using AES algorithm.
 */
@interface Cipher : NSObject

/**
 *  Raw key material in NSData format.
 */
@property (strong) NSData *keyData;
/**
 *  Raw initial vector material in NSData format.
 */
@property (strong) NSData *ivData;

/**
 *  Use a cipher object to perform AES encryption to the given plain data.
 *
 *  @param plainData The plain data need to be encrypted.
 *
 *  @return The ciphered data, NSData format.
 */
- (NSData *)encrypt:(NSData *)plainData;
/**
 *  Use a cipher object to perform AES decryption to the given cipher data.
 *
 *  @param cipherData The ciphered data need to be decrypted.
 *
 *  @return The decrypted data, NSData format.
 */
- (NSData *)decrypt:(NSData *)cipherData;

@end
