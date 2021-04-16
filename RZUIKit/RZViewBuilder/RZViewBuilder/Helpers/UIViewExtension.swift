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

extension UIButton{
    private var labelViewKey: String {"labelView"}
    public var labelView: UIView? {
        set(labelView){
            if let labelViewOld = Associated(self).get(.hashable(labelViewKey)) as? UIView{ labelViewOld.removeFromSuperview() }
            guard let labelView = labelView else {return}
            labelView.isUserInteractionEnabled = false
            addSubview(labelView)
            self+>.width(labelView|*.w).height(labelView|*.h)
            Associated(self).set(labelView, .hashable(labelViewKey), .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            Associated(self).get(.hashable(labelViewKey)) as? UIView
        }
    }
    
    public var rzState: RZObservable<UIControl.State> { observeController.$controlState }
}

extension UIControl.State: Hashable {}
