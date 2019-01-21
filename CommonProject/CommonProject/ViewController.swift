//
//  ViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/21.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let strings = ["文","戊戌","百日维新aa","远征队113","毒液9090wq",""]
        
        for str in strings {
            if String.isAvailableLength(str: str, miniLength: 4, maxlength: 10) == true {
                print(str,"true", separator: ",", terminator: ".")
            }else {
                print(str,"false", separator: ",", terminator: ".")
            }
            print(str.count)
    }
        

    }
}

