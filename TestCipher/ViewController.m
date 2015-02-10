//
//  ViewController.m
//  TestCipher
//
//  Created by Jun Wang on 13-7-12.
//

#import "ViewController.h"
#import "Cipher.h"

#import "NSData+Addition.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testWithString];
    
//    [self testWithImage];
}

- (void)testWithString {
    // 1. Create a cipher with keyData and ivData
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"key"]) {
        NSData *_keyData = [NSData randomDataOfLength:16];
        NSData *_ivData = [NSData randomDataOfLength:16];
        [defaults setObject:_keyData forKey:@"key"];
        [defaults setObject:_ivData forKey:@"iv"];
        [defaults synchronize];
    }
    
    Cipher *cipher = [Cipher new];
    cipher.keyData = [defaults objectForKey:@"key"];
    cipher.ivData = [defaults objectForKey:@"iv"];
    NSLog(@"keyDataString is %@", [[NSString alloc] initWithCharacters:cipher.keyData.bytes length:16]);
    NSLog(@"keyData is %@", cipher.keyData);
    NSLog(@"ivDataString is %@", [[NSString alloc] initWithCharacters:cipher.ivData.bytes length:16]);
    NSLog(@"ivData is %@", cipher.ivData);
    
    // 2. prepare the original data we want to encrypt and print the input
    NSString *password = @"www.apple.com";
    NSData *originalData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"password : %@", password);
    NSLog(@"originalData : %@", originalData);
    
    // 3. encrypt the data and print it
    NSData *encryptData = [cipher encrypt:originalData];
    NSLog(@"encryptData : %@", encryptData);
    
    // 4. try to decode the encrypt data which will fail..
    NSString *tryToDecryptString = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
    NSLog(@"tryToDecryptString : %@", tryToDecryptString);
    NSLog(@"------------------");
    
    // 5. decrypte the data and print the output
    NSData *decryptData = [cipher decrypt:encryptData];
    NSString *decrpytString = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    NSLog(@"decryptData : %@", decryptData);
    NSLog(@"decryptString : %@", decrpytString);
}

- (void)testWithImage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"key"]) {
        NSData *_keyData = [NSData randomDataOfLength:16];
        NSData *_ivData = [NSData randomDataOfLength:16];
        [defaults setObject:_keyData forKey:@"key"];
        [defaults setObject:_ivData forKey:@"iv"];
        [defaults synchronize];
    }
    
    Cipher *cipher = [Cipher new];
    cipher.keyData = [defaults objectForKey:@"key"];
    cipher.ivData = [defaults objectForKey:@"iv"];
    NSLog(@"keyDataString is %@", [[NSString alloc] initWithCharacters:cipher.keyData.bytes length:16]);
    NSLog(@"keyData is %@", cipher.keyData);
    NSLog(@"ivDataString is %@", [[NSString alloc] initWithCharacters:cipher.ivData.bytes length:16]);
    NSLog(@"ivData is %@", cipher.ivData);
    
    NSString *imageName = @"test";
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    NSURL *imageUrl = [NSURL fileURLWithPath:imagePath];
    NSData *bData = [NSData dataWithContentsOfURL:imageUrl];
    
    NSLog(@"Pre Encrypt");
    NSLog(@"orignal data is %@", bData);
    NSData *encryptData = [cipher encrypt:bData];
    NSLog(@"After Encrypt");
    NSLog(@"encrypt data is %@", encryptData);
    
    NSLog(@"Pre Decrypt");
    NSData *decryptData = [cipher decrypt:encryptData];
    NSLog(@"After Decrypt");
    
    UIImage *image = [UIImage imageWithData:decryptData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(20, 20, 35, 35);
    [self.view addSubview:imageView];
}



@end
