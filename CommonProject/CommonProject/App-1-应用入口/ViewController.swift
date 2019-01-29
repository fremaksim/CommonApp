//
//  ViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/21.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit
import DeviceKit
import SnapKit
import Alamofire
import WCDBSwift

private let cellIdentifier = String(describing: UITableViewCell.self)

class ViewController: UIViewController {
    var touchCount = 0 {
        didSet {
            if touchCount == 0 {
                createWcdb()
            }
            
        }
    }
    let orderTable = "OrderTable"
    lazy var database: Database = {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("Order.db")
        let db = Database(withPath: path)
        return db
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        //        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        table.delegate  = self
        table.dataSource = self
        return table
    }()
    
    var deviceInfos = [String: String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //        deviceInfoView()
        //        getDeviceInfos()
        
        //                testAES_256_ECB()
        //        aes_256_ecb_objective_c()
        
        createWcdb()
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        //        normalWebView()
        //        nativeCallJs()
        //        JsCallNative()
        //        uiWebViewCallJS()
        
        //        alamofireRequest()
        wcdbOperation()
    }
    
    
    //MARK: - All For Test
    private func createWcdb() {
        do {
            try database.create(table: orderTable, of: Order.self)
        } catch  {
            print(error)
        }
    }
    
    private func incrementTouchCount(){
        touchCount += 1
        if touchCount >= 5 {
            touchCount = 1
        }
    }
    private func wcdbOperation() {
        incrementTouchCount()
        switch touchCount {
        case WCDBOperation.insert.rawValue:
            let sample = Order()
            sample.identifier = touchCount
            sample.description = "\(touchCount) order"
          try? database.insert(objects: sample, intoTable: orderTable)
        case WCDBOperation.find.rawValue:
            let objects: [Order] = try! database.getObjects(fromTable: orderTable)
            objects.forEach{
               print("\($0.description ?? "") \($0.identifier ?? 100)")
            }
            
        case WCDBOperation.update.rawValue:
            let sample = Order()
            sample.description = "Order update"
            try? database.update(table: orderTable, on: Order.Properties.description, with: sample, where: Order.Properties.identifier > 0)
        case WCDBOperation.delete.rawValue:
           try? database.delete(fromTable: orderTable)
        default:
            print("...None Operat")
        }
        let objects: [Order] = try! database.getObjects(fromTable: orderTable)
        objects.forEach{
            print("\($0.description ?? "") \($0.identifier ?? 100)")
        }
        PAirSandBoxSwift.shared.showSandboxBrowser()
        
//        PAirSandbox.sharedInstance()?.showBrowser()
    }
        private func alamofireRequest() {
            let scale = UIScreen.main.scale
            print("scale = \(scale)")
            let nativeScale = UIScreen.main.nativeScale
            print("nativeScale = \(nativeScale)")
            
            
            
            let testUrl = "http://itunes.apple.com/lookup?id=1384797792&country=cn"
            
            let session = SessionManager.default
            
            session.request(testUrl, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil).response { (response) in
                if let error = response.error {
                    print(error)
                }
                if let data = response.data {
                    do {
                        let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        print(json)
                    }catch {
                        print(error)
                    }
                }
            }
        }
        
        private func uiWebViewCallJS() {
            let urlString = "http://192.168.2.168/web/webkitSample/webCamera.html"
            let javaScriptCallUIWebViewVC = ExampleUIWebViewController(url: URL(string: urlString)!)
            navigationController?.pushViewController(javaScriptCallUIWebViewVC, animated: true)
        }
        
        private func JsCallNative() {
            let urlString = "http://192.168.2.168/web/webkitSample/JSToOC.html"
            let javaScriptCallNativeVC = JSCallNativeViewController(url: URL(string: urlString)!)
            navigationController?.pushViewController(javaScriptCallNativeVC, animated: true)
        }
        
        private func nativeCallJs() {
            let urlString = "http://192.168.2.168/web/webkitSample/JSToOC.html"
            let nativeCallJavaScriptVC = NativeCallJSViewController(url: URL(string: urlString)!)
            //        nativeCallJavaScriptVC.displayLoading(text: "Loading...", animated: true, applicationIgnoreAllEvent: true)
            navigationController?.pushViewController(nativeCallJavaScriptVC, animated: true)
        }
        
        private func normalWebView() {
            let urlString = "https://www.apple.com"
            //        urlString.urlEncode()
            
            if let url = URL(string: urlString) {
                let wkWebController = BaseWkWebViewController(url: url)
                navigationController?.pushViewController(wkWebController, animated: true)
            }
        }
        
        private func deviceInfoView() {
            view.addSubview(tableView)
            tableView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        private func aes_256_ecb_objective_c() {
            let key = "abcdefghijklmnopqrstuvwxyzABCDEF" //32-bytes
            //        let key = "abcde" //5-bytes
            let keyData = key.data(using: .utf8)!
            print("keyData bytes: \(keyData.count)")
            let content = "TechTutorialsX!TechTutorialsX!" //30-bytes
            var contentData = content.data(using: .utf8)!
            
            let keySize = 32 //AES256 key size
            let modulo = contentData.count % keySize
            
            //不能整除 padding
            //        if modulo != 0 {
            //            let appandingBytes = keySize - modulo
            //            //            let appandingZero = Array<Int>(repeating: 0, count: appandingBytes)
            //            let appanddingZeroData = Data.init(repeating: 0, count: appandingBytes)
            //            print("appanddingData bytes: \(appanddingZeroData.count)")
            //            contentData.append(appanddingZeroData)
            //        }
            
            print(contentData)
            //        let encryptedData = AESCipher.do(contentData, key: keyData, context: CCOperation(kCCEncrypt)) //32-bytes
            //
            //        let decryptedData = AESCipher.do(encryptedData, key: keyData, context: CCOperation(kCCDecrypt))
            //        let encryptedData =
            let settings = AESCipherSetting(type: AESCipherType256, padding: AESCipherPaddingZero, keyPadding: AESCipherKeyPaddingZero, operation: AESCipherOperationEncrypt)
            
            AESCipher.ecbCipher(contentData, key: keyData, settings: settings) { (data, error) in
                if error != AESCipherErrorNone {
                    
                }else {
                    print("encryptedData: \(data?.base64EncodedString())")
                    //重置为解密
                    settings.operation = AESCipherOperationDecrypt;
                    AESCipher.ecbCipher(data!, key: keyData, settings: settings, completion: { (data, error) in
                        if error != AESCipherErrorNone {
                            
                        }else{
                            print( "decryptedData \(String(data: data!, encoding: .utf8)!)")
                        }
                    })
                }
                
            } //32-bytes
            
            //        let decryptedData =
            //        print(encryptedData.base64EncodedString())
            //        print(String(data: decryptedData, encoding: .utf8)!)
            
        }
        
        private func testAES_256_ECB() {
            
            let key = "abcdefghijklmnopqrstuvwxyzABCDEF" // 32-bytes
            let keyData = key.data(using: .utf8)!
            
            //            let ivData = "iv".data(using: .utf8)!
            //        var ivData: Data? = nil
            
            //            let newKey = "abcdefg"
            //            let salt   = "%%EOF"
            //            let newKeyData = try AESCrypter.createKey(password: newKey.data(using: .utf8)!, salt: salt.data(using: .utf8)!)
            let newKeyData = key.data(using: .utf8)!
            
            print(newKeyData)
            
            let content = "TechTutorialsX!TechTutorialsX!"
            let contentData = content.data(using: .utf8)!
            
            do {
                let crypter = try AESCrypter(key: keyData, iv: nil)
                
                do {
                    let cryptedData = try crypter.encrypt(contentData)
                    
                    print("cryptedData: \(cryptedData)")
                    
                    let deencryptedData = try crypter.decrypt(cryptedData)
                    
                    print("dencryptedata:\(String(data: deencryptedData, encoding: .utf8))")
                } catch  {
                    print(error)
                }
                
            } catch  {
                print(error)
            }
            
        }
        
        private func getDeviceInfos() {
            let device = Device()
            deviceInfos["name"] = device.name
            deviceInfos["systemInfo"] = device.systemName + "  " + device.systemVersion
            if let totalCapacity = Device.volumeTotalCapacity {
                deviceInfos["totalCapacity"] = String(Double(totalCapacity) / 1_000_000_000.0) + "GB"
            }
            if let availableCapacity = Device.volumeAvailableCapacity {
                deviceInfos["availableCapacity"] = String(Double(availableCapacity) / 1_000_000_000.0) + "GB"
            }
            if let id = UIDevice.current.identifierForVendor {
                deviceInfos["identifierForVendor"] = id.uuidString
            }
            deviceInfos["screenRatio"] = "width: \(DeviceInfo.screenRatio.width), height: \(DeviceInfo.screenRatio.height)"
            
            tableView.reloadData()
        }
        
    }
    
    //MARK: --- UITableViewDatasource
    extension ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return deviceInfos.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            }
            
            for (index, item)  in  deviceInfos.enumerated() {
                if index == indexPath.row {
                    cell!.textLabel?.text = item.key
                    cell!.detailTextLabel?.text = item.value
                }
            }
            return cell!
        }
    }
    
    //MARK: --- UITableViewDelegate
    extension ViewController: UITableViewDelegate {
        
}

