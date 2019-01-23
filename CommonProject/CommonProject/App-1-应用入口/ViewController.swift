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

private let cellIdentifier = String(describing: UITableViewCell.self)

class ViewController: UIViewController {
    
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
        getDeviceInfos()
        
//        testAES_256_ECB()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let urlString = "https://www.apple.com"
//        urlString.urlEncode()
        
        if let url = URL(string: urlString) {
            let wkWebController = BaseWkWebViewController(url: url)
            navigationController?.pushViewController(wkWebController, animated: true)
        }
    }
    
    //MARK: - All For Test
    private func deviceInfoView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func testAES_256_ECB() {
   
            let key = "abcdefghijklmnopqrstuvwxyzABCDEF" // 32-bytes
            let keyData = key.data(using: .utf8)!
        
//            let ivData = "iv".data(using: .utf8)!
            var ivData: Data? = nil
        
//            let newKey = "abcdefg"
//            let salt   = "%%EOF"
//            let newKeyData = try AESCrypter.createKey(password: newKey.data(using: .utf8)!, salt: salt.data(using: .utf8)!)
           let newKeyData = key.data(using: .utf8)!
        
            print(newKeyData)
            
            let content = "TechTutorialsX!TechTutorialsX!"
            let contentData = content.data(using: .utf8)!
            
            do {
                let crypter = try AESCrypter(key: keyData, iv: ivData)
                
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

