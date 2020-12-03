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


class ScreensInstaller{
    static var inAnimation: Bool = false
    static var needOpen: RZScreenControllerProtocol?
    
    //MARK: - in
    static func installScreen(in viewController: UIViewController,
                              view: UIView? = nil,
                              installingScreen: RZScreenControllerProtocol,
                              animation: RZTransitionAnimation? = nil) -> Bool{
        if viewController == installingScreen{return false}
        setChild(viewController, view, installingScreen)
        started(installingScreen)
        installingScreen.open()
        
        
        installingScreen.inAnim = true
        inAnimation = true
        
        let end = {
            installingScreen.inAnim = false
            self.inAnimation = false
            installingScreen.completedOpen()
        }
        
        animation?.funcAnim(nil, installingScreen.rotater, installingScreen.rotater?.superview ?? UIView(), end) ?? end()
        return true
    }
    
    //MARK: - instead
    static func installScreen(instead screen: RZScreenControllerProtocol,
                              installingScreen: RZScreenControllerProtocol? = nil,
                              archive: Bool = false,
                              pastScreen: RZScreenControllerProtocol? = nil,
                              saveTranslite: Bool = true,
                              setLine: Bool = true,
                              animation: RZTransitionAnimation? = nil) -> Bool{
        
        if saveTranslite && (inAnimation || (installingScreen?.inAnim == true)){
            return false
        }
        
        if archive{
            var pastScreen = pastScreen
            if pastScreen == nil{
                pastScreen = screen
            }
            installingScreen?.pastScreen = pastScreen
        }
        screen.close()
        if let installingScreen = installingScreen, let parent = screen.parent{
            if screen == installingScreen {return false}
            if let selectLine = screen.screenLine, setLine{ RZLineController.setControllerInLine(selectLine, installingScreen) }
            setChild(parent, screen.rotater?.superview, installingScreen)
            started(installingScreen)
            installingScreen.open()
        }
        
        installingScreen?.inAnim = true
        inAnimation = true
        
        let end = {
            installingScreen?.inAnim = false
            self.inAnimation = false
            installingScreen?.completedOpen()
            screen.completedClose()
            
            removeChild(screen)
        }
        
        animation?.funcAnim(screen.rotater, installingScreen?.rotater, screen.rotater?.superview ?? UIView(), end) ?? end()
        
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
    
    private static func setChild(_ viewController: UIViewController, _ view: UIView?, _ screen: RZScreenControllerProtocol){
        let view: UIView = view ?? viewController.view
        screen.view.frame = view.bounds
        view.addSubview(screen.view)
        
        
        viewController.addChild(screen)
        screen.didMove(toParent: viewController)
        
        screen.rotater = RZRotater(viewController: screen)
        screen.rootViewController?.roatateCild()
    }
    
    private static func removeChild(_ viewController: UIViewController){
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
        (viewController as? RZScreenController)?.rotater?.removeFromSuperview()
    }
    
    private static func started(_ screen: RZScreenControllerProtocol){
        
        if !screen.starting{
            if let delegating = screen as? RZSetPresenterProtocol{
                delegating.setPresenter()
            }
            
            screen.start()
            screen.starting = true
        }
    }
    
    static func prepare(_ transitionType: RZTransition.TransitionType, _ screen: UIViewController) -> RZTransition{
        return RZTransition(transitionType, screen)
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
    
    private weak var _screen: UIViewController?
    private weak var _view: UIView?
    
    private var _pastScreen: RZScreenControllerProtocol?
    private var _installingScreen: RZScreenControllerProtocol?
    private var _archive: Bool = false
    private var _saveTranslite: Bool = true
    
    private var _animationO: RZTransitionAnimation?
    private var _animationC: RZTransitionAnimation?
    
    private var _selectLine: String?
    private var _setLine: Bool = true
    private var _popUp: RZPopUpViewProtocol?
    
    
    public init(_ transitionType: TransitionType, _ screen: UIViewController? = nil){
        self.transitionType = transitionType
        _screen = screen
    }
    
    public convenience init(_ transitionType: TransitionType, _ line: String){
        self.init(transitionType, RZLineController.getControllerInLine(line)!)
    }
    
    public convenience init(_ transitionType: TransitionType, _ line: RZScreenLines){
        self.init(transitionType, line.id)
    }
    
    @discardableResult
    public func view(_ view: UIView) -> RZTransition {
        _view = view
        return self
    }
    
    @discardableResult
    public func back() -> RZTransition{
        return screen((_screen as? RZScreenController)?.pastScreen)
    }
    
    @discardableResult
    public func screen(_ screen: RZScreenControllerProtocol?) -> RZTransition {
        _installingScreen = screen
        return self
    }
    
    @discardableResult
    public func popUp(_ screen: RZPopUpViewProtocol?) -> RZTransition {
        _popUp = screen
        return self
    }
    
    @discardableResult
    public func line(_ string: String) -> RZTransition {
        
        _selectLine = string
        _installingScreen = RZLineController.getControllerInLine(string) ?? _installingScreen
        _setLine = false
        return self
    }
    
    @discardableResult
    public func line(_ screenLine: RZScreenLines) -> RZTransition {
        return line(screenLine.id)
    }
    
    @discardableResult
    public func setLine(_ setLine: Bool) -> RZTransition {
        _setLine = setLine
        return self
    }
    
    @discardableResult
    public func archive(_ pastScreen: RZScreenControllerProtocol? = nil) -> RZTransition {
        _archive = true
        _pastScreen = pastScreen
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
            guard let _screen = _screen else {return false}
            guard let _installingScreen = _installingScreen else {return false}
            return ScreensInstaller.installScreen(in: _screen, view: _view, installingScreen: _installingScreen, animation: _animationO)
        case .Instead:
            guard let _screen = _screen as? RZScreenControllerProtocol else {return false}
            let test = ScreensInstaller.installScreen(instead: _screen,
                                                      installingScreen: _installingScreen,
                                                      archive: _archive,
                                                      pastScreen: _pastScreen,
                                                      saveTranslite: _saveTranslite,
                                                      setLine: _setLine,
                                                      animation: _animationO)
            
            return test
        case .PopUp:
            guard let _screen = _view else { return false}
            guard let _popUp = _popUp else { return false }
            ScreensInstaller.installPopUp(in: _screen,
                                          installingPopUpView: _popUp,
                                          anim: _animationO ?? .shiftLeftPopUp,
                                          anim: _animationC ?? .shiftRightPopUp)
            return true
        #if targetEnvironment(macCatalyst)
        case .Window:
            guard let _installingScreen = _installingScreen else {return false}
            let screenLine = _installingScreen.screenLine ?? _selectLine ?? ""
            if screenLine == ""{
                _installingScreen.screenLine = "window"
            }
            ScreensInstaller.needOpen = _installingScreen
            
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: nil, options: nil, errorHandler: nil)
            
            return true
        #endif
        }
        
    }
    
}



