//
//  JSCallNativeViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/23.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit
import JavaScriptCore

class JSCallNativeViewController: BaseWkWebViewController {
    
    override init(url: URL) {
        super.init(url: url)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitorJavaScriptEvents()
    }
    
    private func monitorJavaScriptEvents() {
        
        let javaScriptContext = JSContext()
        
        javaScriptContext?.exceptionHandler = { (context, except) in
            print(context)
            print(except)
        }
        
    }
    
    
}
