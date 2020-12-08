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
    
    func getValue(_ frame: CGRect) -> CGSize{
        return CGSize(width: width.getValue(frame), height: height.getValue(frame))
    }
}

public struct RZProtoPoint {
    
    public var x: RZProtoValue
    public var y: RZProtoValue
    
    public init(x: RZProtoValue, y: RZProtoValue){
        self.x = x
        self.y = y
    }
    
    func getValue(_ frame: CGRect) -> CGPoint{
        return CGPoint(x: x.getValue(frame), y: y.getValue(frame))
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
    func getValue(_ frame: CGRect) -> CGRect{
        return CGRect(origin: origin.getValue(frame), size: size.getValue(frame))
    }
}
