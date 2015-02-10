//
//  NSData+Addition.h
//  JWRepository
//
//  Created by Jowyer on 14-8-21.
//  Copyright (c) 2014年 jo2studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Addition)

#pragma mark - MD5
/**
 *  MD5 processes a variable-length message into a fixed-length output of 128 bits.
 *
 *  @return 128-bit (16-byte) hash value of the given data;
 */
- (NSString*)md5Hash;
/**
 *  Hash a variable-length string to a 128-bit hashed string, 
 *  then generate a NSData object from the hashed string.
 *
 *  Used when perform AES, the 'KeyString' may not be 16-byte long,
 *  we can hash the 'KeyString' first, then generate a 'KeyData'.
 *
 *  @param stringNeedHash original string that need to be MD5 hashed.
 *
 *  @return NSData object which generated by hashed string.
 */
+ (NSData *)dataWithStringNeedMD5Hash:(NSString *)stringNeedHash;

#pragma mark - String Conversion
/**
 *  The Hexadecimal representation of the given NSData.
 *
 *  @return Hexadecimal string of the given data.
 */
- (NSString *)hexadecimalString;
/**
 *  Generate an NSData object with an hexadecimal string.
 *
 *  @param hexString string of hex characters.
 *
 *  @return NSData object generated with hexadecimal string.
 */
+ (NSData *)dataWithHexString:(NSString *)hexString;

#pragma mark - Random Data
/**
 *  Generate an array of cryptographically secure random bytes with specific length.
 *
 *  Used when perform AES, 'keyData' and 'ivData' can be generated by this method.
 *
 *  @param length The length of random bytes.
 *
 *  @return An NSData with secure random bytes.
 *
 *  @see http://robnapier.net/aes-commoncrypto
 */
+ (NSData *)randomDataOfLength:(size_t)length;

@end
