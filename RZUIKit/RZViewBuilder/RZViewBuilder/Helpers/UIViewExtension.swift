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
    private var titleViewKey: String {"titleView"}
    public var titleView: UIView? {
        set(titleView){
            if let titleViewOld = Associated(self).get(.hashable(titleViewKey)) as? UIView{ titleViewOld.removeFromSuperview() }
            guard let titleView = titleView else {return}
            titleView.isUserInteractionEnabled = false
            addSubview(titleView)
            self+>.width(titleView|*.w).height(titleView|*.h)
            Associated(self).set(titleView, .hashable(titleViewKey), .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            Associated(self).get(.hashable(titleViewKey)) as? UIView
        }
    }
    
    public var rzState: RZObservable<UIControl.State> { observeController.$controlState }
}

extension UIControl.State: Hashable {}
