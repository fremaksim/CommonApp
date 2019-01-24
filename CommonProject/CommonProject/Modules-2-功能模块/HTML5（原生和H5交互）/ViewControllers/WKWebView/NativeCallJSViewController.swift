//
//  NativeCallJSViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/23.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit
import MBProgressHUD

class NativeCallJSViewController: BaseWkWebViewController {
    
    /// 通过EvaluateJavaScript: handler 来调用JavaScript函数
    lazy var callJSButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("CallJsFunction", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(callJSFunction), for: .touchUpInside)
        button.backgroundColor = .red
        //        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(url: URL) {
        super.init(url: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(callJSButton)
        callJSButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.center.equalToSuperview()
        }
        
    }
    //点击Native按钮，调用JS中的函数, result 为JavaScript函数返回值
    @objc private func callJSFunction() {
        self.webView.evaluateJavaScript("testCallJs()") { (result, error) in
            if let error = error {
                print(error)
            }else {
                print(result)
            }
        }
        let value = "一个骄傲的参数"
        self.webView.evaluateJavaScript("callJsOneArgument('\(value)')") { (result, error) in
            if let error = error {
                print(error)
            }else {
                print(result)
            }
        }
    }
    
}
