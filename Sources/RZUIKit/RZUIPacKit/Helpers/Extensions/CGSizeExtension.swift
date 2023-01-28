//
//  CGSizeExtension.swift
//  RZUIPacKit
//
//  Created by Александр Сенин on 25.03.2021.
//

import UIKit

extension CGSize{
    var isHorizontal: Bool { width > height }
    
    mutating func swap(){
        self = .init(width: height, height: width)
    }
}
