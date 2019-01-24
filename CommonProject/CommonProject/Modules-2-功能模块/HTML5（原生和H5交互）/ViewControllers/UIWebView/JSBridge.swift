//
//  JSBridge.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JSBridgeProtocol: JSExport{
    //为和JS定义的方法 只能静态方法
    static func showImages(_ dict: [String: Any])
}

//class JSBridge: NSObject {
//    
//    static let shared = JSBridge()
//    
//    weak var delegate: JSBridgeProtocol?
//
////    init(delegate: JSBridgeProtocol?) {
////        self.delegate = delegate
////
////        super.init()
////    }
//    
//   class func showImages(_ dict: [String: Any]) {
//        print("\(#function)",dict)
//        if let delegate = JSBridge.shared.delegate {
//            delegate.showImages(dict)
//        }
//    }
//
//}
