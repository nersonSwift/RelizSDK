//
//  ScreenController.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit
import RZObservableKit

//MARK: - ScreenControllerProtocol
/// `ru`: - протокол который используется для создания и переходов контроллеров
public protocol RZUIPacControllerNGProtocol: UIViewController{
    
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
    
    //MARK: - place
    /// `ru`: - UIView на которую установлен экран
    var place: UIView? { get set }
    
    //MARK: - pastScreen
     /// `ru`: - контроллер который архивируется для обратного перехода
    var pastUIPacC: RZUIPacControllerNGProtocol? { get set }
    
    
    //MARK: - funcs
    //MARK: - preparePac
    /// `ru`: - метод который вызывается до инициализации `UIPacV`
    func preparePac()
    
    //MARK: - initActions
    /// `ru`: - метод вызывается перед `start()` используется для инициализации наблюдателей и замыканий `UIPacR`
    func initActions()
    
    //MARK: - start
    /// `ru`: - метод который вызывается при первой устрановке экрана на представление
    func start()
    
    //MARK: - didCreated
    /// `ru`: - метод вызывается перед после метода `create()` в `UIPacV`
    func didCreated()
    
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
    
    //MARK: - rotate
    /// `ru`: - метод который вызывается при изменении размера
    func resize()
}

class RZUIPacControllerInterfase{
    var rotater: RZRotater?
    var isHorizontal: Bool = false
    
    var starting: Bool = false
    var inAnim = false
    var uiPacLine: String?
    var pastUIPacC: RZUIPacControllerNGProtocol?
    weak var place: UIView?
}

extension RZUIPacControllerNGProtocol{
    public func preparePac(){}
    public func initActions(){}
    public func start(){}
    public func didCreated(){}
    
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
    public var pastUIPacC: RZUIPacControllerNGProtocol? {
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
    
    public var place: UIView?{
        set(place){
            uiPacControllerInterfase.place = place
        }
        get{
            uiPacControllerInterfase.place
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
public protocol RZUIPacControllerViewingProtocol: RZUIPacControllerRouteredProtocol, RZSetUIPacViewProtocol{
    //MARK: - iPhonePresenter
    /// `ru`: - свойство которое которое должно вернуть тип `RZUIPacView` который будет инициализирован для версии `iPhone`
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? { get }
    
    //MARK: - iPadPresenter
    /// `ru`: - свойство которое которое должно вернуть тип `RZUIPacView` который будет инициализирован для версии `iPad`
    var iPadViewType: RZUIPacAnyViewProtocol.Type? { get }
    
    //MARK: - iPadPresenter
    /// `ru`: - свойство которое которое должно вернуть тип `RZUIPacView` который будет инициализирован для версии `Mac`
    var macViewType: RZUIPacAnyViewProtocol.Type? { get }
}

extension RZUIPacControllerViewingProtocol{
    public var iPhoneViewType: RZUIPacAnyViewProtocol.Type? { nil }
    public var iPadViewType: RZUIPacAnyViewProtocol.Type? { nil }
    public var macViewType: RZUIPacAnyViewProtocol.Type? { nil }
    
    public func setView(){
        router.setRZObservables()
        if view is RZUIPacViewNGProtocol {return}
        var rzUIView: UIView?
        #if targetEnvironment(macCatalyst)
            if let macViewType = macViewType{
                rzUIView = macViewType.createUIPacView(router)
            }
        #else
            if UIDevice.current.userInterfaceIdiom == .pad, let iPadRZUIPacView = iPadViewType{
                rzUIView = iPadRZUIPacView.createUIPacView(router)
            }else if UIDevice.current.userInterfaceIdiom == .phone, let iPhoneRZUIPacView = iPhoneViewType{
                rzUIView = iPhoneRZUIPacView.createUIPacView(router)
            }
        #endif
        view = rzUIView ?? view
    }
    
    public func rotate(){ (view as? RZUIPacViewNGProtocol)?.rotate() }
    public func resize(){ (view as? RZUIPacViewNGProtocol)?.resize() }
}

public class SomeUIPacRouter: RZUIPacRouter {}
public protocol RZUIPacControllerRouteredProtocol: RZUIPacControllerNGProtocol{
    associatedtype UIPacRouter: RZUIPacRouterProtocol
    var router: UIPacRouter {get set}
}

extension RZUIPacControllerRouteredProtocol where Self: RZUIPacControllerProtocol{
    public var router: SomeUIPacRouter{
        set{}
        get{SomeUIPacRouter()}
    }
}



public typealias RZUIPacControllerProtocol = RZUIPacControllerNGProtocol & RZUIPacControllerViewingProtocol

public typealias RZUIPacController = UIViewController & RZUIPacControllerProtocol
public typealias RZUIPacNavigationController = UINavigationController & RZUIPacControllerProtocol
public typealias RZUIPacTabBarController = UITabBarController & RZUIPacControllerProtocol


