//
//  UIApplication.swift
//  RZUIPacKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import Foundation

extension UIApplication{
    public static var orientation: UIInterfaceOrientation{
        shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait
    }
}
