//
//  UIViewExtension.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import UIKit

extension UIView{
    public static var isAnimation: Bool {
        let view = UIView()
        view.alpha = 0
        return view.layer.animationKeys() != nil
    }
}

