//
//  BaseWkWebViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/23.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit
import WebKit

class BaseWkWebViewController: BaseViewController {
    //MARK: - WkWebView
    var webView: WKWebView!
    var progressView: UIProgressView?
    var progressViewColor: UIColor = .blue {
        didSet {
            progressView?.tintColor = progressViewColor
        }
    }
    var webViewConfiguration: WKWebViewConfiguration?
    var jsHandler: JavaScriptHandler?
    var url: URL
    private var lastProgress: Double = 0.0
    
    private struct Keys {
        static let estimatedProgress = "estimatedProgress"
        static let tel = "tel"
        static let appStore = "itunes.apple.com"
    }
    
    //MARK: --- Life Cycle
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        
        let userController = WKUserContentController()
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.userContentController = userController
        webViewConfiguration = configuration
        
        jsHandler = JavaScriptHandler(webViewController: self, webViewConfiguration: configuration)
        //TODO: - layout consider navigation bar
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = .clear
        webView.navigationDelegate = self
        webView.scrollView.decelerationRate = .normal
        webView?.uiDelegate = self
        
        //monitor progress view
        webView.addObserver(self, forKeyPath: Keys.estimatedProgress, options: .new, context: nil)
        //        view.addSubview(webView!)
        view = webView
        //        webView?.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView?.tintColor = progressViewColor
        progressView?.trackTintColor = .clear
        progressView?.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 3)
        webView.addSubview(progressView!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        jsHandler?.cancelHandler()
        removeObserver(self, forKeyPath: Keys.estimatedProgress)
    }
    
    override func setupViews() {
        super.setupViews()
        
        
        let request = URLRequest(url: url)
        webView?.load(request)
        
        if #available(iOS 11.0, *) {
            self.webView?.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets  = false
        }
        
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
        
        if let key = keyPath, key == Keys.estimatedProgress {
            
            updateProgressView(webView!.estimatedProgress)
        }
        
    }
    
    private func updateProgressView(_ progress: Double){
        progressView?.alpha = 1.0
        if progress > lastProgress {
            let settingProgess = Float(webView!.estimatedProgress)
            //            print(settingProgess)
            progressView?.setProgress(settingProgess, animated: true)
            progressView?.progress = settingProgess
        }else {
            progressView?.setProgress(Float(webView!.estimatedProgress), animated: false)
            //             progressView?.progress = Float(progress)
        }
        lastProgress = progress
        
        if progress >= 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.progressView?.alpha = 0.0
                self.progressView?.setProgress(0, animated: false)
                self.lastProgress = 0
            }
        }
        
    }
    
}
extension BaseWkWebViewController: WKUIDelegate {
    
}

extension BaseWkWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        //         updateProgressView(webView.estimatedProgress)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        print(#function)
        //        updateProgressView(webView.estimatedProgress)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function)
        //        updateProgressView(webView.estimatedProgress)
        if webView != self.webView {
            decisionHandler(.allow)
            return
        }
        //打开WkWebView禁用了打电话和打开App Store
        let app = UIApplication.shared
        guard let url = webView.url else {
            decisionHandler(.allow)
            return
        }
        if let scheme = url.scheme, scheme == Keys.tel {
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
            decisionHandler(.cancel)
            return
        }
        if url.absoluteString.contains(Keys.appStore) {
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
        
    }
    
}
