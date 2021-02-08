//
//  RZProto.swift
//  RelizKit
//
//  Created by Александр Сенин on 21.10.2020.
//

import UIKit

//MARK: - RZProto
/// `RU: -`
/// Структура для облегчения вычеслений при адаптивной верстке
public struct RZProto {
    private var frame: CGRect?
    private weak var view: UIView?
    
    //MARK: - init
    /// Инициализирует `RZProto` с помощью `UIView`
    ///
    /// При использовании `RZViewBuilder` возможно создать наблюдение за изменением размера или местоположения `view`
    ///
    /// Для облегчения синтакиса поддерживаются операторы:
    ///
    ///     let view = UIView()
    ///     view*  //RZProto(view)
    ///     view|* //RZProto(view, true)
    ///
    /// - Parameter view
    /// `UIView` по которой строится `RZProto`
    public init(_ view: UIView, _ observe: Bool = false){
        if observe{
            self.view = view
        }else{
            frame = view.frame
        }
    }
    
    /// Инициализирует `RZProto` с помощью `CGRect`
    ///
    /// Для облегчения синтакиса поддерживается оператор:
    ///
    ///     let frame = CGRect(x: 10, y: 20, width: 55, height: 100)
    ///     frame*  //RZProto(frame)
    ///
    /// - Parameter frame
    /// `CGRect` по которой строится `RZProto`
    public init(_ frame: CGRect){
        self.frame = frame
    }
    
    /// Инициализирует `RZProto` с помощью `CGSize`
    ///
    /// Для облегчения синтакиса поддерживается оператор:
    ///
    ///     let size = CGSize(width: 55, height: 100)
    ///     size*  //RZProto(size)
    ///
    /// - Parameter size
    /// `CGSize` по которой строится `RZProto`
    public init(_ size: CGSize){
        frame = CGRect(origin: .zero, size: size)
    }
    
    /// Инициализирует `RZProto` с помощью `CGPoint`
    ///
    /// Для облегчения синтакиса поддерживается оператор:
    ///
    ///     let point = CGPoint(x: 10, y: 20)
    ///     point*  //RZProto(size)
    ///
    /// - Parameter point
    /// `CGPoint` по которой строится `RZProto`
    public init(_ point: CGPoint){
        frame = CGRect(origin: point, size: .zero)
    }
    
    /// Инициализирует `RZProto`
    ///
    /// При пустой инициализации и использовании `RZViewBuilder` создает `RZProto` по редактируемому view
    public init() {}
    
    /// `RZProtoValue` эквиволентное ширине
    ///
    ///     let view = UIView()
    ///     view.frame.size.width = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.width(view*.w)
    ///
    ///     print(view1.frame.width) // 100.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.size.width = 100
    ///
    ///     view+>.height(RZProto().w) // == view+>.height(.selfTag(.w))
    ///
    ///     print(view.frame.height)   // 100.0
    public var w: RZProtoValue {
        guard let val = frame?.width else { return RZProtoValue(.w, view) }
        return RZProtoValue(val)
    }
    
    /// `RZProtoValue` эквиволентное высоте
    ///
    ///     let view = UIView()
    ///     view.frame.size.height = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.height(view*.h)
    ///
    ///     print(view1.frame.height) // 100.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.size.height = 100
    ///
    ///     view+>.width(RZProto().h) // == view+>.height(.selfTag(.h))
    ///
    ///     print(view.frame.width)   // 100.0
    public var h: RZProtoValue {
        guard let val = frame?.height else { return RZProtoValue(.h, view) }
        return RZProtoValue(val)
    }
    
    /// `RZProtoValue` эквиволентное карденате по x
    ///
    ///     let view = UIView()
    ///     view.frame.origin.x = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.x(view*.x)
    ///
    ///     print(view1.frame.minX) // 100.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.origin.x = 100
    ///
    ///     view+>.y(RZProto().x) // == view+>.y(.selfTag(.x))
    ///
    ///     print(view.frame.y)   // 100.0
    public var x: RZProtoValue {
        guard let val = frame?.minX else { return RZProtoValue(.x, view) }
        return RZProtoValue(val)
    }
    
    /// `RZProtoValue` эквиволентное карденате по x
    ///
    ///     let view = UIView()
    ///     view.frame.origin.y = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.y(view*.y)
    ///
    ///     print(view1.frame.minY) // 100.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.origin.y = 100
    ///
    ///     view+>.x(RZProto().y) // == view+>.y(.selfTag(.y))
    ///
    ///     print(view.frame.x)   // 100.0
    public var y: RZProtoValue {
        guard let val = frame?.minY else { return RZProtoValue(.y, view) }
        return RZProtoValue(val)
    }
    
    /// `RZProtoValue` эквиволентное карденате центра по x
    ///
    ///     let view = UIView()
    ///     view.frame.size.width = 100
    ///     view.frame.origin.x = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.x(view*.cX)
    ///
    ///     print(view1.frame.minX) // 150.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.size.width = 100
    ///     view.frame.origin.x = 100
    ///
    ///     view+>.y(RZProto().сX) // == view+>.y(.selfTag(.cX))
    ///
    ///     print(view.frame.y)   // 150.0
    public var cX: RZProtoValue {
        guard let val = frame?.midX else { return RZProtoValue(.cX, view) }
        return RZProtoValue(val)
    }
    
    /// `RZProtoValue` эквиволентное карденате центра по y
    ///
    ///     let view = UIView()
    ///     view.frame.size.height = 100
    ///     view.frame.origin.y = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.y(view*.cY)
    ///
    ///     print(view1.frame.minY) // 150.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.size.height = 100
    ///     view.frame.origin.y = 100
    ///
    ///     view+>.x(RZProto().сY) // == view+>.x(.selfTag(.cY))
    ///
    ///     print(view.frame.x)   // 150.0
    public var cY: RZProtoValue {
        guard let val = frame?.midY else { return RZProtoValue(.cY, view) }
        return RZProtoValue(val)
    }
    
    /// `RZProtoValue` эквиволентное собственной карденате центра по x
    ///
    ///     let view = UIView()
    ///     view.frame.size.width = 100
    ///     view.frame.origin.x = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.x(view*.scX)
    ///
    ///     print(view1.frame.minX) // 50.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.size.width = 100
    ///     view.frame.origin.x = 100
    ///
    ///     view+>.y(RZProto().sсX) // == view+>.y(.selfTag(.scX))
    ///
    ///     print(view.frame.y)   // 50.0
    public var scX: RZProtoValue {
        guard let val = frame?.width else { return RZProtoValue(.scX, view) }
        return RZProtoValue(val / 2)
    }
    
    /// `RZProtoValue` эквиволентное собственной карденате центра по y
    ///
    ///     let view = UIView()
    ///     view.frame.size.height = 100
    ///     view.frame.origin.y = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.y(view*.scY)
    ///
    ///     print(view1.frame.minY) // 50.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.size.height = 100
    ///     view.frame.origin.y = 100
    ///
    ///     view+>.x(RZProto().sсY) // == view+>.x(.selfTag(.scY))
    ///
    ///     print(view.frame.x)   // 50.0
    public var scY: RZProtoValue {
        guard let val = frame?.height else { return RZProtoValue(.scY, view) }
        return RZProtoValue(val / 2)
    }
    
    /// `RZProtoValue` эквиволентное карденате конца по x
    ///
    ///     let view = UIView()
    ///     view.frame.size.width = 100
    ///     view.frame.origin.x = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.x(view*.mX)
    ///
    ///     print(view1.frame.minX) // 200.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.size.width = 100
    ///     view.frame.origin.x = 100
    ///
    ///     view+>.y(RZProto().mX) // == view+>.y(.selfTag(.mX))
    ///
    ///     print(view.frame.y)   // 200.0
    public var mX: RZProtoValue {
        guard let val = frame?.maxX else { return RZProtoValue(.mX, view) }
        return RZProtoValue(val)
    }
    
    /// `RZProtoValue` эквиволентное карденате центра по y
    ///
    ///     let view = UIView()
    ///     view.frame.size.height = 100
    ///     view.frame.origin.y = 100
    ///
    ///     let view1 = UIView()
    ///     view1+>.y(view*.mY)
    ///
    ///     print(view1.frame.minY) // 200.0
    ///
    /// При использовании пустого инициализатора
    ///
    ///     let view = UIView()
    ///     view.frame.size.height = 100
    ///     view.frame.origin.y = 100
    ///
    ///     view+>.x(RZProto().mY) // == view+>.x(.selfTag(.mY))
    ///
    ///     print(view.frame.x)   // 200.0
    public var mY: RZProtoValue {
        guard let val = frame?.maxY else { return RZProtoValue(.mY, view) }
        return RZProtoValue(val)
    }
}
