//
//  RZUIValueObservableWrapper.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 13.05.2022.
//

import UIKit
import RZObservableKit

public struct RZUIValueObservableWrapper: RZUIValueProtocol{
    public private(set) var value = RZObservable<CGFloat>(wrappedValue: 0)
    
    private var anchor: RZObserveAnchorObject?
    
    public init(_ oValue: RZObservable<CGFloat>){
        anchor = oValue.add {[weak value] updateValue in
            if updateValue.new == updateValue.old { return }
            value?.wrappedValue = updateValue.new
        }.anchorObject
        value.wrappedValue = oValue.wrappedValue
    }
    
    public init(_ oValue: RZObservable<RZUIValueProtocol>){
        oValue.add {[weak value, weak anchor] updateValue in
            withExtendedLifetime(anchor){
                anchor = updateValue.new.value.add {[weak value] updateValue in
                    if updateValue.new == updateValue.old { return }
                    value?.wrappedValue = updateValue.new
                }.anchorObject
            }
        }.snapToObject(value)
        value.wrappedValue = oValue.wrappedValue.value.wrappedValue
    }
}
