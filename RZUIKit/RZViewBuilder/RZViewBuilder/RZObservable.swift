//
//  RZObservable.swift
//  RZViewBuilder
//
//  Created by Александр Сенин on 22.12.2020.
//

import Foundation
import SwiftUI
import Combine

extension ObservableObject{
    public func rzObservable<T>(
        _ bindingKey: KeyPath<ObservedObject<Self>.Wrapper, Binding<T>>,
        _ publisherKey: KeyPath<Self, Published<T>.Publisher>
    ) -> RZObservable<T>
    {
        let key = "\(bindingKey)\(publisherKey)"
        
        if let rzObservable = getAssociated(key.hashValue) as? RZObservable<T>{return rzObservable }
        
        let binding = ObservedObject(initialValue: self).projectedValue[keyPath: bindingKey]
        let rzObservable = RZPublisherObservable(binding: binding)
        
        rzObservable.anyCancellable = self[keyPath: publisherKey].sink {[weak rzObservable] value in
            rzObservable?.update(value)
        }
        
        setAssociated(key.hashValue, rzObservable)
        return rzObservable
    }
    
    private func setAssociated(_ int: Int, _ obj: Any){
        objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: int)!, obj, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getAssociated(_ int: Int) -> Any?{
        objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: int)!)
    }
    
    public func setRZObservables(){
        let mirror = Mirror(reflecting: self)
        for cild in mirror.children{
            (cild.value as? RZObservableProtocol)?.objectWillChange = objectWillChange as? ObservableObjectPublisher
        }
    }
}

public struct RZUIAnimation {
    @RZObservable private var _duration: TimeInterval = 0
    @RZObservable private var _delay: TimeInterval = 0
    @RZObservable private var _dampingRatio: CGFloat = 0
    @RZObservable private var _velocity: CGFloat = 0
    @RZObservable private var _options: UIView.AnimationOptions = []
    
    public func duration(_ value: TimeInterval) -> Self {
        var animation = self
        animation._duration = value
        return animation
    }
    public func duration(_ value: RZObservable<TimeInterval>?) -> Self {
        var animation = self
        if let value = value{ animation.__duration = value }
        return animation
    }
    
    public func delay(_ value: TimeInterval) -> Self {
        var animation = self
        animation._delay = value
        return animation
    }
    public func delay(_ value: RZObservable<TimeInterval>?) -> Self {
        var animation = self
        if let value = value{ animation.__delay = value }
        return animation
    }
    
    public func options(_ value: UIView.AnimationOptions) -> Self {
        var animation = self
        animation._options = value
        return animation
    }
    public func options(_ value: RZObservable<UIView.AnimationOptions>?) -> Self {
        var animation = self
        if let value = value{ animation.__options = value }
        return animation
    }
    
    public func damping(_ dampingRatio: CGFloat, _ velocity: CGFloat) -> Self {
        var animation = self
        animation._dampingRatio = dampingRatio
        animation._velocity = velocity
        return animation
    }
    public func damping(_ dampingRatio: RZObservable<CGFloat>?, _ velocity: RZObservable<CGFloat>?) -> Self {
        var animation = self
        if let dampingRatio = dampingRatio{ animation.__dampingRatio = dampingRatio }
        if let velocity = velocity{ animation.__velocity = velocity }
        return animation
    }
    
    public func animate(_ action: @escaping ()->(), _ completion: @escaping (Bool)->() = {_ in}){
        UIView.animate(
            withDuration: _duration,
            delay: _delay,
            usingSpringWithDamping: _dampingRatio,
            initialSpringVelocity: _velocity, options: _options,
            animations: action,
            completion: completion
        )
    }
    
    
    public init(){}
}

extension RZUIAnimation{
    public static func duration(_ value: TimeInterval) -> Self { Self().duration(value) }
    public static func duration(_ value: RZObservable<TimeInterval>?) -> Self { Self().duration(value) }
    
    public static func delay(_ value: TimeInterval) -> Self { Self().delay(value) }
    public static func delay(_ value: RZObservable<TimeInterval>?) -> Self { Self().delay(value) }
    
    public static func options(_ value: UIView.AnimationOptions) -> Self { Self().options(value) }
    public static func options(_ value: RZObservable<UIView.AnimationOptions>?) -> Self { Self().options(value) }
    
    public static func damping(_ dampingRatio: CGFloat, _ velocity: CGFloat) -> Self { Self().damping(dampingRatio, velocity) }
    public static func damping(_ dampingRatio: RZObservable<CGFloat>?, _ velocity: RZObservable<CGFloat>?) -> Self { Self().damping(dampingRatio, velocity)
    }
    
    public static var standart: Self { Self.duration(0.3) }
    public static var ezDamping: Self { Self.duration(0.8).damping(0.8, 0.3).options(.curveEaseOut) }
}

public protocol RZObservableProtocol: class {
    var objectWillChange: ObservableObjectPublisher? {get set}
}

@propertyWrapper
public class RZObservable<Value>: RZObservableProtocol {
    //MARK: - Result
    public class Result{
        private weak var rzObservable: RZObservable<Value>?
        var key: Int
        var action: RZObservable.Action
        
        var value: Value? {
            set(value){
                guard let value = value else { return }
                rzObservable?.wrappedValue = value
            }
            get{
                rzObservable?.wrappedValue
            }
        }
        
        func use(_ useType: RZObservable.UseType = .animate){ rzObservable?.use(useType, key) }
        func remove(){ rzObservable?.remove(key) }
        
        
        init(_ rzObservable: RZObservable<Value>, _ key: Int, _ action: RZObservable.Action){
            self.rzObservable = rzObservable
            self.key = key
            self.action = action
        }
    }
    
    //MARK: - Action
    public class Action{
        public enum UseType{
            case animate
            case noAnimate
            case useAnimate(_ animation: RZUIAnimation)
            case useDefaultAnimate(_ animation: RZUIAnimation)
        }
        
        public var closure: ((Value)->())?
        public var animation: RZUIAnimation?
        
        public func use(_ useType: UseType = .animate, value: Value){
            switch useType{
            case .animate:
                animation != nil ? animation?.animate{ [weak self] in self?.closure?(value) } : closure?(value)
            case .noAnimate:
                closure?(value)
            case .useAnimate(let animation):
                animation.animate{ [weak self] in self?.closure?(value) }
            case .useDefaultAnimate(let animation):
                (self.animation ?? animation).animate{ [weak self] in self?.closure?(value) }
            }
        }
        public init(_ animation: RZUIAnimation?, _ closure: @escaping (Value)->()) {
            self.animation = animation
            self.closure = closure
        }
    }
    
    //MARK: - UseType
    public enum UseType{
        case animate
        case noAnimate
        case useAnimate(_ animation: RZUIAnimation)
        case useDefaultAnimate
    }
    
    //MARK: - Property
    //MARK: - Internal
    var prepareAnimetion: RZUIAnimation?
    var defaultAnimetion: RZUIAnimation?
    var observeResults = [Result]()
    
    var counter: Int = 1
    
    var value: Value {didSet{ objectWillChange?.send() }}
    
    //MARK: - Public
    public var objectWillChange: ObservableObjectPublisher?
    public var projectedValue: RZObservable<Value> {return self}
    
    public var wrappedValue: Value{
        set(wrappedValue){
            value = wrappedValue
            observeResults.forEach{
                if let defaultAnimetion = defaultAnimetion{
                    $0.action.use(.useDefaultAnimate(defaultAnimetion), value: wrappedValue)
                }else{
                    $0.action.use(value: wrappedValue)
                }
            }
        }
        get{ value }
    }
    
    //MARK: - funcs
    //MARK: - Internal
    func use(_ useType: UseType = .animate, _ key: Int){
        guard let action = getAction(key) else { return }
        switch useType {
        case .animate:
            action.use(.animate, value: wrappedValue)
        case .noAnimate:
            action.use(.noAnimate, value: wrappedValue)
        case .useAnimate(let animation):
            action.use(.useAnimate(animation), value: wrappedValue)
        case .useDefaultAnimate:
            if let defaultAnimetion = defaultAnimetion{
                action.use(.useAnimate(defaultAnimetion), value: wrappedValue)
            }else{
                action.use(.animate, value: wrappedValue)
            }
        }
    }
    
    func getAction(_ key: Int) -> Action? { getResult(key)?.action }
    func getResult(_ key: Int) -> Result? {
        guard let counter = getResultCounter(key) else { return nil }
        return observeResults[counter]
    }
    func getResultCounter(_ key: Int) -> Int?{
        for (i, value) in observeResults.enumerated() {
            if value.key == key { return i }
        }
        return nil
    }
    
    //MARK: - Public
    @discardableResult
    public func add(_ animation: RZUIAnimation? = nil, _ observeClosure: @escaping (Value)->()) -> Result{
        var animation = animation
    
        if animation == nil, let prepareAnimetion = prepareAnimetion{
            animation = prepareAnimetion
            self.prepareAnimetion = nil
        }
        let result = Result(self, counter, Action(animation, observeClosure))
        observeResults.append(result)
        counter += 1
        return result
    }
    
    public func remove(_ key: Int){
        guard let counter = getResultCounter(key) else { return }
        observeResults.remove(at: counter)
    }
    
    public func setValue(_ useType: UseType = .noAnimate, value: Value){
        self.value = value
        observeResults.forEach{ use(useType, $0.key) }
    }
    
    @discardableResult
    public func animation(_ animation: RZUIAnimation) -> Self{
        prepareAnimetion = animation
        return self
    }
    
    //MARK: - inits
    public init(wrappedValue: Value, _ animation: RZUIAnimation){
        defaultAnimetion = animation
        self.value = wrappedValue
    }
    public init(wrappedValue: Value){
        self.value = wrappedValue
    }
    
}

extension RZObservable where Value: Hashable{
    public func switcher<SValue>(_ map: [Value: SValue]) -> RZObservable<SValue>?{ self ?> RZSwith(map) }
}
extension RZObservable where Value == Int{
    public func switcher<SValue>(_ map: SValue...) -> RZObservable<SValue>?{ switcher(map) }
    public func switcher<SValue>(_ map: [SValue]) -> RZObservable<SValue>?{
        var mapD = [Value: SValue]()
        for (i, value) in map.enumerated(){
            mapD[i] = value
        }
        return self ?> RZSwith(mapD)
    }
}
extension RZObservable where Value == Bool{
    public func switcher<SValue>(_ map: SValue...) -> RZObservable<SValue>?{ switcher(map) }
    public func switcher<SValue>(_ map: [SValue]) -> RZObservable<SValue>?{
        if map.count != 2 {return nil}
        var mapD = [Value: SValue]()
        mapD[true]  = map[0]
        mapD[false] = map[1]
        return self ?> RZSwith(mapD)
    }
}

public class RZPublisherObservable<Value>: RZObservable<Value>{
    public var binding: Binding<Value>?
    public var anyCancellable: AnyCancellable?
    
    override public var wrappedValue: Value{
        set(wrappedValue){
            if let binding = binding{
                binding.wrappedValue = wrappedValue
            }else{
                super.wrappedValue = wrappedValue
            }
        }
        get{
            value
        }
    }
    
    public func update(_ value: Value){
        self.value = value
        self.observeResults.forEach{
            if let defaultAnimetion = defaultAnimetion{
                $0.action.use(.useDefaultAnimate(defaultAnimetion), value: wrappedValue)
            }else{
                $0.action.use(value: wrappedValue)
            }
        }
    }
    
    public init(binding: Binding<Value>){
        super.init(wrappedValue: binding.wrappedValue)
        self.binding = binding
    }
}

public class RZSwith<Key: Hashable, Value>{
    var dictenary = [Key: Value]()
    
    init(_ key: Key, _ value: Value) {
        dictenary[key] = value
    }
    init(_ dictenary: [Key: Value]){
        self.dictenary = dictenary
    }
    
    func add(_ value: (Key, Value)){
        dictenary[value.0] = value.1
    }
}

public func <|<Key: Hashable, Value>(left: (Key, Value), right: (Key, Value)) -> RZSwith<Key, Value>{
    RZSwith(left.0, left.1) <| right
}

public func <|<Key: Hashable, Value>(left: RZSwith<Key, Value>, right: (Key, Value)) -> RZSwith<Key, Value>{
    left.add(right)
    return left
}

public func ?><Key: Hashable, Value>(left: RZObservable<Key>, right: RZSwith<Key, Value>) -> RZObservable<Value>?{
    guard let value = right.dictenary.first?.value else { return nil }
    let observable = RZObservable<Value>(wrappedValue: value)
    let obj = left.add {[weak observable] in
        guard let observable = observable else { return }
        guard let value = right.dictenary[$0] else { return }
        observable.wrappedValue = value
    }
    let key = -obj.key
    obj.use(.noAnimate)
    objc_setAssociatedObject(left, UnsafeRawPointer(bitPattern: key)!, observable, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    return observable
}

public func ?><Key: Hashable, Value>(left: RZObservable<Key>, right: RZSwith<Key, RZObservable<Value>>) -> RZObservable<Value>?{
    guard let value = right.dictenary.first else { return nil }
    let obValue = value.value.wrappedValue
    
    let observable = RZObservable<Value>(wrappedValue: obValue)
    var oldKey = value.key
    var oldClosureKey = -1
    let obj = left.add {[weak observable] in
        guard let observable = observable else { return }
        guard let value = right.dictenary[$0] else { return }
        guard let old = right.dictenary[oldKey] else { return }
        
        old.remove(oldClosureKey)
        oldKey = $0
        oldClosureKey = value.add {[weak observable] in
            observable?.wrappedValue = $0
        }.key
    }
    let key = -obj.key
    obj.use(.noAnimate)
    objc_setAssociatedObject(left, UnsafeRawPointer(bitPattern: key)!, observable, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    return observable
}

