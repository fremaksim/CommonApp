//
//  ExampleUIWebViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit
import JavaScriptCore

class ExampleUIWebViewController: BaseUIWebViewController {
    
    //MARK: --- Life Cycle
    override init(url: URL) {
        super.init(url: url)
    }
    
    //    private var bridge: JSBridge?
    private var jsContext: JSContext?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        monitorJavaScriptEvents()
    }
    
    private func monitorJavaScriptEvents() {
        guard let javaScriptContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else{ return }
        
        self.jsContext = javaScriptContext
        //        bridge = JSBridge()
        //        JSBridge.shared.delegate = self
        
        // 图片展示处理
        func showImages(_ dict: [String : Any]) {
            print(dict)
        }
        
        let iOSAppHandler: @convention(block) ([String: Any]) -> () = { dict in
            showImages(dict)
        }
        
        javaScriptContext.setObject(unsafeBitCast(iOSAppHandler.self, to: AnyObject.self), forKeyedSubscript: "iOSAppHandler" as (NSCopying & NSObjectProtocol))
        
        //相机调用处理
        let CallCameraHandler: @convention(block) () -> () = { [weak self] in
            print("调用相机")
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                print("相机不可用")
                return
            }
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType    = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self?.view.currentViewController?.present(imagePicker, animated: true, completion: nil)
        }
        javaScriptContext.setObject(unsafeBitCast(CallCameraHandler.self, to: AnyObject.self), forKeyedSubscript: "iOSCamera" as (NSCopying & NSObjectProtocol))
        
        //相册调用处理
        let CallPhotoAlbumHandler: @convention(block) () -> () = { [weak self] in
            print("访问相册")
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType    = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self?.view.currentViewController?.present(imagePicker, animated: true, completion: nil)
        }
        javaScriptContext.setObject(unsafeBitCast(CallPhotoAlbumHandler.self, to: AnyObject.self), forKeyedSubscript: "iOSPhotosAlbum" as (NSCopying & NSObjectProtocol))
        
    }
    
    
}

extension ExampleUIWebViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        print(info)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.001){
            var imageString = imageData.base64EncodedString(options: .lineLength64Characters)
            imageString.removeWhitespaceAndNewLines()
            
            
            //不能少了两个‘’单引号。
            var script = "rtnCamera('\(imageString)')"
            //            print(script)
            script.removeWhitespaceAndNewLines()
            
            jsContext?.evaluateScript(script)
        }
        
        self.view.currentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.view.currentViewController?.dismiss(animated: true, completion: nil)
    }
}


//extension ExampleUIWebViewController: JSBridgeProtocol {
//    class func showImages(_ dict: [String : Any]) {
//        print(dict)
//    }
//
//
//}

//MARK: - Override UIWebviewDelegate Methods
extension ExampleUIWebViewController {
    
    override func webView(_ webView: UIWebView,
                          shouldStartLoadWith request: URLRequest,
                          navigationType: UIWebView.NavigationType) -> Bool {
        //TODO: - Business Logic
        return true
    }
    
    override func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        progressView.setProgress(0, animated: true)
    }
    override func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
}
