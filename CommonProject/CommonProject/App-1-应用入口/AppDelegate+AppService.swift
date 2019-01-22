//
//  AppDelegate+AppService.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/22.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    /// 监听网络状态改变
    func monitorNetworkStatus() {
        NetworkManager.shared.monitorNetworkStatus { (status) in
            switch status {
            case .unknown:
                print("未知网络")
            case .notReachable:
                print("网络不可用")
            case .reachable(let networkType):
                switch networkType {
                case .wwan: //手机网络
                    print("wwan")
                case .ethernetOrWiFi:
                    print("ethernetOrWifi")
                }
            }
        }
    }
    
    
    
}
