//
//  RZProtoFrame.swift
//  RelizKit
//
//  Created by Александр Сенин on 21.10.2020.
//

import UIKit


public struct RZProtoSize {
    public var width: RZProtoValue
    public var height: RZProtoValue
    
    public init(width: RZProtoValue, height: RZProtoValue){
        self.width = width
        self.height = height
    }
    
    func getValue(_ view: UIView) -> CGSize{
        return CGSize(width: width.getValue(view), height: height.getValue(view))
    }
}

public struct RZProtoPoint {
    
    public var x: RZProtoValue
    public var y: RZProtoValue
    
    public init(x: RZProtoValue, y: RZProtoValue){
        self.x = x
        self.y = y
    }
    
    func getValue(_ view: UIView) -> CGPoint{
        return CGPoint(x: x.getValue(view), y: y.getValue(view))
    }
}

public struct RZProtoFrame {
    public var size: RZProtoSize
    public var origin: RZProtoPoint
    
    public init(width: RZProtoValue, height: RZProtoValue, x: RZProtoValue, y: RZProtoValue){
        size = RZProtoSize(width: width, height: height)
        origin = RZProtoPoint(x: x, y: y)
    }
    public init(origin: RZProtoPoint, size: RZProtoSize){
        self.size = size
        self.origin = origin
    }
    func getValue(_ view: UIView) -> CGRect{
        return CGRect(origin: origin.getValue(view), size: size.getValue(view))
    }
}
