//
//  NSData+AES128.h
//  ULockDemo
//
//  Created by apple on 2019/9/5.
//  Copyright © 2019 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES128)
/* 加密 */
- (NSData *)AES128EncryptWithKey:(NSData *)keyData;
/* 解密 */
- (NSData *)AES128DecryptWithKey:(NSData *)keyData;
@end

NS_ASSUME_NONNULL_END
