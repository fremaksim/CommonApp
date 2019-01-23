//
//  JavaScriptHandler.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/23.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit
import WebKit

class JavaScriptHandler:NSObject, WKScriptMessageHandler {
    
    enum MessageKeys: String,CaseIterable {
        case backpage = "backpage"
    }
    
    var webViewController: BaseWkWebViewController
    var webViewConfiguration: WKWebViewConfiguration
    
    init(webViewController: BaseWkWebViewController,
         webViewConfiguration: WKWebViewConfiguration) {
        
        self.webViewController    = webViewController
        self.webViewConfiguration = webViewConfiguration
        
        super.init()
        
        //eg. backpage
        webViewConfiguration.userContentController.add(self, name: MessageKeys.backpage.rawValue)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == MessageKeys.backpage.rawValue {
            
        }
    }
    
    /// 移除注册的messageHandler
    ///
    /// - Parameter key: 根据key移除messageHandler，为nil则移除所有。
    func cancelHandler(_ key: String? = nil) {
        if let key = key {
            webViewConfiguration.userContentController.removeScriptMessageHandler(forName: key)
        }else {
            MessageKeys.allCases.map{$0.rawValue}.forEach {
                webViewConfiguration.userContentController.removeScriptMessageHandler(forName: $0)
            }
        }
    }
    
    
}
