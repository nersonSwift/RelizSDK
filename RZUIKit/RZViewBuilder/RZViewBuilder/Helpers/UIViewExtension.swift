//
//  UIViewExtension.swift
//  RZViewBuilder
//
//  Created by Александр Сенин on 09.03.2021.
//

import UIKit
import RZObservableKit

extension UIView{
    private var observeControllerKey: String {"RZObserveController"}
    var observeController: RZObserveController{
        if let observeController = Associated(self).get(.hashable(observeControllerKey)) as? RZObserveController{
            return observeController
        }else{
            let observeController = RZObserveController(self)
            Associated(self).set(observeController, .hashable(observeControllerKey), .OBJC_ASSOCIATION_RETAIN)
            return observeController
        }
    }
    
}

extension UIScrollView{
    public var rzContentOffsetX: RZObservable<RZProtoValue>{ observeController.$rzContentOffsetX }
    public var rzContentOffsetY: RZObservable<RZProtoValue>{ observeController.$rzContentOffsetY }
}
