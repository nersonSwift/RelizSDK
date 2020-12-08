//
//  RZProtoTest.swift
//  RelizKit
//
//  Created by Александр Сенин on 21.10.2020.
//

import Foundation


//public class RZViewJsonBuilder{
//    public static func create(_ json: Any) -> UIView{
//        return UIView()
//    }
//
//    static func getValue(_ value: String) -> RZProtoValue{
//        let blokc = getBlocks(value)
//        return getProtoValue(blokc)
//    }
//
//    enum ParsingValue {
//        case value(CGFloat)
//        case id(String)
//        case tag(String)
//        case spase
//        case oper(String)
//        case block(String)
//
//        case non
//    }
//
//    static func getBlocks(_ value: String) -> [ParsingValue]{
//        var rV = [ParsingValue]()
//        var bufer: String = ""
//        var buferOJ: String = ""
//
//        for car in value{
//            switch car {
//            case "+":
//                if let bufer = Float(bufer){
//                    rV.append(.value(CGFloat(bufer)))
//                }
//                bufer = ""
//                rV.append(.oper("+"))
//            case "-":
//                if let bufer = Float(bufer){
//                    rV.append(.value(CGFloat(bufer)))
//                }
//                bufer = ""
//                rV.append(.oper("-"))
//            case "*":
//                if let bufer = Float(bufer){
//                    rV.append(.value(CGFloat(bufer)))
//                }
//                bufer = ""
//                rV.append(.oper("*"))
//            case "/":
//                if let bufer = Float(bufer){
//                    rV.append(.value(CGFloat(bufer)))
//                }
//                bufer = ""
//                rV.append(.oper("/"))
//            case "%":
//                if let bufer = Float(bufer){
//                    rV.append(.value(CGFloat(bufer)))
//                }
//                bufer = ""
//                rV.append(.oper("%"))
//
//            case "<":
//                if buferOJ == "<" {
//                    buferOJ = ""
//                    rV.append(.oper("><"))
//                }else{
//                    buferOJ = ">"
//                }
//            case ">":
//                if buferOJ == ">" {
//                    buferOJ = ""
//                    rV.append(.oper("<>"))
//                }else{
//                    buferOJ = "<"
//                }
//
//            case " ":
//                if let bufer = Float(bufer){
//                    rV.append(.value(CGFloat(bufer)))
//                }
//                bufer = ""
//                rV.append(.spase)
//            case "(":
//                if let bufer = Float(bufer){
//                    rV.append(.value(CGFloat(bufer)))
//                }
//                bufer = ""
//                rV.append(.block("("))
//            case ")":
//                if let bufer = Float(bufer){
//                    rV.append(.value(CGFloat(bufer)))
//                }
//                bufer = ""
//                rV.append(.block(")"))
//
//            case "|":
//                if buferOJ == "|" {
//                    buferOJ = ""
//                    rV.append(.tag(bufer))
//                }else{
//                    buferOJ = "|"
//                }
//            case ".":
//                if buferOJ == "|" {
//                    rV.append(.id(bufer))
//                    bufer = ""
//                }
//            default:
//                bufer += String(car)
//            }
//        }
//
//        if let bufer = Float(bufer){
//            rV.append(.value(CGFloat(bufer)))
//        }
//
//        print(rV)
//        return rV
//    }
//
//    enum Oh{
//        case protoValue(RZProtoValue)
//        case oper(String)
//        case spase
//    }
//    static func getProtoValue(_ arr: [ParsingValue]) -> RZProtoValue{
//        var newArr = [Oh]()
//
//        var blockArr = [ParsingValue]()
//        var blockCountre = 0
//
//        var id: String = ""
//
//        for i in arr{
//            if case .block(let tag) = i{
//
//                if tag == "("{
//                    blockCountre += 1
//                    continue
//                }
//
//                if tag == ")"{
//                    blockCountre -= 1
//                    if blockCountre == 0{
//
//                        newArr.append(.protoValue(getProtoValue(blockArr)))
//                        blockArr = []
//                    }
//                    continue
//                }
//
//            }
//
//            if blockCountre != 0{
//                blockArr.append(i)
//                continue
//            }
//
//
//            switch i {
//            case .oper(let oper):
//                newArr.append(.oper(oper))
//            case .id(let idL):
//                id = idL
//            case .tag(let tag):
//                newArr.append(.protoValue(getRZProtoValue(id, tag)))
//                id = ""
//            case .spase:
//                newArr.append(.spase)
//            case .value(let value):
//                newArr.append(.protoValue(value*))
//            default: break
//            }
//
//        }
//
//        return getRZProtoValue(newArr)
//    }
//
//    static func getRZProtoValue(_ id: String, _ tag: String) -> RZProtoValue {
//        return 0*
//    }
//
//    enum Action{
//        case prefix(String, RZProtoValue)
//        case infix(String, RZProtoValue, RZProtoValue)
//
//        func get() -> RZProtoValue {
//            switch self {
//            case .infix(let oper, let f, let s):
//                switch oper {
//                    case "+": return f + s
//                    case "-": return f - s
//                    case "*": return f * s
//                    case "/": return f / s
//                    case "<>": return f <> s
//                    case "><": return f >< s
//                    case "%": return f % s
//                default: break
//                }
//            case .prefix(let oper, let f):
//                switch oper {
//                    case "-": return -f
//                default: break
//                }
//            }
//            return 0*
//        }
//    }
//
//    static func getRZProtoValue(_ arr: [Oh]) -> RZProtoValue{
//        var f: RZProtoValue?
//        var o: String = ""
//
//        var sO: String = ""
//        var spase: Bool = false
//
//        for i in arr{
//            switch i {
//            case .oper(let value):
//                if spase{
//                    o = value
//                }else{
//                    sO = value
//                }
//                spase = false
//            case .protoValue(let value):
//                spase = false
//                if sO != ""{
//                    let v = Action.prefix(sO, value).get()
//                    if let fL = f{
//                        f = Action.infix(o, fL, v).get()
//                    }else{
//                        f = v
//                    }
//
//                }
//                if let fL = f{
//                    f = Action.infix(o, fL, value).get()
//                }else{
//                    f = value
//                }
//
//            case .spase:
//                spase = true
//            }
//        }
//        return f ?? 0*
//    }
//}
