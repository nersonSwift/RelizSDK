//
//  RZUIOperationValue.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 13.05.2022.
//

import UIKit
import RZObservableKit

public struct RZUIOperationValue: RZUIValueProtocol{
    public enum RZUIOperationType{
        case addition
        case subtraction
        case multiplication
        case division
        
        case percent
        case reversePercent
        
        case range
        case center
        
        case reverse
    }
    
    public enum RZUIOperationResult{
        case cgFloat(CGFloat)
        case operation(RZUIOperationValue)
    }
    
    public private(set) var value = RZObservable<CGFloat>(wrappedValue: 0)
    
    private var subValue:  RZUIValue?
    private var subValue1: RZUIValue?
    
    init(_ uiValue: RZUIValue, opiration: RZUIOperationType){
        uiValue.value.add {[weak value] updateValue in
            let cValue = Self.calculate(updateValue.new, 1, opiration: opiration)
            if value?.wrappedValue == cValue { return }
            value?.wrappedValue = cValue
        }.use().snapToObject(value)
    }
    
    init(_ uiValue: RZUIValue, _ uiValue1: RZUIValue, opiration: RZUIOperationType){
        let oValue = uiValue.value
        let oValue1 = uiValue1.value
        
        oValue.add {[weak value, weak oValue1] updateValue in
            let cValue = Self.calculate(updateValue.new, oValue1?.wrappedValue ?? 1, opiration: opiration)
            if value?.wrappedValue == cValue { return }
            value?.wrappedValue = cValue
        }.use().snapToObject(value)
        subValue = uiValue
        
        oValue1.add {[weak value, weak oValue] updateValue in
            let cValue = Self.calculate(oValue?.wrappedValue ?? 1, updateValue.new, opiration: opiration)
            if value?.wrappedValue == cValue { return }
            value?.wrappedValue = cValue
        }.use().snapToObject(value)
        subValue1 = uiValue1
    }
    
    public static func create(
        _ uiValue: RZUIValue,
        opiration: RZUIOperationType
    ) -> RZUIOperationResult{
        if uiValue.subValue == nil{
            return .cgFloat(calculate(uiValue.value.wrappedValue, 1, opiration: opiration))
        }else{
            return .operation(.init(uiValue, opiration: opiration))
        }
    }
    
    public static func create(
        _ uiValue: RZUIValue,
        _ uiValue1: RZUIValue,
        opiration: RZUIOperationType
    ) -> RZUIOperationResult{
        if uiValue.subValue == nil, uiValue1.subValue == nil{
            return .cgFloat(calculate(uiValue.value.wrappedValue, uiValue1.value.wrappedValue, opiration: opiration))
        }else{
            return .operation(.init(uiValue, opiration: opiration))
        }
    }
    
    private static func calculate(_ v1: CGFloat, _ v2: CGFloat, opiration: RZUIOperationType) -> CGFloat{
        switch opiration{
            case .addition:       return v1 + v2
            case .subtraction:    return v1 - v2
            case .multiplication: return v1 * v2
            case .division:       return v1 / v2
            
            case .percent:        return v2 * (v1 / 100)
            case .reversePercent: return v2 * ((100 - v1) / 100)
            
            case .range:          return abs(v1 - v2)
            case .center:         return v1 < v2 ? (abs(v1 - v2) / 2) + v1 : (abs(v1 - v2) / 2) + v2
            
            case .reverse:        return -v1
        }
    }
}
