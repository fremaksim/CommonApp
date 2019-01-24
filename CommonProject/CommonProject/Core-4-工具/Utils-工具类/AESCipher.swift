//
//  AESCipher.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/22.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation
import CommonCrypto

protocol Crypter {
    func encrypt(_ digest: Data) throws -> Data
    func decrypt(_ encrypted: Data) throws -> Data
}

/// 根据key的字节数对应采取AES多少位加密
/// key:16(bytes) AES-128
/// key:24(bytes) AES-192
/// key:32(bytes) AES-256

// 接口设计检测 key size,不合理则抛出异常
class AESCrypter {
    
    enum Error: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }
    
    private enum AESVariant: Int {
        case aes128, aes192, aes256
    }
    
    private var key: Data
    private var iv:  Data?
    
    private var variant: AESVariant
    
    /// 初始化加解密工作类实例
    ///
    /// - Parameters:
    ///   - key: 密码 16/24/32bytes
    ///   - iv: 初始化向量 可选
    /// - Throws: 异常
    public init(key: Data, iv: Data?) throws {
        
        if key.count == kCCKeySizeAES128 {
            variant = .aes128
        }else if key.count == kCCKeySizeAES192 {
            variant = .aes192
        }else if key.count == kCCKeySizeAES256 {
            variant = .aes256
        }else {
            throw Error.badKeyLength
        }
        
        if let iv = iv {
            if !(iv.count == kCCBlockSizeAES128) {
                Error.badInputVectorLength
            }
        }
        
        self.key = key
        self.iv  = iv
    }
    
    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var outLength = Int(0)
        
        // TODO - bug
        var outBytes  = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var data = Data()
        
        try input.withUnsafeBytes { (encryptingBytes: UnsafePointer<UInt8>!) -> () in
            if let iv = self.iv {
                var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
                iv.withUnsafeBytes{ (ivBytes: UnsafePointer<UInt8>!) -> () in
                    key.withUnsafeBytes{ (keyBytes: UnsafePointer<UInt8>!) -> () in
                        //TODO: - kCCOptionECBMode and kCCOptionPKCS7Padding
                        status = CCCrypt(operation,
                                         CCAlgorithm(kCCAlgorithmAES),
                                         CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
                                         keyBytes, key.count,
                                         ivBytes,
                                         encryptingBytes,
                                         input.count, &outBytes, outBytes.count, &outLength)
                    }
                }
                guard status == kCCSuccess else {
                    throw Error.cryptoFailed(status: status)
                }
                data =  Data(bytes: UnsafePointer<UInt8>(outBytes), count: outLength)
                
            }else {
                var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
                key.withUnsafeBytes{ (keyBytes: UnsafePointer<UInt8>!) -> () in
                    status = CCCrypt(operation,
                                     CCAlgorithm(kCCBlockSizeAES128),
                                     CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
                                     keyBytes,
                                     key.count,
                                     nil,
                                     encryptingBytes,
                                     input.count,
                                     &outBytes,
                                     outBytes.count,
                                     &outLength)
                }
                guard status == kCCSuccess else {
                    throw Error.cryptoFailed(status: status)
                }
                data =  Data(bytes: UnsafePointer<UInt8>(outBytes), count: outLength)
            }
        }
        return data
        
    }
    

//    static func createKey(password: Data, salt: Data) throws -> Data {
//        let length = kCCKeySizeAES256
//        var status = Int32(0)
//        var derivedBytes = [UInt8](repeating: 0, count: length)
//        password.withUnsafeBytes { (passwordBytes: UnsafePointer<Int8>!) in
//            salt.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>!) in
//                status = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),                  // algorithm
//                    passwordBytes,                                // password
//                    password.count,                               // passwordLen
//                    saltBytes,                                    // salt
//                    salt.count,                                   // saltLen
//                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),   // prf
//                    10000,                                        // rounds
//                    &derivedBytes,                                // derivedKey
//                    length)                                       // derivedKeyLen
//            }
//        }
//        guard status == 0 else {
//            throw Error.keyGeneration(status: Int(status))
//        }
//        return Data(bytes: UnsafePointer<UInt8>(derivedBytes), count: length)
//    }
    
}

extension AESCrypter: Crypter {
    
    func encrypt(_ digest: Data) throws -> Data {
        return try crypt(input: digest, operation: CCOperation(kCCEncrypt))
    }
    
    func decrypt(_ encrypted: Data) throws -> Data {
        return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }
    
}



