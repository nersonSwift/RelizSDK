//
//  PopUpView.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

protocol RZPopUpViewProtocol: UIView{
    var closeClouser: (()->())! { get set }
    var backView: UIView { get }
    var backViewInstance: UIView? { get set }
}

open class RZPopUpView: UIView, RZPopUpViewProtocol{
    open var closeClouser: (() -> ())!
    open var backViewInstance: UIView?
    open var backView: UIView{
        let bv = UIView()
        bv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4877996575)
        return bv
    }
}


public protocol PopUpScreenProtocol: RZScreenControllerProtocol{
    var closeClosure: (()->())? { get set }
    var backView: UIView { get }
    var backViewInstance: UIView? { get set }
}
 
extension PopUpScreenProtocol{
    public var backView: UIView{
        let bv = UIView()
        bv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4877996575)
        return bv
    }
}
