//
//  UIActivityViewController+Make.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

extension UIActivityViewController {
    static func make(items: [Any]) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
}

