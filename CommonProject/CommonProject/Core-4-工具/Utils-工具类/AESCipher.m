//
//  AESCipher.m
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

#import "AESCipher.h"

@implementation AESCipher

+ ( NSData *)doCipher:(NSData *)dataIn
                 key:(NSData *)symmetricKey
             context:(CCOperation)encryptOrDecrypt // kCCEncrypt or kCCDecrypt
{
    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;    // Number of bytes moved to buffer.
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeAES128];
    
    ccStatus = CCCrypt( encryptOrDecrypt,
                       kCCAlgorithmAES128,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       symmetricKey.bytes,
                       kCCKeySizeAES128,
                       0,
                       dataIn.bytes, dataIn.length,
                       dataOut.mutableBytes, dataOut.length,
                       &cryptBytes);
    
    if (ccStatus != kCCSuccess) {
        NSLog(@"CCCrypt status: %d", ccStatus);
    }
    
    dataOut.length = cryptBytes;
    
    return dataOut;
}


@end
