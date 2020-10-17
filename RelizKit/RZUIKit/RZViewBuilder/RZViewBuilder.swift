//
//  RZViewBilder.swift
//  Yoga
//
//  Created by Александр Сенин on 15.10.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit
import SVGKit

public struct RZProto {
    private var frame: CGRect?
    
    public init(_ view: UIView){
        frame = view.frame
    }
    
    public init(_ frame: CGRect){
        self.frame = frame
    }
    
    public init(_ size: CGSize){
        frame = CGRect(origin: .zero, size: size)
    }
    
    public init(_ point: CGPoint){
        frame = CGRect(origin: point, size: .zero)
    }
    
    public init() {}
    
    
    public var w: RZProtoValue {
        guard let val = frame?.width else { return RZProtoValue(.w) }
        return RZProtoValue(val)
    }
    public var h: RZProtoValue {
        guard let val = frame?.height else { return RZProtoValue(.h) }
        return RZProtoValue(val)
    }
    
    public var x: RZProtoValue {
        guard let val = frame?.minX else { return RZProtoValue(.x) }
        return RZProtoValue(val)
    }
    public var y: RZProtoValue {
        guard let val = frame?.minY else { return RZProtoValue(.y) }
        return RZProtoValue(val)
    }
    
    public var cX: RZProtoValue {
        guard let val = frame?.midX else { return RZProtoValue(.cX) }
        return RZProtoValue(val)
    }
    public var cY: RZProtoValue {
        guard let val = frame?.midY else { return RZProtoValue(.cY) }
        return RZProtoValue(val)
    }
    
    public var mX: RZProtoValue {
        guard let val = frame?.maxX else { return RZProtoValue(.mX) }
        return RZProtoValue(val)
    }
    public var mY: RZProtoValue {
        guard let val = frame?.maxY else { return RZProtoValue(.mY) }
        return RZProtoValue(val)
    }
}



extension UIView{
    public var proto: RZProto { RZProto(self) }
}


infix operator <>
infix operator ><

public struct RZProtoValue{
    private var value: CGFloat?
    private var selfTag: SelfTag?
    private var procent: CGFloat?
    private var reverst: Bool = false
    
    private var range: RZProtoValueRang?
    
    public enum SelfTag{
        case w
        case h
        
        case x
        case y
        
        case cX
        case cY
        
        case mX
        case mY
    }
    
    public static func selfTag(_ value: SelfTag) -> RZProtoValue{
        return Self.init(value)
    }
    public static func screenConst(_ value: SelfTag) -> RZProtoValue{
        let proto = RZProto(UIScreen.main.bounds)
        switch value {
            case .w: return proto.w
            case .h: return proto.h
            
            case .x: return proto.x
            case .y: return proto.y
            
            case .cX: return proto.cX
            case .cY: return proto.cY
            
            case .mX: return proto.mX
            case .mY: return proto.mY
        }
    }
    
    fileprivate func getValue(_ frame: CGRect) -> CGFloat{
        if let range = range { return range.getValue(frame) }
        
        var value = self.value
        switch selfTag {
            case .h: value = frame.height
            case .w: value = frame.width
            
            case .x: value = frame.minX
            case .y: value = frame.minY
            
            case .cX: value = frame.midX
            case .cY: value = frame.midY
            
            case .mX: value = frame.maxX
            case .mY: value = frame.maxY
        default: break
        }
        
        if let procent = procent, let value = value{
            let valueL = value / 100 * procent
            return reverst ? value - valueL : valueL
        }
        
        if let value = value{
            return value
        }
        
        return 0
    }
    
    fileprivate init(_ value: CGFloat){
        self.value = value
    }
    fileprivate init(_ selfTag: SelfTag){
        self.selfTag = selfTag
    }
    fileprivate init(){}
    
    public static func %(left: CGFloat, right: RZProtoValue) -> RZProtoValue{
        var right = right
        right.procent = left
        return right
    }
    
    public static func %(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var right = right
        right.procent = left.value
        return right
    }
    
    public static func +(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueRang(left, right, .p)
        return value
    }
    
    public static func -(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueRang(left, right, .m)
        return value
    }
    
    public static func /(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueRang(left, right, .d)
        return value
    }
    
    public static func *(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueRang(left, right, .u)
        return value
    }
    
    
    public static func <>(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueRang(left, right, .rang)
        return value
    }
    public static func ><(left: RZProtoValue, right: RZProtoValue) -> RZProtoValue{
        var value = RZProtoValue()
        value.range = RZProtoValueRang(left, right, .center)
        return value
    }
    public static prefix func -(right: RZProtoValue) -> RZProtoValue{
        var right = right
        right.reverst.toggle()
        return right
    }
    
    public static func value(_ value: CGFloat) -> RZProtoValue{
        RZProtoValue(value)
    }
}

fileprivate class RZProtoValueRang {
    fileprivate var spaceFirst: RZProtoValue
    fileprivate var spaceSecond: RZProtoValue
    fileprivate var type: RZProtoValueRangtType
    
    enum RZProtoValueRangtType {
        case rang
        case center
        
        case p
        case m
        case u
        case d
    }
    
    fileprivate init(_ spaceFirst: RZProtoValue, _ spaceSecond: RZProtoValue, _ type: RZProtoValueRangtType){
        self.spaceFirst = spaceFirst
        self.spaceSecond = spaceSecond
        self.type = type
    }
    
    fileprivate func getValue(_ frame: CGRect) -> CGFloat{
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

public struct RZProtoSize {
    public var width: RZProtoValue
    public var height: RZProtoValue
    
    public init(width: RZProtoValue, height: RZProtoValue){
        self.width = width
        self.height = height
    }
    
    fileprivate func getValue(_ frame: CGRect) -> CGSize{
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
    
    fileprivate func getValue(_ frame: CGRect) -> CGPoint{
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
    fileprivate func getValue(_ frame: CGRect) -> CGRect{
        return CGRect(origin: origin.getValue(frame), size: size.getValue(frame))
    }
}

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

public class RZViewBuilder<V: UIView>{
    public var view: V = V()
    
    public init(_ view: V){
        self.view = view
    }
    
    public init(){}
    
    public enum ColorType {
        case background
        case content
        case boder
        case shadow
    }
    @discardableResult
    public func color(_ value: UIColor, _ type: ColorType) -> Self {
        switch type {
            case .background: view <- { $0.backgroundColor = value }
            case .content: self.setContentColor(value)
            case .boder: view <- { $0.layer.borderColor = value.cgColor }
            case .shadow: view <- { $0.layer.shadowColor = value.cgColor }
        }
        return self
    }
    
    func setContentColor(_ value: UIColor){
        
        switch view {
        case let label as UILabel:
            label <- { $0.textColor = value }
        case let button as UIButton:
            button <- { $0.setTitleColor(value, for: .normal) }
        default:break
        }
    }
    
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self{
        view.layer.cornerRadius = value
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: RZProtoValue) -> Self{
        view.layer.cornerRadius = value.getValue(view.frame)
        return self
    }
    
    @discardableResult
    public func border(_ value: CGFloat) -> Self{
        view.layer.borderWidth = value
        return self
    }
    
    @discardableResult
    public func shadow(_ radius: CGFloat, _ opacity: Float, _ offset: CGSize) -> Self{
        view.layer.shadowRadius = radius
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        return self
    }
    
    @discardableResult
    public func mask(_ value: UIView, _ size: RZProtoSize = RZProtoSize(width: 100 % RZProto().w, height: 100 % RZProto().h)) -> Self{
        value.frame.size = size.getValue(view.frame)
        view.mask = value
        return self
    }
    
    
}

extension RZViewBuilder{
    @discardableResult
    public func frame(_ value: CGRect, _ type: PointType = .topLeft) -> Self {
        return point(value.origin).size(value.size)
    }
    @discardableResult
    public func frame(_ value: RZProtoFrame, _ type: PointType = .topLeft) -> Self {
        return point(value.origin).size(value.size)
    }
    
    @discardableResult
    public func size(_ value: CGSize) -> Self{
        return width(value.width).height(value.height)
    }
    @discardableResult
    public func size(_ value: RZProtoSize) -> Self{
        return width(value.width).height(value.height)
    }
    public enum PointType: String{
        case center
        case topLeft
        case topRight
        case downRight
        case downLeft
    }
    @discardableResult
    public func point(_ value: CGPoint, _ type: PointType = .topLeft) -> Self{
        switch type {
            case .topLeft:   return x(value.x)         .y(value.y)
            case .topRight:  return x(value.x, .right) .y(value.y)
            case .center:    return x(value.x, .center).y(value.y, .center)
            case .downLeft:  return x(value.x)         .y(value.y, .down)
            case .downRight: return x(value.x, .right) .y(value.y, .down)
        }
    }
    @discardableResult
    public func point(_ value: RZProtoPoint, _ type: PointType = .topLeft) -> Self{
        switch type {
            case .topLeft:   return x(value.x)         .y(value.y)
            case .topRight:  return x(value.x, .right) .y(value.y)
            case .center:    return x(value.x, .center).y(value.y, .center)
            case .downLeft:  return x(value.x)         .y(value.y, .down)
            case .downRight: return x(value.x, .right) .y(value.y, .down)
        }
    }
    
    @discardableResult
    public func width(_ value: CGFloat) -> Self{
        view.frame.size.width = value
        return self
    }
    @discardableResult
    public func width(_ value: RZProtoValue) -> Self{
        view.frame.size.width = value.getValue(view.frame)
        return self
    }
    
    @discardableResult
    public func height(_ value: CGFloat) -> Self{
        view.frame.size.height = value
        return self
    }
    @discardableResult
    public func height(_ value: RZProtoValue) -> Self{
        view.frame.size.height = value.getValue(view.frame)
        return self
    }
    
    public enum XType: String{
        case center
        case left
        case right
    }
    @discardableResult
    public func x(_ value: CGFloat,  _ type: XType = .left) -> Self{
        switch type {
            case .left:   view.frame.origin.x = value
            case .right:  view.frame.origin.x = value - view.frame.width
            case .center: view.center.x = value
        }
        return self
    }
    @discardableResult
    public func x(_ value: RZProtoValue,  _ type: XType = .left) -> Self{
        switch type {
            case .left:   view.frame.origin.x = value.getValue(view.frame)
            case .right:  view.frame.origin.x = value.getValue(view.frame) - view.frame.width
            case .center: view.center.x = value.getValue(view.frame)
        }
        return self
    }
    public enum YType: String{
        case center
        case top
        case down
    }
    @discardableResult
    public func y(_ value: CGFloat,  _ type: YType = .top) -> Self{
        switch type {
            case .top:    view.frame.origin.y = value
            case .down:   view.frame.origin.y = value - view.frame.height
            case .center: view.center.y = value
        }
        return self
    }
    @discardableResult
    public func y(_ value: RZProtoValue,  _ type: YType = .top) -> Self{
        switch type {
            case .top:    view.frame.origin.y = value.getValue(view.frame)
            case .down:   view.frame.origin.y = value.getValue(view.frame) - view.frame.height
            case .center: view.center.y = value.getValue(view.frame)
        }
        
        return self
    }
    
    @discardableResult
    public func sizeToFit() -> Self {
        view.sizeToFit()
        return self
    }
    
    @discardableResult
    public func contentMode(_ value: UIView.ContentMode) -> Self {
        view.contentMode = value
        return self
    }
}

extension RZViewBuilder where V: UILabel{
    @discardableResult
    public func text(_ value: String) -> Self{
        view.text = value
        return self
    }
    
    @discardableResult
    public func aligment(_ value: NSTextAlignment)  -> Self{
        view.textAlignment = value
        return self
    }
    
    @discardableResult
    public func font(_ value: UIFont, _ attributes: [NSAttributedString.Key:Any] = [:]) -> Self{
        view.font = value
        let attributedText = NSMutableAttributedString(string: "", attributes: attributes)
        if let attributedTextL = view.attributedText{
            attributedText.append(attributedTextL)
        }
        view.attributedText = attributedText
        return self
    }
    
    @discardableResult
    public func sizes() -> Self{
        let widthL = view.frame.width
        view.sizeToFit()
        
        if view.frame.width > widthL{
            let coof = widthL / view.frame.width
            view.font = view.font.withSize(view.font.pointSize * coof)
            view.frame.size.width = widthL
        }
        return self
    }
    
    @discardableResult
    public func lines(_ value: Int) -> Self{
        view.numberOfLines = value
        return self
    }
    
}

extension RZViewBuilder where V: UIButton{
    @discardableResult
    public func text(_ value: String) -> Self{
        view.setTitle(value, for: .normal)
        return self
    }
    
    @discardableResult
    public func font(_ value: UIFont) -> Self{
        view.titleLabel?.font = value
        return self
    }
    
    @discardableResult
    public func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) -> Self{
        view.addAction(for: controlEvents, closure)
        return self
    }

}


public class RZImageSeter{
    private var image: UIImage?
    private var placeHolder: UIImage?
    
    private weak var imageView: UIImageView?
    
    public func setImage(_ image: SVGKImage){
        setImage(image.uiImage)
    }
    public func setImage(_ image: UIImage){
        placeHolder = nil
        if let imageView = imageView{
            DispatchQueue.main.async {
                imageView.image = image
            }
        }else{
            self.image = image
        }
    }
    
    fileprivate func setImageView(_ imageView: UIImageView){
        if let image = image{
            DispatchQueue.main.async {
                imageView.image = image
                self.image = nil
            }
        }else{
            DispatchQueue.main.async {
                imageView.image = self.placeHolder
                self.placeHolder = nil
            }
        }
    }
    
    init(_ placeHolder: UIImage) {
        self.placeHolder = placeHolder
    }
    convenience init(_ placeHolder: SVGKImage) {
        self.init(placeHolder.uiImage)
    }
}

extension RZViewBuilder where V: UIImageView{
    public func image(_ value: UIImage) -> Self {
        view.image = value
        return self
    }
    
    public func image(_ value: SVGKImage) -> Self {
        return image(value.uiImage)
    }
    
    public func image(_ value: RZImageSeter) -> Self{
        value.setImageView(view)
        return self
    }
}
