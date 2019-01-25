//
//  AESCipher.h
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AESCipherType128 = 16,
    AESCipherType192 = 24,
    AESCipherType256 = 32,
} AESCipherType;

typedef enum : NSUInteger {
    AESCipherKeySize128 = 16, //bytes
    AESCipherKeySize192 = 24,
    AESCipherKeySize256 = 32,
} AESCipherKeySize;

typedef enum : NSUInteger {
    AESCipherOperationEncrypt = 0, //加密
    AESCipherOperationDecrypt,     //解密
} AESCipherOperation;

typedef enum : NSUInteger {
    AESCipherErrorKeyLength,
    AESCipherErrorDataIn,
    AESCipherErrorEncrypt,
    AESCipherErrorDecrypt,
    AESCipherErrorNone, //无错误... bad design
} AESCipherError;

typedef enum : NSUInteger {
    AESCipherPaddingZero,
    AESCipherPaddingPKCS7,
} AESCipherPadding;

typedef enum : NSUInteger {
    AESCipherKeyPaddingZero,
    AESCipherKeyPaddingNone,
} AESCipherKeyPadding; // if key size large 16，24，32 bytes ... Bad design

typedef void(^AESCipherCompletion)(NSData *_Nullable dataOut ,AESCipherError error);


@interface AESCipherSetting: NSObject

@property(nonatomic, assign) AESCipherType type;
@property(nonatomic, assign) AESCipherPadding dataPadding;
@property(nonatomic, assign) AESCipherKeyPadding keyPadding;
@property(nonatomic, assign) AESCipherOperation operation;


- (instancetype)initWithType:(AESCipherType)type
                     padding:(AESCipherPadding)dataPadding
                  keyPadding:(AESCipherKeyPadding)keyPadding
                   operation:(AESCipherOperation)encryptOrDencrypt;

@end

/**
 The AESCipher design for ECB, only support zeroPadding and PKCS7Padding ()
 */
@interface AESCipher: NSObject

// features
// 1. DataIn bytes padding.
// 2. keySize padding, use padding zero.


/**
 cipher with keysize check and data padding
 
 @param dataIn 处理数据
 @param symmetricKey 加密key
 @param setting 配置
 @param callback 回调
 */
+ (void)ecbCipher:(NSData *)dataIn
              key:(NSData *)symmetricKey
         settings:(AESCipherSetting *)setting
       completion:(AESCipherCompletion)callback;


/**
 Encrypt or Decrypt with no checks
 
 @param dataIn input Data
 @param symmetricKey key Data
 @param encryptOrDecrypt encrypt or decrypt
 @return output data
 */
+ (NSData *)doCipher:(NSData *)dataIn
                 key:(NSData *)symmetricKey
             context:(CCOperation)encryptOrDecrypt;// kCCEncrypt or kCCDecrypt

@end

NS_ASSUME_NONNULL_END
