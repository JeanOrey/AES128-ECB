//
//  NSData+AES128.m
//  ULockDemo
//
//  Created by apple on 2019/9/5.
//  Copyright © 2019 coder. All rights reserved.
//

#import "NSData+AES128.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES128)

#warning - AES128 ECB不需要设置初始向量, 蓝牙AES128不同于字符串加密，常用的oc字符串加密返回值长度是"内容长度"+kCCBlockSizeAES128(比如:加密前16字节，加密后是32字节),但本项目蓝牙数据解析，只跟"内容长度"有关（加密前16字节，加密后也是16字节）,所以需要修改返回数据长度和模式（仅支持ECB）
- (NSData *)AES128EncryptWithKey:(NSData *)keyData
{
    NSUInteger dataLength = [self length];
    size_t bufferSize = kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode,
                                          [keyData bytes],
                                          kCCKeySizeAES128,
#warning - ECB不需要初始向量，其它有需要，请注意修改模式kCCOptionECBMode，将"NULL"改为初始向量的bytes值就行(如：[IVectorData bytes],或直接传入初始向量的bytes数组)
                                          NULL /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          kCCBlockSizeAES128, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES128DecryptWithKey:(NSData *)keyData
{
    NSUInteger dataLength = [self length];
    size_t bufferSize = kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode,
                                          [keyData bytes],
                                          kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
} 

@end
