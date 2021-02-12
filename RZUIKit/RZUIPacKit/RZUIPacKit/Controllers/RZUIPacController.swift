//
//  ScreenController.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit
#if canImport(RZViewBuilder)
    import RZViewBuilder
#endif

//MARK: - ScreenControllerProtocol
/// `ru`: - протокол который используется для создания и переходов контроллеров
public protocol RZUIPacControllerNJProtocol: UIViewController{
    
    //MARK: - propertes
    //MARK: - starting
    /// `ru`: - данное свойство устанавливается на `true` когда контроллер был установлен
    var starting: Bool { get set }
    
    //MARK: - inAnim
    /// `ru`: - данное свойство устанавливается на `true` когда контроллер находится в анимации
    var inAnim: Bool { get set }
    
    //MARK: - screenLine
    /// `ru`: - данное свойство отображает идетификатор линии в которой находится
    var uiPacLine: String? { get set }
    
    //MARK: - isHorizontal
    /// `ru`: - данное свойство отображает ориентацию контроллера
    var isHorizontal: Bool { get set }
    
    //MARK: - rotater
    /// `ru`: - класс отвечающий за орентацию котроллера в представлении
    var rotater: RZRotater? { get set }
    
    //MARK: - pastScreen
     /// `ru`: - контроллер который архивируется для обратного перехода
    var pastUIPacC: RZUIPacControllerNJProtocol? { get set }
    
    
    //MARK: - funcs
    //MARK: - start
    /// `ru`: - метод который вызывается при первой устрановке экрана на представление
    func start()
    
    //MARK: - open
    /// `ru`: - метод который вызывается при каждой установке экрана на представление
    func open()
    
    //MARK: - close
    /// `ru`: - метод который вызывается при каждом закрытии экрана
    func close()
    
    //MARK: - completedOpen
    /// `ru`: -  метод который вызывается при каждой установке экрана на представление после анимации
    func completedOpen()
    
    //MARK: - completedClose
    /// `ru`: - метод который вызывается при каждом закрытии экрана после анимации
    func completedClose()
    
    //MARK: - rotate
    /// `ru`: - метод который вызывается при изменении ориентации
    func rotate()
    
    func resize()
}

class RZUIPacControllerInterfase{
    var rotater: RZRotater?
    var isHorizontal: Bool = false
    
    var starting: Bool = false
    var inAnim = false
    var uiPacLine: String?
    var pastUIPacC: RZUIPacControllerNJProtocol?
}

extension RZUIPacControllerNJProtocol{
    public func start(){}
    public func open(){}
    public func close(){}
    public func completedOpen(){}
    public func completedClose(){}
    public func rotate(){}
    public func resize(){}
    
    public func closeWindow(){rootViewController?.close()}
    
    private var key: UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: 16)
    }
    
    private var uiPacControllerInterfase: RZUIPacControllerInterfase {
        if let key = key, let uiPacControllerInterfase = objc_getAssociatedObject(self, key) as? RZUIPacControllerInterfase{
            return uiPacControllerInterfase
        }
        let uiPacControllerInterfase = RZUIPacControllerInterfase()
        
        if let key = key{
            objc_setAssociatedObject(self, key, uiPacControllerInterfase, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return uiPacControllerInterfase
    }
        
    public var rotater: RZRotater? {
        set(rotater){
            uiPacControllerInterfase.rotater = rotater
        }
        get{
            uiPacControllerInterfase.rotater
        }
    }
    public var isHorizontal: Bool {
        set(isHorizontal){
            uiPacControllerInterfase.isHorizontal = isHorizontal
        }
        get{
            uiPacControllerInterfase.isHorizontal
        }
    }
    public var starting: Bool {
        set(starting){
            uiPacControllerInterfase.starting = starting
        }
        get{
            uiPacControllerInterfase.starting
        }
    }
    public var inAnim: Bool {
        set(inAnim){
            uiPacControllerInterfase.inAnim = inAnim
        }
        get{
            uiPacControllerInterfase.inAnim
        }
    }
    public var uiPacLine: String? {
        set(uiPacLine){
            uiPacControllerInterfase.uiPacLine = uiPacLine
        }
        get{
            uiPacControllerInterfase.uiPacLine
        }
    }
    public var pastUIPacC: RZUIPacControllerNJProtocol? {
        set(pastUIPacC){
            uiPacControllerInterfase.pastUIPacC = pastUIPacC
        }
        get{
            uiPacControllerInterfase.pastUIPacC
        }
    }
    
    public var rootViewController: RZRootController?{
        var parent = self.parent
        while true {
            if let parentL = parent{
                if let root = parentL as? RZRootController{
                    return root
                }else{
                    parent = parentL.parent
                }
            }else{
                return nil
            }
        }
    }
    
    public init() {
        self.init(nibName: nil, bundle: nil)
    }
}

public protocol RZSetUIPacViewProtocol {
    func setView()
}

//MARK: - ScreenController
/// `ru`: - расширение для `ScreenControllerProtocol` позволяющее делигировать ликику представления в `Presenter`
public protocol RZUIPacControllerViewingProtocol: RZUIPacControllerNJProtocol, RZSetUIPacViewProtocol{
    associatedtype UIPA: RZUIPacViewNoJenericProtocol
    
    //MARK: - propertes
    //MARK: - presenter
    /// `ru`: - свойство которое инициализируется типом указанным в классе реализующем данный протокол
    var rzUIView: UIPA? { get set }
    
    //MARK: - iPhonePresenter
    /// `ru`: - свойство которое которое должно вернуть тип `Presenter` который будет инициализирован для версии `iPhone`
    var iPhoneRZUIPacView: RZUIPacViewNoJenericProtocol? { get }
    
    //MARK: - iPadPresenter
    /// `ru`: - свойство которое которое должно вернуть тип `Presenter` который будет инициализирован для версии `iPad`
    var iPadRZUIPacView: RZUIPacViewNoJenericProtocol? { get }
    
    var macRZUIPacView: RZUIPacViewNoJenericProtocol? { get }
}

public class SomeUIPacView: UIView, RZUIPacViewNoJenericProtocol{ public func create() {} }

extension RZUIPacControllerViewingProtocol{
    public var rzUIView: SomeUIPacView?{
        set{}
        get{SomeUIPacView()}
    }
    public var iPhoneRZUIPacView: RZUIPacViewNoJenericProtocol? { nil }
    public var iPadRZUIPacView: RZUIPacViewNoJenericProtocol? { nil }
    public var macRZUIPacView: RZUIPacViewNoJenericProtocol? { nil }
    
    public func setView(){
        #if targetEnvironment(macCatalyst)
            if let macRZUIPacView = macRZUIPacView{
                rzUIView = macRZUIPacView as? Self.UIPA
            }
        #else
            if UIDevice.current.userInterfaceIdiom == .pad, let iPadRZUIPacView = iPadRZUIPacView{
                rzUIView = iPadRZUIPacView as? Self.UIPA
            }else if UIDevice.current.userInterfaceIdiom == .phone, let iPhoneRZUIPacView = iPhoneRZUIPacView{
                rzUIView = iPhoneRZUIPacView as? Self.UIPA
            }
        #endif
        #if canImport(RZViewBuilder)
            router.setRZObservables()
        #endif
        if let rzUIView = view as? UIPA{
            self.rzUIView = rzUIView
        }else{
            view = rzUIView ?? view
        }
        rzUIView?.setUIPacC(self)
    }
    
    public func rotate(){ rzUIView?.rotate() }
    public func resize(){ rzUIView?.resize() }
}

public class SomeUIPacRouter<T: RZUIPacControllerProtocol>: RZUIPacRouter {
    public typealias Controller = T
}
public protocol RZUIPacControllerRouteredProtocol: RZUIPacControllerNJProtocol{
    associatedtype UIPacRouter: RZUIPacRouterProtocol
    var router: UIPacRouter {get set}
}

extension RZUIPacControllerRouteredProtocol where Self: RZUIPacControllerProtocol{
    public var router: SomeUIPacRouter<Self> {
        set{}
        get{SomeUIPacRouter()}
    }
}



public typealias RZUIPacControllerProtocol = RZUIPacControllerNJProtocol &
                                             RZUIPacControllerViewingProtocol &
                                             RZUIPacControllerRouteredProtocol

public typealias RZUIPacController = UIViewController & RZUIPacControllerProtocol
public typealias RZUIPacNavigationController = UINavigationController & RZUIPacControllerProtocol
public typealias RZUIPacTabBarController = UITabBarController & RZUIPacControllerProtocol


