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
    var webView: WKWebView?
    var progressView: UIProgressView?
    var progressViewColor: UIColor = .blue {
        didSet {
            progressView?.tintColor = progressViewColor
        }
    }
    var webViewConfiguration: WKWebViewConfiguration?
    var url: URL
    private var lastProgress: Double = 0.0
    
    private struct Keys {
        static let estimatedProgress = "estimatedProgress"
    }
    
    //MARK: --- Life Cycle
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
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        webViewConfiguration = configuration
        //TODO: - layout consider navigation bar
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), configuration: configuration)
        webView?.allowsBackForwardNavigationGestures = true
        webView?.backgroundColor = .clear
        webView?.navigationDelegate = self
        webView?.scrollView.decelerationRate = .normal
        
        //monitor progress view
        webView?.addObserver(self, forKeyPath: Keys.estimatedProgress, options: .new, context: nil)
        view.addSubview(webView!)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView?.tintColor = progressViewColor
        progressView?.trackTintColor = .clear
        progressView?.frame = CGRect(x: 0, y: 0, width: webView!.frame.width, height: 3)
        webView?.bringSubviewToFront(progressView!)
        
        let request = URLRequest(url: url)
        webView?.load(request)
        
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
            progressView?.setProgress(Float(webView!.estimatedProgress), animated: true)
        }else {
            progressView?.setProgress(Float(webView!.estimatedProgress), animated: false)
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

extension BaseWkWebViewController: WKNavigationDelegate {
    
}
