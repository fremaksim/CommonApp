//
//  DeviceInfo.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/22.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation
import DeviceKit

struct DeviceInfo {
    static let name          = Device().name
    static let systemVersion = Device().systemVersion
    static let systemName    = Device().systemName
    static var identifierForVendor: String? = UIDevice.current.identifierForVendor?.uuidString
    // in bytes
    static var totalCapacity: Int? = Device.volumeTotalCapacity
    // in bytes
    static var availableCapacity: Int? = Device.volumeAvailableCapacity
    
    static let batteryState: Device.BatteryState  = Device().batteryState
    //仅主屏幕明亮度 0-100
    static let screen  = Device().screenBrightness
    /// Returns screen ratio as a tuple(width: Double, height: Double)
    static let screenRatio  = Device().screenRatio
    static let screenWidth  = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

