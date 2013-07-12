//
//  ViewController.m
//  TestCipher
//
//  Created by Jun Wang on 13-7-12.
//  Copyright (c) 2013年 Aruba Studio. All rights reserved.
//

#import "ViewController.h"
#import "Cipher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *imageName = @"test";
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    NSURL *imageUrl = [NSURL fileURLWithPath:imagePath];
    NSData *bData = [NSData dataWithContentsOfURL:imageUrl];
    
    Cipher *cipher = [[[Cipher alloc] initWithKey:@"123"] autorelease];
    NSLog(@"Pre Encrypt");
//    NSLog(@"orignal data is %@", bData);
    NSData *encryptData = [cipher encrypt:bData];
    NSLog(@"After Encrypt");
//    NSLog(@"encrypt data is %@", encryptData);
    
    NSLog(@"Pre Decrypt");
    NSData *decryptData = [cipher decrypt:encryptData];
    NSLog(@"After Decrypt");
    
    UIImage *image = [UIImage imageWithData:decryptData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(20, 20, 35, 35);
    [self.view addSubview:imageView];
}



@end
