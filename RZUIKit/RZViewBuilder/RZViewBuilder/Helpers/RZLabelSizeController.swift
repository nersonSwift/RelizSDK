//
//  RZLabelSizeController.swift
//  RelizKit
//
//  Created by Александр Сенин on 26.10.2020.
//

import UIKit
import RZObservableKit

class RZLabelSizeController{
    enum LabelSizeMod {
        case font(UIFont)
        case sizeToFit
    }
    
    static func setMod(_ view: UIView, _ mod: LabelSizeMod, _ value: Bool = true){
        let labelSize = getLabelSize(view)
        
        switch mod{
        case .sizeToFit:
            labelSize.view = view
            labelSize.sizeToFit = value
        default: break
        }
    }
    
    static func modUpdate(_ view: UIView, _ updateWidth: Bool = false){
        let labelSize = getLabelSize(view)
        if updateWidth { labelSize.defoultWidth = view.frame.width }
        labelSize.update()
    }
    
    private static func getLabelSize(_ view: UIView) -> RZLabelSize{
        let key = "RZLabelSize"
        var labelSize = Associated(view).get(.hashable(key)) as? RZLabelSize
        if labelSize == nil{
            labelSize = RZLabelSize()
            Associated(view).set(labelSize, .hashable(key), .OBJC_ASSOCIATION_RETAIN)
        }
        return labelSize!
    }
}

class RZLabelSize{
    weak var view: UIView?
    var sizeToFit: Bool = false
    var defoultWidth: CGFloat = .zero
    
    func update(){
        if sizeToFit {
            view?.frame.size.width = defoultWidth
            view?.sizeToFit()
        }
    }
    
}
