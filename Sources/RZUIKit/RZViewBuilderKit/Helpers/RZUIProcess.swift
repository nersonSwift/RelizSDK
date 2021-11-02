//
//  RZUIProcess.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 27.10.2021.
//

import Foundation

class RZUIProcess{
    enum Priorety: Int {
        case H
        case M
        case L
    }
    
    static var inst = RZUIProcess()
    
    private var isStarted: Bool = false
    
    private var t = [
        KeysDic<[Int], Int, ()->()>(),
        KeysDic<[Int], Int, ()->()>(),
        KeysDic<[Int], Int, ()->()>()
    ]
    private var c = [0,0,0]
    
    func addTask(priorety: Priorety, key: [Int], task: @escaping ()->()) {
        let pKey = priorety.rawValue
        if t[pKey].safeAdd(key: key, key1: c[pKey], value: task){
            c[pKey] += 1
            if !isStarted { start(pKey) }
        }
    }
    
    private func start(_ pKey: Int){
        isStarted = true
        useTask(pKey, [0,0,0])
    }
    
    private func useTask(_ pKey: Int, _ aC: [Int]){
        var newAc = aC
        t[pKey].remove(key1: aC[pKey])?()
        newAc[pKey] += 1
        if c[pKey] > newAc[pKey]{
            useTask(pKey, newAc)
        }else{
            var newKey: Int?
            for (i, cI) in c.enumerated(){
                if i == pKey {continue}
                if cI > newAc[i] {newKey = i; break}
            }
            if let newKey = newKey{
                useTask(newKey, newAc)
            }else{
                end()
            }
        }
    }
    
    private func end(){
        c = [0,0,0]
        isStarted = false
    }
}


class RZValueWrapper<Value>{
    var value: Value
    init(value: Value) { self.value = value }
}

struct KeysDic<Key, Key1, Value> where Key: Hashable, Key1: Hashable{
    private var dic  = [Key: (value: RZValueWrapper<Value>, key: Key1)]()
    private var dic1 = [Key1: (value: RZValueWrapper<Value>, key: Key)]()
    
    @discardableResult
    mutating func safeAdd(key: Key, key1: Key1, value: Value) -> Bool {
        guard dic[key] != nil || dic1[key1] != nil else {return false}
        let wValue = RZValueWrapper(value: value)
        dic[key]   = (wValue, key1)
        dic1[key1] = (wValue, key)
        return true
    }
    
    mutating func add(key: Key, key1: Key1, value: Value) {
        let wValue = RZValueWrapper(value: value)
        dic[key]   = (wValue, key1)
        dic1[key1] = (wValue, key)
    }
    
    @discardableResult
    mutating func remove(key: Key) -> Value? {
        guard let (value, key1) = dic.removeValue(forKey: key) else {return nil}
        dic1.removeValue(forKey: key1)
        return value.value
    }
    
    @discardableResult
    mutating func remove(key1: Key1) -> Value? {
        guard let (value, key) = dic1.removeValue(forKey: key1) else {return nil}
        dic.removeValue(forKey: key)
        return value.value
    }
    
    subscript(key: Key) -> Value?{
        return dic[key]?.0.value
    }
    
    subscript(key1: Key1) -> Value?{
        return dic1[key1]?.0.value
    }
}
