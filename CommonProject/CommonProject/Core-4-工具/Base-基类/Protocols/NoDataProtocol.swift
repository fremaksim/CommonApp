//
//  NoDataProtocol.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/23.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation
import UIKit

protocol NoDataProtocol {
    
    var noDataImageView: UIImageView {set get}
    
    func showNoDataImage()
    func removeNoDataImage()
}

