//
//  Data+CryptoSwift.swift
//  CommonProject
//
//  Created by mozhe on 2019/2/12.
//  Copyright © 2019 mozhe. All rights reserved.
//

//import Foundation
//import CryptoSwift
//
//extension Data {
//
//    func aesEncrypt(withKey key: String) -> Data? {
//        do {
//            let aes = try AES(key: key.bytes, blockMode: ECB(), padding: .zeroPadding)
//            let bytes = try aes.encrypt(self.bytes)
//            return Data(bytes: bytes)
//        }
//        catch {
//            return nil
//        }
//    }
//
//    func aesDecrypt(withKey key: String) -> Data? {
//        do {
//            let aes = try AES(key: key.bytes, blockMode: ECB(), padding: .zeroPadding)
//            let bytes = try aes.decrypt(self.bytes)
//            return Data(bytes: bytes)
//        }
//        catch {
//            return nil
//        }
//    }
//}
