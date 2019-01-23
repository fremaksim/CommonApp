//
//  NetwrokHelper.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/22.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    func monitorNetworkStatus(listener: @escaping NetworkReachabilityManager.Listener) {

        manager?.listener = { status in
            listener(status)
//            switch status {
//            case .unknown:
//                print("未知网络")
//            case .notReachable:
//                print("网络不可用")
//            case .reachable(let networkType):
//                switch networkType {
//                case .wwan:
//                    print("wwan")
//                case .ethernetOrWiFi:
//                    print("ethernetOrWifi")
//                }
//            }
        }
        manager?.startListening()
    }
}


