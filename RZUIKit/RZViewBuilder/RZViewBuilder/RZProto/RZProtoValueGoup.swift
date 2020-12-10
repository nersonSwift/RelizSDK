//
//  RZProtoValueGoup.swift
//  RelizKit
//
//  Created by Александр Сенин on 21.10.2020.
//

import UIKit


class RZProtoValueGoup {
    var spaceFirst: RZProtoValue
    var spaceSecond: RZProtoValue
    var type: RZProtoValueRangtType
    
    enum RZProtoValueRangtType {
        case rang
        case center
        
        case p
        case m
        case u
        case d
    }
    
    init(_ spaceFirst: RZProtoValue, _ spaceSecond: RZProtoValue, _ type: RZProtoValueRangtType){
        self.spaceFirst = spaceFirst
        self.spaceSecond = spaceSecond
        self.type = type
    }
    
    func getValue(_ frame: CGRect) -> CGFloat{
        let first = spaceFirst.getValue(frame)
        let second = spaceSecond.getValue(frame)
        
        switch type {
        case .rang:
            return first > second ? first - second : second - first
        case .center:
            var rang = first > second ? first - second : second - first
            rang /= 2
            rang += first < second ? first : second
            return rang
        case .p:
            return first + second
        case .m:
            return first - second
        case .u:
            return first * second
        case .d:
            return first / second
        
        }
    }
}
