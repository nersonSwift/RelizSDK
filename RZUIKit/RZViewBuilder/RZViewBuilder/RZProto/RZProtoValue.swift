//
//  RZProtoValue.swift
//  RelizKit
//
//  Created by Александр Сенин on 21.10.2020.
//

import UIKit

protocol RZProtoValueProtocol {
    func getValue(_ frame: CGRect) -> CGFloat
}

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
public struct RZProtoValue: RZProtoValueProtocol{
    @RZObservable var value: CGFloat?
    private var observeFlag: Bool = false
    
    private var selfTag: RZProtoTag?
    
    var operation: RZProtoOperationProtocol?
    
    private func filter(_ old: CGRect, _ new: CGRect) -> Bool {
        switch selfTag {
            case .w: return old.width != new.width
            case .h: return old.height != new.height
            
            case .x: return old.minX != new.minX
            case .y: return old.minY != new.minY
            
            case .cX: return (old.width != new.width) || (old.minX != new.minX)
            case .cY: return (old.height != new.height) || (old.minY != new.minY)
                
            case .scX: return old.width != new.width
            case .scY: return old.height != new.height
            
            case .mX: return (old.width != new.width) || (old.minX != new.minX)
            case .mY: return (old.height != new.height) || (old.minY != new.minY)
        default: return true
        }
    }
    
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
    
    public func getValue(_ frame: CGRect = .zero) -> CGFloat{
        if let operation = operation { return operation.getValue(frame) }
                
        if let value = value{
            return value
        }else if let selfTag = selfTag{
            return Self.getValueAt(selfTag, frame)
        }else{
            return 0
        }
    }
    
    static func getValueAt(_ tag: RZProtoTag, _ frame: CGRect) -> CGFloat{
        switch tag {
            case .h: return frame.height
            case .w: return frame.width
            
            case .x: return frame.minX
            case .y: return frame.minY
            
            case .cX: return frame.midX
            case .cY: return frame.midY
            
            case .scX: return frame.width / 2
            case .scY: return frame.height / 2
            
            case .mX: return frame.maxX
            case .mY: return frame.maxY
        }
    }
    
    func setValueIn(_ view: UIView, _ tag: RZObserveController.Tag, _ remove: Bool = true,  _ closure: @escaping ((UIView) -> ())){
        let observeController = view.observeController
        if remove{
            observeController.remove(tag)
        }
        checkObserv(tag, observeController, closure)
        closure(view)
    }
    
    func checkObserv(
        _ tag: RZObserveController.Tag,
        _ observeController: RZObserveController?,
        _ closure: @escaping ((UIView) -> ())
    ){
        if observeFlag{
            observeController?.add(tag, self, closure)
        }
        if let range = operation{
            range.checkObserv(tag, observeController, closure)
        }
    }
    
    init(_ value: CGFloat){
        self.value = value
    }
    init(_ value: RZObservable<CGFloat?>){
        self._value = value
        observeFlag = true
    }
    init(_ selfTag: RZProtoTag, _ observ: UIView? = nil){
        self.selfTag = selfTag
        guard let observ = observ else {return}
        observeFlag = true
        
        let rzValue = self.$value
        let filter = self.filter
        value = RZProtoValue.getValueAt(selfTag, observ.frame)
        observ.rzFrame.add{[weak rzValue] old, new in
            if !filter(old, new) {return}
            rzValue?.wrappedValue = RZProtoValue.getValueAt(selfTag, new)
        }
    }
    init(){}
    
    public static func %(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.operation = RZProtoOperationGoup(left, right, .procent)
        return value
    }

    public static func %(left: CGFloat, right: RZProtoValue) -> RZProtoValue{
        return left* % right
    }

    public static func +(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.operation = RZProtoOperationGoup(left, right, .p)
        return value
    }

    public static func -(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.operation = RZProtoOperationGoup(left, right, .m)
        return value
    }

    public static func /(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.operation = RZProtoOperationGoup(left, right, .d)
        return value
    }

    public static func *(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.operation = RZProtoOperationGoup(left, right, .u)
        return value
    }


    public static func <>(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.operation = RZProtoOperationGoup(left, right, .rang)
        return value
    }
    public static func ><(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.operation = RZProtoOperationGoup(left, right, .center)
        return value
    }
    public static prefix func -(right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.operation = RZProtoOperation(right, .reverst)
        return value
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
    }
    
    weak var view: UIView?
    
    init(_ view: UIView) {self.view = view}
    
    var observes: [Tag: [RZObserve]] = [:]
    
    func add(_ tag: Tag, _ protoValue: RZProtoValue, _ closure: @escaping (UIView) -> ()){
        guard let view = view else { return }
        if observes[tag] == nil{
            observes[tag] = []
        }
        observes[tag]?.append(RZObserve(view, tag, protoValue, closure))
    }
    func add(_ tag: Tag, _ rzoProtoValue: RZObservable<RZProtoValue>, _ closure: @escaping (UIView) -> ()){
        guard let view = view else { return }
        if observes[tag] == nil{
            observes[tag] = []
        }
        observes[tag]?.append(RZObserve(view, tag, rzoProtoValue, self, closure))
    }
    
    func remove(_ tag: Tag){
        observes[tag] = nil
    }
}

class UIViewUppdateProcess{
    static var processes: [Int: [RZObserveController.Tag]] = [:]
    
    static func startProcesses(_ view: UIView, _ tag: RZObserveController.Tag, _ process: ()->()){
        if let tags = processes[view.hashValue]{
            for tagL in tags{ if tag == tagL {return} }
        }else{
            processes[view.hashValue] = []
        }
        processes[view.hashValue]?.append(tag)
        process()
    }
    
    static func endProcesses(_ view: UIView, _ tag: RZObserveController.Tag){
        for (i, tagL) in (processes[view.hashValue] ?? []).enumerated(){
            if tagL == tag {processes[view.hashValue]?.remove(at: i); break}
        }
    }
}

class RZObserve{
    private weak var view: UIView?
    private var tag: RZObserveController.Tag = .cornerRadius
    private var protoValue: RZProtoValue?
    private var closure: ((UIView) -> ())?
    
    private var result: RZObservable<CGFloat?>.Result?
    
    init(_ view: UIView, _ tag: RZObserveController.Tag, _ protoValue: RZProtoValue, _ closure: @escaping ((UIView) -> ())){
        self.view = view
        self.tag = tag
        self.protoValue = protoValue
        self.closure = closure
        setObserve()
    }
    convenience init(
        _ view: UIView,
        _ tag: RZObserveController.Tag,
        _ rzoProtoValue: RZObservable<RZProtoValue>,
        _ observeController: RZObserveController?,
        _ closure: @escaping ((UIView) -> ())
    ){
        self.init(view, tag, rzoProtoValue.wrappedValue, closure)
        rzoProtoValue.add {[weak self, weak observeController] proto in
            guard let self = self else {return}
            guard let view = self.view else {return}
            guard let observeController = observeController else {return}
            guard let closure = self.closure else {return}
            proto.checkObserv(tag, observeController, closure)
            closure(view)
        }
    }
    
    private func setObserve(){
        result = protoValue?.$value.add{[weak self]_ in
            guard let self = self else {return}
            guard let view = self.view else {return}
            UIViewUppdateProcess.startProcesses(view, self.tag) {
                self.closure?(view)
                UIViewUppdateProcess.endProcesses(view, self.tag)
            }
        }
    }
    
    func removeObserve(){
        result?.remove()
    }
    deinit {
        result?.remove()
    }
}

