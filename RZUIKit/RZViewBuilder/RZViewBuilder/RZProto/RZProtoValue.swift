//
//  RZProtoValue.swift
//  RelizKit
//
//  Created by Александр Сенин on 21.10.2020.
//

import UIKit

//MARK: - RZProtoValue
/// `RU: -`
/// Структура для упрощения синтаксиса верстки
///
/// Для упрощения синтаксиса постфикс * для `CGFloat` преобразует значение в `RZProtoValue`
///
///     let value: CGFloat = 5
///     let proto = value*           // == RZProtoValue(value)
///
/// Поддерживает опирации (F: CGFloat, PV: RZProtoValue):
///
/// `PV + PV, PV - PV, PV * PV, PV / PV, F % PV, PV <> PV, PV >< PV, -PV`
///
/// Исходные значения:
///
///     let view = UIView()
///     view.frame.size.width = 100
///     view.frame.size.height = 100
///     view.frame.origin.x = 100
///     view.frame.origin.y = 100
///
///     let view1 = UIView()
///     view1.frame.size.width = 100
///     view1.frame.size.height = 100
///     view1.frame.origin.x = 100
///     view1.frame.origin.y = 500
///
///     let view2 = UIView()
///
/// Опирации:
///
///     // PV + PV - складывает 2 RZProtoValue
///     // view.frame.width + 20 == 100 + 20 == 120.0
///     view2+>.width(view*.w + 20*)
///     print(view2.frame.width)     // 120.0
///
///     // PV - PV - вычитает из первого второе RZProtoValue
///     // view.frame.width - 20 == 100 - 20 == 80.0
///     view2+>.width(view*.w - 20*)
///     print(view2.frame.width)     // 80.0
///
///     // PV * PV - умнажает 2 RZProtoValue
///     // view.frame.width * 3 == 100 * 3 == 300.0
///     view2+>.width(view*.w * 3*)
///     print(view2.frame.width)     // 300.0
///
///     // PV / PV - делет первое на второе RZProtoValue
///     // view.frame.width / 2 == 100 / 2 == 50.0
///     view2+>.width(view*.w / 2*)
///     print(view2.frame.width)     // 50.0
///
///     // F % PV - находит процент(%) от RZProtoValue
///     // view.frame.height * 0.2 == (100 / 100) * 20 == 20.0
///     view2+>.height(20 % view*.h)
///     print(view2.frame.height)    // 20.0
///
///     // PV <> PV - вычисляет растояние между двумя RZProtoValue
///     // порядок опирантов не имеет значения
///     // view1.frame.minY - view.frame.maxY == 500 - 200 == 300.0
///     view2+>.height(view*.mY <> view1*.y)
///     print(view2.frame.height)    // 300.0
///
///     // PV >< PV - вычисляет центр между двумя RZProtoValue
///     // порядок опирантов не имеет значения
///     // view.frame.maxY + ((view1.frame.minY - view.frame.maxY) / 2) ==
///     // == 200 + ((500 - 200) / 2) == 350.0
///     view2+>.y(view1*.y >< view*.mY, .center)
///     print(view2.frame.midY)      // 350.0
///
///     // -PV - реверсирует процент(%) RZProtoValue.
///     // Работает только с опиратором (%)
///     // view1.frame.minY - (view1.frame.minY * 0.05) ==
///     // == 500 - (500 / 100 * 5) == 480
///     view2+>.y(5 % -view1*.y, .down)
///     print(view2.frame.maxY)      // 480.0
///
/// Так-же поддерживается возможность сложных опираций:
///
///     // let distance = view1.frame.minY - view.frame.maxY
///     // distance == 500 - 200 == 300
///     // let center = view.frame.maxY + (distance / 2)
///     // center == 200 + (300 / 2) == 350
///     // center - view1.frame.width * 0.05 ==
///     // == 350 - (100 / 100 * 5) == 345
///     view2+>.y((view1*.y >< view*.mY) - (5 % view1*.w), .center)
///     print(view2.frame.midY)      // 345
///
/// Все опирации поддверживают `.selfTag`
///
///     view2.frame.size.width = 200
///     view2+>.height(10 % .selfTag(.w))
///     print(view2.frame.height) // 20
///
/// Все опирации поддверживают наблюдение
///
///     view2+>
///         .width((50 % view|*.w) + 30*)
///         .height((20 % view|*.h) / 2*)
///
///     print(view2.frame.width)   // 80
///     print(view2.frame.height)  // 10
///
///     view.frame.size.width = 200
///     view.frame.size.height = 400
///
///     print(view2.frame.width)   // 130
///     print(view2.frame.height)  // 40
public struct RZProtoValue{
    private var value: CGFloat?
    private var selfTag: RZProtoTag?
    private var procent: CGFloat?
    private var reverst: Bool = false
    private weak var observView: UIView?
    
    private var range: RZProtoValueGoup?
    
    public enum RZProtoTag{
        case w
        case h
        
        case x
        case y
        
        case cX
        case cY
        
        case scX
        case scY
        
        case mX
        case mY
    }
    
    // MARK: - selfTag
    /// `RU: -`
    /// Служит для пометки обращения к редактируемому `UIView` при использовании `RZViewBuilder`
    ///
    ///     let view = UIView()+>
    ///         .width(100)
    ///         .height(.selfTag(.w))
    ///         .view
    ///
    ///     print(view.frame.height) // 100
    ///
    /// - Parameter value
    /// Тег имеющий такую же симвализацию как и `RZProto`
    public static func selfTag(_ value: RZProtoTag) -> RZProtoValue{
        return Self.init(value)
    }
    
    // MARK: - screenTag
    /// Создает `RZProtoValue`  относительно размеров экрана
    ///
    /// - Parameter value
    /// Тег имеющий такую же симвализацию как и `RZProto`
    public static func screenTag(_ value: RZProtoTag) -> RZProtoValue{
        let proto = RZProto(UIScreen.main.bounds)
        switch value {
            case .w: return proto.w
            case .h: return proto.h
            
            case .x: return proto.x
            case .y: return proto.y
            
            case .cX: return proto.cX
            case .cY: return proto.cY
                
            case .scX: return proto.scX
            case .scY: return proto.scY
            
            case .mX: return proto.mX
            case .mY: return proto.mY
        }
    }
    
    func getValue(_ frame: CGRect = .zero) -> CGFloat{
        if let range = range { return range.getValue(frame) }
        
        let frame = observView?.frame ?? frame
        
        var value = self.value
        switch selfTag {
            case .h: value = frame.height
            case .w: value = frame.width
            
            case .x: value = frame.minX
            case .y: value = frame.minY
            
            case .cX: value = frame.midX
            case .cY: value = frame.midY
            
            case .scX: value = frame.width / 2
            case .scY: value = frame.height / 2
            
            case .mX: value = frame.maxX
            case .mY: value = frame.maxY
        default: break
        }
        
        if let procent = procent, let value = value{
            let valueL = value / 100 * procent
            return reverst ? value - valueL : valueL
        }
        
        if let value = value{
            return reverst ? -value : value
        }
        
        return 0
    }
    
    func setValueIn(_ view: UIView, _ tag: RZObserveController.Tag, _ remove: Bool = true,  _ closure: @escaping ((UIView) -> ())){
        let key = "RZObserveController"
    
        var observeController = Associated(view).get(.hashable(key)) as? RZObserveController
        if observeController == nil{
            observeController = RZObserveController()
            Associated(view).set(observeController, .hashable(key), .OBJC_ASSOCIATION_RETAIN)
        }
        if remove{
            observeController?.remove(tag)
        }
        checkObserv(view, tag, self, observeController, closure)
        
        closure(view)
    }
    
    private func checkObserv(_ view: UIView,
                             _ tag: RZObserveController.Tag,
                             _ protoValue: RZProtoValue,
                             _ observeController: RZObserveController?,
                             _ closure: @escaping ((UIView) -> ())){
        if let observView = observView{
            observeController?.add(view, observView, tag, selfTag, closure)
        }
        if let range = range{
            range.spaceFirst.checkObserv(view, tag, protoValue, observeController, closure)
            range.spaceSecond.checkObserv(view, tag, protoValue, observeController, closure)
        }
    }
    
    init(_ value: CGFloat){
        self.value = value
    }
    init(_ selfTag: RZProtoTag, _ observ: UIView? = nil){
        self.selfTag = selfTag
        self.observView = observ
    }
    init(){}
    
    public static func %(left: CGFloat, right: RZProtoValue) -> RZProtoValue{
        var right = right
        right.procent = left
        return right
    }
    
    public static func %(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var right = right
        right.procent = left.value
        return right
    }
    
    public static func +(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueGoup(left, right, .p)
        return value
    }
    
    public static func -(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueGoup(left, right, .m)
        return value
    }
    
    public static func /(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueGoup(left, right, .d)
        return value
    }
    
    public static func *(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueGoup(left, right, .u)
        return value
    }
    
    
    public static func <>(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueGoup(left, right, .rang)
        return value
    }
    public static func ><(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueGoup(left, right, .center)
        return value
    }
    public static prefix func -(right: RZProtoValue) -> RZProtoValue{
        var right = right
        right.reverst.toggle()
        return right
    }
    
    public static func value(_ value: CGFloat) -> RZProtoValue{
        RZProtoValue(value)
    }
}


class RZObserveController{
    enum Tag: String {
        case cornerRadius
        
        case width
        case height
        case x
        case y
        
        case tx
        case ty
        
        case ta
        case tb
        case tc
        case td
        
        case contentWidth
        case contentHeight
        
        var pointer: UnsafeRawPointer { UnsafeRawPointer(bitPattern: rawValue.hashValue)! }
    }
    
    
    var observes: [(Tag, [RZObserve])] = []
    
    func add(_ view: UIView,
             _ observeView: UIView,
             _ tag: Tag,
             _ protoTag: RZProtoValue.RZProtoTag?,
             _ closure: @escaping (UIView) -> ()){
        observes.forEach{ $0.1.forEach{ $0.removeObserve()} }
        
        let observe = RZObserve()
        observe.view = view
        observe.observeView = observeView
        observe.tag = tag
        observe.protoTag = protoTag
        //observe.observeTag = observeTag
        observe.closure = closure
        
        var setFlag = true
        var observesL = [(Tag, [RZObserve])]()
        for (key, value) in observes{
            if key == tag{
                var value = value
                value.append(observe)
                observesL.append((key, value))
                setFlag = false
            }else{
                observesL.append((key, value))
            }
        }
        if setFlag{
            observesL.append((tag, [observe]))
        }
        observes = observesL
        
        observes.reversed().forEach{
            $0.1.forEach{
                
                $0.setObserve()
            }
        }
        
    }
    
    func remove(_ tag: Tag){
        observes = observes.filter{ $0.0 != tag }
        
    }
}

class RZObserve{
    var keys: [NSKeyValueObservation?] = []
    var closure: ((UIView) -> ())?
    var tag: RZObserveController.Tag = .cornerRadius
    var protoTag: RZProtoValue.RZProtoTag?
    weak var view: UIView?
    weak var observeView: UIView?
    
    func setObserve(){
        let observeKey = observeView?.observe(\.frame, options: [.old]) {[weak self] (_, test) in
            guard let self = self else {return}
            guard let view = self.view else {return}
            guard let observeView = self.observeView else {return}
            guard let protoTag = self.protoTag else {return}
            guard var old = test.oldValue else {return}
                
            old.size.width -= observeView.frame.width
            old.size.height -= observeView.frame.height
            old.origin.x -= observeView.frame.minX
            old.origin.y -= observeView.frame.minY
                
            if protoTag == .w || protoTag == .scX, old.width == 0 {return}
            if protoTag == .h || protoTag == .scY, old.height == 0 {return}
                
            if protoTag == .x, old.minX == 0 {return}
            if protoTag == .y, old.minY == 0 {return}
                
            if protoTag == .cX || protoTag == .mX, old.width == 0 && old.minX == 0 {return}
            if protoTag == .cY || protoTag == .mY, old.height == 0 && old.minY == 0 {return}
            
            var ifWidth: Bool {
                (self.tag == .width || self.tag == .ta || self.tag == .tb || self.tag == .tc || self.tag == .td)  &&
                (protoTag == .w || protoTag == .cX || protoTag == .mX)
            }
            var ifHeight: Bool {
                (self.tag == .height || self.tag == .ta || self.tag == .tb || self.tag == .tc || self.tag == .td) &&
                (protoTag == .h || protoTag == .cY || protoTag == .mY)
            }
            
            var ifX: Bool { (self.tag == .x || self.tag == .tx) && (protoTag == .x || protoTag == .cX || protoTag == .mX) }
            var ifY: Bool { (self.tag == .y || self.tag == .ty) && (protoTag == .y || protoTag == .cX || protoTag == .mX) }
           
            
            if view == observeView, ifWidth || ifHeight || ifX || ifY { return }
            self.closure?(view)
        }
        keys.append(observeKey)
        
        let observeKey1 = observeView?.observe(\.center, options: [.old]) {[weak self] (_, test) in
            guard let self = self else {return}
            guard let view = self.view else {return}
            guard let observeView = self.observeView else {return}
            guard let protoTag = self.protoTag else {return}
            guard var old = test.oldValue else {return}
                
            old.x -= observeView.center.x
            old.y -= observeView.center.y
            
            if protoTag == .w || protoTag == .x || protoTag == .cX || protoTag == .mX, old.x == 0 {return}
            if protoTag == .h || protoTag == .y || protoTag == .cY || protoTag == .mY, old.y == 0 {return}
                
            var ifWidth: Bool  {
                (self.tag == .width || self.tag == .ta || self.tag == .tb || self.tag == .tc || self.tag == .td)  &&
                (protoTag == .w || protoTag == .cX || protoTag == .mX)
            }
            var ifHeight: Bool {
                (self.tag == .height || self.tag == .ta || self.tag == .tb || self.tag == .tc || self.tag == .td) &&
                (protoTag == .h || protoTag == .cY || protoTag == .mY)
            }
            
            var ifX: Bool  { (self.tag == .x || self.tag == .tx) && (protoTag == .x || protoTag == .cX || protoTag == .mX) }
            var ifY: Bool  { (self.tag == .y || self.tag == .ty) && (protoTag == .y || protoTag == .cX || protoTag == .mX) }
           
            
            if view == observeView, ifWidth || ifHeight || ifX || ifY { return }
            self.closure?(view)
        }
        keys.append(observeKey1)
    }
    
    func removeObserve(){
        keys = []
    }
}
