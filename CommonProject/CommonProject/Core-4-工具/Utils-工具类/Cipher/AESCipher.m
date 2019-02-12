//
//  AESCipher.m
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

#import "AESCipher.h"
//#import <CommonCrypto/CommonCryptor.h>

@interface AESCipherSetting()
    
@end

@implementation AESCipherSetting
    
- (instancetype)initWithType:(AESCipherType)type
                     padding:(AESCipherPadding)dataPadding
                  keyPadding:(AESCipherKeyPadding)keyPadding
                   operation:(AESCipherOperation)encryptOrDencrypt {
    if (self = [super init]){
        self.type = type;
        self.dataPadding = dataPadding;
        self.keyPadding  = keyPadding;
        self.operation   = encryptOrDencrypt;
    }
    return self;
}
    
@end


/*************  AESCipher    **********/

@interface AESCipher()
    
@end

@implementation AESCipher
    
+ (void)ecbCipher:(NSData *)dataIn
              key:(NSData *)symmetricKey
         settings:(AESCipherSetting *)setting
       completion:(AESCipherCompletion)callback {
    
    //检查dataIn
    if (dataIn == nil || dataIn.length == 0){
        callback(nil, AESCipherErrorDataIn);
        return;
    }
    
    AESCipherType type = setting.type;
    AESCipherKeyPadding keyPadding = setting.keyPadding;
    
    AESCipherKeySize keySize;
    //检查Key
    switch (type) {
        case AESCipherType128:
        keySize = AESCipherKeySize128;
        break;
        case AESCipherType192:
        keySize = AESCipherKeySize192;
        break;
        case AESCipherType256:
        keySize = AESCipherKeySize256;
        break;
        default:
        break;
    }
    NSData *newKey = [self appendKeyDataWithKeySize:keySize key:symmetricKey keyPadding:keyPadding completion:^(NSData * _Nullable dataOut, AESCipherError error) {
        if (error != AESCipherErrorNone) {
            callback(nil, error);
            return;
        }
    }];
    
    CCOperation op;
    NSData *newData;
    
    switch (setting.operation) {
        case AESCipherOperationEncrypt:
        op = (CCOperation)(kCCEncrypt);
        break;
        case AESCipherOperationDecrypt:
        op = (CCOperation)(kCCDecrypt);
        break;
        default:
        break;
    }
    // 加密添加，解密移除， current not removed the data appendded, it's work
    newData = [self dealWithDataIn:dataIn padding:setting.dataPadding operation:op];
    
    [self executeCipher:newData
                    key:newKey
                   type:type
                context:op
             completion:^(NSData * _Nullable dataOut, AESCipherError error) {
                 callback(dataOut, error);
             }];
    
}
    
+ (void)ecbCipher:(NSData *)dataIn
              key:(NSData *)symmetricKey
             type:(AESCipherType)aes256
          padding:(AESCipherPadding)dataPadding
       keyPadding:(AESCipherKeyPadding)keyDataPadding
        operation:(AESCipherOperation)encryptOrDecrypt
       completion:(AESCipherCompletion)callback {
    
}
    
    
    
+ (void)doCipher:(NSData *)dataIn
             key:(NSData *)symmetricKey
       operation:(AESCipherOperation)encryptOrDecrypt
      completion:(AESCipherCompletion)callback {
    
    //校验dataIn
    if (dataIn == nil || dataIn.length == 0) {
        callback(nil,AESCipherErrorDataIn);
        return;
    }
    
    
    //校验Key length
    NSArray<NSNumber *> *keyLengths = @[
                                        @(AESCipherKeySize128),
                                        @(AESCipherKeySize192),
                                        @(AESCipherType256)
                                        ];
    NSNumber *inputKey = @(symmetricKey.length);
    if (![keyLengths containsObject:inputKey]) {
        callback(nil,AESCipherErrorKeyLength);
        return;
    }
    CCOperation op = (CCOperation)kCCEncrypt;
    switch (encryptOrDecrypt) {
        case AESCipherOperationEncrypt:
        op = (CCOperation)kCCEncrypt;
        break;
        case AESCipherOperationDecrypt:
        op = (CCOperation)kCCDecrypt;
        break;
        
        default:
        break;
    }
    
}
    
#pragma mark - Private Methods
    
    // 处理 key
    
    /**
     处理加密密码
     
     @param keySize AES KeySize 16bytes 24 bytes 32bytes
     @param symmetricKey 对称key Data
     @param keyPadding key Data 拼接规则
     @param callback 回调
     @return 新的 key data
     */
+ (NSData *)appendKeyDataWithKeySize:(AESCipherKeySize)keySize
                                 key:(NSData *)symmetricKey
                          keyPadding:(AESCipherKeyPadding)keyPadding
                          completion:(AESCipherCompletion)callback {
    
    NSMutableData *keyData = [NSMutableData dataWithData:symmetricKey];
    
    if (symmetricKey.length != keySize) {
        if (keyPadding == AESCipherKeyPaddingNone) {
            callback(nil,AESCipherErrorKeyLength);
            return symmetricKey;
        }else if (symmetricKey.length < keySize) {
            if (keyPadding == AESCipherKeyPaddingZero) {
                int appendCount = (int)(keySize - symmetricKey.length);
                NSMutableData *appendData = [NSMutableData dataWithLength:appendCount];
                [keyData appendData:appendData];
            }else{
                callback(nil,AESCipherErrorKeyLength);
                return keyData;
            }
        }else { // ToDo
            callback(nil,AESCipherErrorKeyLength);
            return keyData;
        }
    }
    callback(nil,AESCipherErrorNone);
    return keyData;
}
    
    // 处理 data in
+ (NSData *)dealWithDataIn:(NSData *)dataIn
                   padding:(AESCipherPadding)dataPadding
                 operation:(AESCipherOperation)operation {
    
    int toAppendCount = 0;
    NSMutableData *data = [NSMutableData dataWithData:dataIn];
    toAppendCount = kCCBlockSizeAES128 - (dataIn.length % kCCBlockSizeAES128);
    // zero padding rule (eg. data + (padding 0000) + 04占位，（ % 余数2),  解密移除)
    //    switch (operation) {
    //        case AESCipherOperationEncrypt:
    //        toAppendCount = kCCBlockSizeAES128 - (dataIn.length % kCCBlockSizeAES128);
    //        break;
    //
    //        case AESCipherOperationDecrypt:
    //        if (dataPadding == AESCipherPaddingZero) {
    //
    //        }
    //        break;
    //
    //        default:
    //        break;
    //    }
    //
    
    
    if (toAppendCount < kCCBlockSizeAES128) {
        
        if (dataPadding == AESCipherPaddingZero) {
            NSMutableData *appendding = [NSMutableData dataWithLength:toAppendCount];
            [data appendData:appendding];
        }else if (dataPadding == AESCipherPaddingPKCS7) {
            
            //             NSMutableData *appendding = [NSMutableData dataWithLength:toAppendCount];
            NSMutableData *appendding = [NSMutableData dataWithCapacity:toAppendCount];
            for (int i = 0; i < toAppendCount; i++) {
                int appendingNumber = toAppendCount;
                
                //                [appendding replaceBytesInRange:NSMakeRange(i, 1) withBytes:&appendingNumber];
                [appendding appendBytes:&appendingNumber length:1];
            }
            NSLog(@"pkcs7 appenddingData: %@",appendding);
            [data appendData:appendding];
        }else {
            
        }
    }
    return data;
}
    
    
+ (void)executeCipher:(NSData *)dataIn
                  key:(NSData *)symmetricKey
                 type:(AESCipherType)aes256or192or128
              context:(CCOperation)encryptOrDecrypt // kCCEncrypt or kCCDecrypt
           completion:(AESCipherCompletion)callback
    {
        CCCryptorStatus ccStatus   = kCCSuccess;
        size_t          cryptBytes = 0;    // Number of bytes moved to buffer.
        NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeAES128];
        
        ccStatus = CCCrypt( encryptOrDecrypt,
                           kCCAlgorithmAES128,
                           kCCOptionECBMode,
                           symmetricKey.bytes,
                           aes256or192or128,
                           0,
                           dataIn.bytes, dataIn.length,
                           dataOut.mutableBytes, dataOut.length,
                           &cryptBytes);
        
        if (ccStatus != kCCSuccess) {
            NSLog(@"CCCrypt status: %d", ccStatus);
            if (encryptOrDecrypt == ((CCOperation)kCCEncrypt)) {
                callback(nil,AESCipherErrorEncrypt);
                
            }else {
                callback(nil,AESCipherErrorDecrypt);
            }
            return;
        }
        
        dataOut.length = cryptBytes;
        callback(dataOut,AESCipherErrorNone);
        //    return dataOut;
    }
    
    
+ (NSData *)doCipher:(NSData *)dataIn
                 key:(NSData *)symmetricKey
             context:(CCOperation)encryptOrDecrypt // kCCEncrypt or kCCDecrypt
    {
        CCCryptorStatus ccStatus   = kCCSuccess;
        size_t          cryptBytes = 0;    // Number of bytes moved to buffer.
        NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeAES128];
        
        ccStatus = CCCrypt( encryptOrDecrypt,
                           kCCAlgorithmAES128,
                           kCCOptionECBMode,
                           symmetricKey.bytes,
                           kCCKeySizeAES256,
                           0,
                           dataIn.bytes, dataIn.length,
                           dataOut.mutableBytes, dataOut.length,
                           &cryptBytes);
        
        if (ccStatus != kCCSuccess) {
            NSLog(@"CCCrypt status: %d", ccStatus);
        }
        
        dataOut.length = cryptBytes;
        
        //test
        //    NSMutableData *mData = [NSMutableData dataWithLength:4];
        //    NSLog(@"mData: = %@",mData);
        
        return dataOut;
    }
    
    
@end
