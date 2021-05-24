//
//  ScreensInstallerNew.swift
//  NewArc
//
//  Created by Александр Сенин on 18.06.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit
// MARK: - ScreenPresenterDelegateProtocol

// MARK: - InstallableScreenProtocol


class UIPacInstaller{
    static var inAnimation: Bool = false
    static var needOpen: RZUIPacControllerNGProtocol?
    
    //MARK: - in
    static func installUIPacC(in viewController: UIViewController,
                              view: UIView? = nil,
                              installingUIPacC: RZUIPacControllerNGProtocol,
                              animation: RZTransitionAnimation? = nil) -> Bool{
        if viewController == installingUIPacC{return false}
        setView(installingUIPacC)
        setChild(viewController, view, installingUIPacC)
        started(installingUIPacC)
        installingUIPacC.open()
        
        
        installingUIPacC.inAnim = true
        inAnimation = true
        
        let end = {
            installingUIPacC.inAnim = false
            self.inAnimation = false
            installingUIPacC.completedOpen()
        }
        
        animation?.funcAnim(nil, installingUIPacC.rotater, installingUIPacC.rotater?.superview ?? UIView(), end) ?? end()
        return true
    }
    
    //MARK: - instead
    static func installUIPacC(instead uiPacC: RZUIPacControllerNGProtocol,
                              installingUIPacC: RZUIPacControllerNGProtocol? = nil,
                              archive: Bool = false,
                              pastUIPacC: RZUIPacControllerNGProtocol? = nil,
                              saveTranslite: Bool = true,
                              setLine: Bool = true,
                              animation: RZTransitionAnimation? = nil) -> Bool{
        
        if saveTranslite && (inAnimation || (installingUIPacC?.inAnim == true)){
            return false
        }
        
        if archive{
            var pastUIPacC = pastUIPacC
            if pastUIPacC == nil{
                pastUIPacC = uiPacC
            }
            installingUIPacC?.pastUIPacC = pastUIPacC
        }
        uiPacC.close()
        if let installingUIPacC = installingUIPacC, let parent = uiPacC.parent{
            if uiPacC == installingUIPacC {return false}
            if let selectLine = uiPacC.uiPacLine, setLine{ RZLineController.setControllerInLine(selectLine, installingUIPacC) }
            setView(installingUIPacC)
            setChild(parent, uiPacC.rotater?.superview, installingUIPacC)
            started(installingUIPacC)
            installingUIPacC.open()
        }
        
        installingUIPacC?.inAnim = true
        inAnimation = true
        
        let end = {
            installingUIPacC?.inAnim = false
            self.inAnimation = false
            installingUIPacC?.completedOpen()
            uiPacC.completedClose()
            
            removeChild(uiPacC)
        }
        
        animation?.funcAnim(uiPacC.rotater, installingUIPacC?.rotater, uiPacC.rotater?.superview ?? UIView(), end) ?? end()
        
        return true
    }
    
    static func installPopUp(in view: UIView,
                             installingPopUpView: RZPopUpViewProtocol,
                             anim open: RZTransitionAnimation = .shiftLeftPopUp,
                             anim close: RZTransitionAnimation = .shiftRightPopUp
    ){
        let backView = installingPopUpView.backView
        backView.frame = view.bounds
        view.addSubview(backView)
        view.addSubview(installingPopUpView)
        installingPopUpView.backViewInstance = backView
        open.funcAnim(nil, installingPopUpView, backView, {})
        
       installingPopUpView.closeClouser = {[weak installingPopUpView] in
           guard let unInstallingPopUpView = installingPopUpView else {return}
        
           close.funcAnim(nil, unInstallingPopUpView, backView, {[weak installingPopUpView] in
               guard let unInstallingPopUpView = installingPopUpView else {return}
               unInstallingPopUpView.removeFromSuperview()
               backView.removeFromSuperview()
           })
       }
    }
    
    private static func setChild(_ viewController: UIViewController, _ view: UIView?, _ uiPacC: RZUIPacControllerNGProtocol){
        let view: UIView = view ?? viewController.view
        uiPacC.view.frame = view.bounds
        view.addSubview(uiPacC.view)
        
        
        viewController.addChild(uiPacC)
        uiPacC.didMove(toParent: viewController)
        
        uiPacC.rotater = RZRotater(viewController: uiPacC)
        uiPacC.rootViewController?.roatateCild(false)
    }
    
    private static func setView(_ uiPacC: RZUIPacControllerNGProtocol){
        if !uiPacC.starting{
            uiPacC.preparePac()
            if let delegating = uiPacC as? RZSetUIPacViewProtocol{
                delegating.setView()
            }
        }
    }
    
    private static func removeChild(_ viewController: UIViewController){
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
        (viewController as? RZUIPacControllerNGProtocol)?.rotater?.removeFromSuperview()
    }
    
    private static func started(_ uiPacC: RZUIPacControllerNGProtocol){
        if !uiPacC.starting{
            let uiPacV = uiPacC.view as? RZUIPacViewNGProtocol
            uiPacC.initActions()
            uiPacV?.initActions()
            uiPacC.start()
            uiPacV?.create()
            if uiPacV != nil{ uiPacC.didCreated() }
            uiPacC.starting = true
        }
    }
    
    static func prepare(_ transitionType: RZTransition.TransitionType, _ uiPacC: UIViewController) -> RZTransition{
        return RZTransition(transitionType, uiPacC)
    }
    
    static func prepare(_ transitionType: RZTransition.TransitionType, _ line: String) -> RZTransition{
        return RZTransition(transitionType, line)
    }
}

public class RZTransition{
    public enum TransitionType {
        case In
        case Instead
        case PopUp
        #if targetEnvironment(macCatalyst)
        case Window
        #endif
    }
    
    private var transitionType: TransitionType
    
    private weak var _uiPacC: UIViewController?
    private weak var _view: UIView?
    
    private var _pastUIPacC: RZUIPacControllerNGProtocol?
    private var _installingUIPacC: RZUIPacControllerNGProtocol?
    private var _archive: Bool = false
    private var _saveTranslite: Bool = true
    
    private var _animationO: RZTransitionAnimation?
    private var _animationC: RZTransitionAnimation?
    
    private var _selectLine: String?
    private var _setLine: Bool = true
    private var _popUp: RZPopUpViewProtocol?
    
    
    public init(_ transitionType: TransitionType, _ uiPacC: UIViewController? = nil){
        self.transitionType = transitionType
        _uiPacC = uiPacC
    }
    
    public convenience init(_ transitionType: TransitionType, _ line: String){
        self.init(transitionType, RZLineController.getControllerInLine(line)!)
    }
    
    public convenience init(_ transitionType: TransitionType, _ line: RZUIPacLines){
        self.init(transitionType, line.id)
    }
    
    @discardableResult
    public func view(_ view: UIView) -> RZTransition {
        _view = view
        return self
    }
    
    @discardableResult
    public func back() -> RZTransition{
        return uiPacC((_uiPacC as? RZUIPacControllerNGProtocol)?.pastUIPacC)
    }
    
    @discardableResult
    public func uiPacC(_ uiPacC: RZUIPacControllerNGProtocol?) -> RZTransition {
        _installingUIPacC = uiPacC
        return self
    }
    
    @discardableResult
    public func popUp(_ uiPacC: RZPopUpViewProtocol?) -> RZTransition {
        _popUp = uiPacC
        return self
    }
    
    @discardableResult
    public func line(_ string: String) -> RZTransition {
        _selectLine = string
        _installingUIPacC = RZLineController.getControllerInLine(string) ?? _installingUIPacC
        _setLine = false
        return self
    }
    
    @discardableResult
    public func line(_ uiPacCLine: RZUIPacLines) -> RZTransition {
        return line(uiPacCLine.id)
    }
    
    @discardableResult
    public func setLine(_ setLine: Bool) -> RZTransition {
        _setLine = setLine
        return self
    }
    
    @discardableResult
    public func archive(_ pastUIPacC: RZUIPacControllerNGProtocol? = nil) -> RZTransition {
        _archive = true
        _pastUIPacC = pastUIPacC
        return self
    }
    
    @discardableResult
    public func saveTranslite(_ saveTranslite: Bool) -> RZTransition {
        _saveTranslite = saveTranslite
        return self
    }
    
    public enum AnimationState {
        case open
        case close
    }
    
    @discardableResult
    public func animation(_ animation: RZTransitionAnimation, state: AnimationState = .open) -> RZTransition {
        switch state {
        case .open:
            _animationO = animation
        case .close:
            _animationC = animation
        }
        return self
    }
    
    @discardableResult
    public func transit() -> Bool{
        switch transitionType {
        case .In:
            guard let _uiPacC = _uiPacC else {return false}
            guard let _installingUIPacC = _installingUIPacC else {return false}
            return UIPacInstaller.installUIPacC(in: _uiPacC, view: _view, installingUIPacC: _installingUIPacC, animation: _animationO)
        case .Instead:
            guard let _uiPacC = _uiPacC as? RZUIPacControllerNGProtocol else {return false}
            let test = UIPacInstaller.installUIPacC(instead: _uiPacC,
                                                    installingUIPacC: _installingUIPacC,
                                                    archive: _archive,
                                                    pastUIPacC: _pastUIPacC,
                                                    saveTranslite: _saveTranslite,
                                                    setLine: _setLine,
                                                    animation: _animationO)
            
            return test
        case .PopUp:
            guard let _view = _view else { return false}
            guard let _popUp = _popUp else { return false }
            UIPacInstaller.installPopUp(in: _view,
                                        installingPopUpView: _popUp,
                                        anim: _animationO ?? .shiftLeftPopUp,
                                        anim: _animationC ?? .shiftRightPopUp)
            return true
        #if targetEnvironment(macCatalyst)
        case .Window:
            guard let _installingUIPacC = _installingUIPacC else {return false}
            let uiPacLine = _installingUIPacC.uiPacLine ?? _selectLine ?? ""
            if uiPacLine == ""{
                _installingUIPacC.uiPacLine = "window"
            }
            UIPacInstaller.needOpen = _installingUIPacC
            
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: nil, options: nil, errorHandler: nil)
            
            return true
        #endif
        }
        
    }
    
}




