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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        getDeviceInfos()
        
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

