//
//  ScreenController.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

//MARK: - ScreenControllerProtocol
/// `ru`: - протокол который используется для создания и переходов контроллеров
public protocol RZScreenControllerProtocol: UIViewController{
    
    //MARK: - propertes
    //MARK: - starting
    /// `ru`: - данное свойство устанавливается на `true` когда контроллер был установлен
    var starting: Bool { get set }
    
    //MARK: - inAnim
    /// `ru`: - данное свойство устанавливается на `true` когда контроллер находится в анимации
    var inAnim: Bool { get set }
    
    //MARK: - screenLine
    /// `ru`: - данное свойство отображает идетификатор линии в которой находится
    var screenLine: String? { get set }
    
    //MARK: - isHorizontal
    /// `ru`: - данное свойство отображает ориентацию контроллера
    var isHorizontal: Bool { get set }
    
    //MARK: - rotater
    /// `ru`: - класс отвечающий за орентацию котроллера в представлении
    var rotater: RZRotater? { get set }
    
    //MARK: - pastScreen
     /// `ru`: - контроллер который архивируется для обратного перехода
    var pastScreen: RZScreenControllerProtocol? { get set }
    
    
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

class ScreenControllerInterfase{
    var rotater: RZRotater?
    var isHorizontal: Bool = false
    
    var starting: Bool = false
    var inAnim = false
    var screenLine: String?
    var pastScreen: RZScreenControllerProtocol?
}

extension RZScreenControllerProtocol{
    public func start(){}
    public func open(){}
    public func close(){}
    public func completedOpen(){}
    public func completedClose(){}
    public func rotate(){}
    public func resize(){}
    
    private var key: UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: 16)
    }
    
    private var screenControllerInterfase: ScreenControllerInterfase {
        if let key = key, let screenControllerInterfase = objc_getAssociatedObject(self, key) as? ScreenControllerInterfase{
            return screenControllerInterfase
        }
        let screenControllerInterfase = ScreenControllerInterfase()
        
        if let key = key{
            objc_setAssociatedObject(self, key, screenControllerInterfase, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return screenControllerInterfase
    }
        
    public var rotater: RZRotater? {
        set(rotater){
            screenControllerInterfase.rotater = rotater
        }
        get{
            screenControllerInterfase.rotater
        }
    }
    public var isHorizontal: Bool {
        set(isHorizontal){
            screenControllerInterfase.isHorizontal = isHorizontal
        }
        get{
            screenControllerInterfase.isHorizontal
        }
    }
    public var starting: Bool {
        set(starting){
            screenControllerInterfase.starting = starting
        }
        get{
            screenControllerInterfase.starting
        }
    }
    public var inAnim: Bool {
        set(inAnim){
            screenControllerInterfase.inAnim = inAnim
        }
        get{
            screenControllerInterfase.inAnim
        }
    }
    public var screenLine: String? {
        set(screenLine){
            screenControllerInterfase.screenLine = screenLine
        }
        get{
            screenControllerInterfase.screenLine
        }
    }
    public var pastScreen: RZScreenControllerProtocol? {
        set(pastScreen){
            screenControllerInterfase.pastScreen = pastScreen
        }
        get{
            screenControllerInterfase.pastScreen
        }
    }
    
    public init() {
        self.init(nibName: nil, bundle: nil)
    }
}

public protocol RZSetPresenterProtocol {
    func setPresenter()
}

//MARK: - ScreenController
/// `ru`: - расширение для `ScreenControllerProtocol` позволяющее делигировать ликику представления в `Presenter`
public protocol RZScreenControllerPresentingProtocol: RZScreenControllerProtocol, RZSetPresenterProtocol{
    associatedtype SPDP: RZPresenterNoJenericProtocol
    
    //MARK: - propertes
    //MARK: - presenter
    /// `ru`: - свойство которое инициализируется типом указанным в классе реализующем данный протокол
    var presenter: SPDP? { get set }
    
    //MARK: - iPhonePresenter
    /// `ru`: - свойство которое которое должно вернуть тип `Presenter` который будет инициализирован для версии `iPhone`
    var iPhonePresenter: RZPresenterNoJenericProtocol.Type? { get }
    
    //MARK: - iPadPresenter
    /// `ru`: - свойство которое которое должно вернуть тип `Presenter` который будет инициализирован для версии `iPad`
    var iPadPresenter: RZPresenterNoJenericProtocol.Type? { get }
    
    var macPresenter: RZPresenterNoJenericProtocol.Type? { get }
}

extension RZScreenControllerPresentingProtocol{
    public var iPhonePresenter: RZPresenterNoJenericProtocol.Type? { nil }
    public var iPadPresenter: RZPresenterNoJenericProtocol.Type? { nil }
    public var macPresenter: RZPresenterNoJenericProtocol.Type? { nil }
    
    public func setPresenter(){
        if UIDevice.current.userInterfaceIdiom == .pad, let type = iPadPresenter{
            presenter = type.init(installableScreen: self) as? Self.SPDP
        }else if UIDevice.current.userInterfaceIdiom == .phone, let type = iPhonePresenter{
            presenter = type.init(installableScreen: self) as? Self.SPDP
        }else if #available(iOS 14.0, *), UIDevice.current.userInterfaceIdiom == .mac, let type = macPresenter{
            presenter = type.init(installableScreen: self) as? Self.SPDP
        }else{
            presenter = SPDP.init(installableScreen: self)
        }
        
        if let presenter = presenter as? RZScreenModelSeterNJ{
            presenter.setModel()
        }
    }
    
    public func rotate(){ presenter?.rotate() }
    
    public func resize(){ presenter?.resize() }
}


public typealias RZScreenController = UIViewController & RZScreenControllerProtocol
public typealias RZScreenControllerPresenting = RZScreenController & RZScreenControllerPresentingProtocol

public typealias RZScreenNavigationController = UINavigationController & RZScreenControllerProtocol
public typealias RZScreenNavigationControllerPresenting = RZScreenNavigationController & RZScreenControllerPresentingProtocol

public typealias RZScreenTabBarController = UITabBarController & RZScreenControllerProtocol
public typealias RZScreenTabBarControllerPresenting = RZScreenTabBarController & RZScreenControllerPresentingProtocol


