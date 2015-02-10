//
//  NSData+Addition.m
//  JWRepository
//
//  Created by Jowyer on 14-8-21.
//  Copyright (c) 2014年 jo2studio. All rights reserved.
//

#import "NSData+Addition.h"
#import <CommonCrypto/CommonDigest.h>
/** add Security.framework */
#import <Security/SecRandom.h>

@implementation NSData (Addition)

#pragma mark - MD5
- (NSString*)md5Hash {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

+ (NSData *)dataWithStringNeedMD5Hash:(NSString *)stringNeedHash {
    const char *src = [stringNeedHash UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(src, (CC_LONG)strlen(src), result);
    
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

#pragma mark - String Conversion
- (NSString *)hexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

+ (NSData *)dataWithHexString:(NSString *)hexString {
    hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *newData = [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0', '\0', '\0'};
    for (int i = 0; i < [hexString length]/2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i*2];
        byte_chars[1] = [hexString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [newData appendBytes:&whole_byte length:1];
    }
    return newData;
}

#pragma mark - Random Data
+ (NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}

@end

