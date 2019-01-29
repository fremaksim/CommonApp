//
//  Order.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/28.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation
import WCDBSwift

enum WCDBOperation: Int {
    case insert = 1
    case find
    case update
    case delete
}


class Order: Decodable {
    var identifier: Int? = nil
    var description: String? = nil
}

extension Order: TableCodable {
    enum CodingKeys: String, CodingTableKey {
        
        typealias Root = Order
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        
        case identifier
        case description
    }
}

