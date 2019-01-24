//
//  BaseUIWebViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/23.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit
import SwiftWebViewProgress
import JavaScriptCore

class BaseUIWebViewController: BaseViewController {
    
    //MARK: --- Life Cycle
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.tintColor = .blue
        view.trackTintColor = .clear
        return view
    }()
    
    lazy var webView: UIWebView = {
        let view = UIWebView(frame: .zero)
        view.delegate = self
        
        view.addSubview(progressView)
        return view
    }()
    
    var url: URL
    
    var progressProxy: WebViewProgress!
    
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            //TODO: - adopt iPhonx X+
            make.top.equalTo(64)
        }
        progressView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3)
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        
        
        progressProxy = WebViewProgress()
        webView.delegate = progressProxy
        progressProxy.webViewProxyDelegate = self
        progressProxy.progressDelegate = self
        
    }
    
    
}
extension BaseUIWebViewController: WebViewProgressDelegate {
    func webViewProgress(_ webViewProgress: WebViewProgress, updateProgress progress: Float) {
        progressView.alpha = 1.0
        progressView.setProgress(progress, animated: true)
        if progress >= 1.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.progressView.alpha = 0.0
                self.progressView.progress = 0.0
            }
        }
    }
}

extension BaseUIWebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebView.NavigationType) -> Bool {
        //TODO: - Business Logic
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        progressView.setProgress(0, animated: true)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
}
