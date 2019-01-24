//
//  UIView+CurrentController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

extension UIView {
    // 当前视图所在控制器
    var currentViewController: UIViewController? {
        var nextResponder: UIResponder? = next
        while nextResponder != nil {
            if nextResponder is UIViewController {
                return next as? UIViewController
            }
            nextResponder = next
        }
        return nil
    }
    
    var centerRect: CGRect {
        return CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
    }

}


//-(UIViewController *)getCurrentViewController{
//    UIResponder *next = [self nextResponder];
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = [next nextResponder];
//    } while (next != nil);
//    return nil;
//}

