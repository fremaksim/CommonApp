//
//  AESCipher.h
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESCipher: NSObject


/**
 <#Description#>

 @param dataIn <#dataIn description#>
 @param symmetricKey <#symmetricKey description#>
 @param encryptOrDecrypt <#encryptOrDecrypt description#>
 @return <#return value description#>
 */
+ (NSData *)doCipher:(NSData *)dataIn
                 key:(NSData *)symmetricKey
             context:(CCOperation)encryptOrDecrypt;// kCCEncrypt or kCCDecrypt

@end

NS_ASSUME_NONNULL_END
