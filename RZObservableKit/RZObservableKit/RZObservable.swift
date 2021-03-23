//
//  RZObservable.swift
//  RZViewBuilder
//
//  Created by Александр Сенин on 22.12.2020.
//

import Foundation
import SwiftUI
import Combine

public protocol RZObservableProtocol: class {
    var objectWillChange: ObservableObjectPublisher? {get set}
}

//MARK: - RZObservable Entities
//MARK: - UseType
public enum RZOUseType{
    case animate
    case noAnimate
    case useAnimate(_ animation: RZUIAnimation)
    case useDefaultAnimate
}

//MARK: - Result
public class Result<Value>{
    private weak var rzObservable: RZObservable<Value>?
    public var key: Int
    public var action: Action<Value>
    
    public var value: Value? {
        set(value){
            guard let value = value else { return }
            rzObservable?.wrappedValue = value
        }
        get{
            rzObservable?.wrappedValue
        }
    }
    
    public func use(_ useType: RZOUseType = .animate){ rzObservable?.use(useType, key) }
    public func remove(){ rzObservable?.remove(key) }
    
    init(_ rzObservable: RZObservable<Value>, _ key: Int, _ action: Action<Value>){
        self.rzObservable = rzObservable
        self.key = key
        self.action = action
    }
}

//MARK: - RZAnimationComplition
public class RZAnimationComplition{
    var complition = {}
}

//MARK: - Action
public class Action<Value>{
    public enum AUseType{
        case animate
        case noAnimate
        case useAnimate(_ animation: RZUIAnimation)
        case useDefaultAnimate(_ animation: RZUIAnimation)
    }
    
    public var closure: ((ActionData<Value>)->())?
    public var animation: RZUIAnimation?
    
    public func use(_ aUseType: AUseType = .animate, _ actionData: ActionData<Value>){
        var actionData = actionData
        actionData.animation = animation
        let aComplition = actionData.animationComplition
        switch aUseType{
        case .animate:
            if UIView.isAnimation{
                let animation = self.animation ?? .duration(0)
                animation.animate({ [weak self] in self?.closure?(actionData) }, {_ in aComplition.complition()})
            }else{
                closure?(actionData)
                aComplition.complition()
            }
            
        case .noAnimate:
            closure?(actionData)
            aComplition.complition()
            
        case .useAnimate(let animation):
            actionData.animation = animation
            animation.animate({[weak self] in self?.closure?(actionData) }, {_ in aComplition.complition()})
            
        case .useDefaultAnimate(let animation):
            actionData.animation = self.animation ?? animation
            (self.animation ?? animation).animate({ [weak self] in self?.closure?(actionData) }, {_ in aComplition.complition()})
        }
    }

    
    public init(_ animation: RZUIAnimation?, _ closure: @escaping (ActionData<Value>)->()) {
        self.animation = animation
        self.closure = closure
    }
}

//MARK: - ActionData
public struct ActionData<Value>{
    public var animation: RZUIAnimation?
    public var useType: RZOUseType
    let animationComplition = RZAnimationComplition()
    
    public var old: Value
    public var new: Value
    
    func complition(_ value: @escaping ()->()){
        animationComplition.complition = value
    }
}

//MARK: - RZObservable
@propertyWrapper
public class RZObservable<Value>: NSObject, RZObservableProtocol {
    //MARK: - Property
    //MARK: - Internal
    var prepareAnimetion: RZUIAnimation?
    var defaultAnimetion: RZUIAnimation?
    var observeResults = [Result<Value>]()
    
    var counter: Int = 1
    
    var value: Value {didSet{ objectWillChange?.send() }}
    
    //MARK: - Public
    public var objectWillChange: ObservableObjectPublisher?
    public var projectedValue: RZObservable<Value> {return self}
    
    public var wrappedValue: Value{
        set(wrappedValue){
            setValue(.animate, value: wrappedValue)
        }
        get{ value }
    }
    
    //MARK: - funcs
    //MARK: - Internal
    func use(_ useType: RZOUseType = .animate, _ key: Int, _ old: Value? = nil){
        guard let action = getAction(key) else { return }
        let actionData = ActionData(animation: nil, useType: useType, old: old ?? wrappedValue, new: wrappedValue)
        switch useType {
        case .animate:
            if let defaultAnimetion = defaultAnimetion{
                action.use(.useDefaultAnimate(defaultAnimetion), actionData)
            }else{
                action.use(.animate, actionData)
            }
        case .noAnimate:
            action.use(.noAnimate, actionData)
        case .useAnimate(let animation):
            action.use(.useAnimate(animation), actionData)
        case .useDefaultAnimate:
            if let defaultAnimetion = defaultAnimetion{
                action.use(.useAnimate(defaultAnimetion), actionData)
            }else{
                action.use(.animate, actionData)
            }
        }
    }
    
    func getAction(_ key: Int) -> Action<Value>? { getResult(key)?.action }
    func getResult(_ key: Int) -> Result<Value>? {
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
    public func add(_ animation: RZUIAnimation? = nil, _ observeClosure: @escaping (ActionData<Value>)->()) -> Result<Value>{
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
    
    public func setValue(_ useType: RZOUseType = .noAnimate, value: Value){
        let old = self.value
        self.value = value
        observeResults.forEach{ use(useType, $0.key, old) }
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

//MARK: - RZPublisherObservable
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
        setValue(.animate, value: value)
    }
    
    public init(binding: Binding<Value>){
        super.init(wrappedValue: binding.wrappedValue)
        self.binding = binding
    }
}

//MARK: - Extensions
//MARK: - Switcher
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

//MARK: - UITextField / UITextView
extension RZObservable where Value == String{
    func setTextObserve(_ textField: UITextField){
        textField.addAction(for: .editingChanged) {[weak self, weak textField] in
            if self?.wrappedValue != textField?.text{
                self?.wrappedValue = textField?.text ?? ""
            }
        }
    }
    
    func setTextObserve(_ textView: UITextView){
        RZTextViewDelegate.setDelegate(textView, self)
    }
}




