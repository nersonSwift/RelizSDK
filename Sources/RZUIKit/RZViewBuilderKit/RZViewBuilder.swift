//
//  RZViewBilder.swift
//  Yoga
//
//  Created by Александр Сенин on 15.10.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//


import UIKit
import RZDarkModeKit
import RZObservableKit


//MARK: - UIView
public class RZViewBuilder<V: UIView>{
    //MARK: - view
    /// `RU: - `
    /// Редактируемое view
    public var view: V
    
    //MARK: - init
    /// `RU: - `
    /// Инициализатор `RZViewBuilder`
    ///
    /// - Parameter view
    /// Принимает view для редактирования
    public init(_ view: V){
        self.view = view
    }
    
    /// `RU: - `
    /// Инициализатор `RZViewBuilder`
    ///
    /// - Parameter view
    /// Создает view для редактирования
    convenience init(){
        self.init(V(frame: .zero))
    }
    
    public enum ColorType: String {
        case background = "cBackground"
        case content    = "cContent"
        case border     = "cBorder"
        case shadow     = "cShadow"
        case tint       = "cTint"
    }
    
    //MARK: - color
    @discardableResult
    func _color(_ value: UIColor, _ type: ColorType = .background) -> Self {
        switch type {
            case .background: view <- { $0.backgroundColor = UIColor(cgColor: value.cgColor) }
            case .content: _setContentColor(value)
            case .border: view <- { $0.layer.borderColor = value.cgColor }
            case .shadow: view <- { $0.layer.shadowColor = value.cgColor }
            case .tint: view <- { $0.tintColor = UIColor(cgColor: value.cgColor) }
        }
        return self
    }
    func _setContentColor(_ value: UIColor){
        switch view {
        case let label as UILabel:
            label <- { $0.textColor = UIColor(cgColor: value.cgColor) }
        case let textView as UITextView:
            textView <- { $0.textColor = UIColor(cgColor: value.cgColor) }
        case let textField as UITextField:
            textField <- { $0.textColor = UIColor(cgColor: value.cgColor) }
        case let button as UIButton:
            button <- { $0.setTitleColor(UIColor(cgColor: value.cgColor), for: .normal) }
        default:break
        }
    }
    /// `RU: - `
    /// Устанавливает цвет редактироемому view
    ///
    /// - Parameter value
    /// Устанавливаемый цвет при необходимости конвертирует цвет в `CGColor`
    ///
    /// Поддерживает адаптивные цвета RZDarkModeKit
    ///
    /// - Parameter type
    /// Тег мета установки цвета
    @discardableResult
    public func color(_ value: UIColor, _ type: ColorType...) -> Self {
        return color(value, type)
    }
    @discardableResult
    public func color(_ value: UIColor, _ type: [ColorType]) -> Self {
        type.forEach{ color(value, $0) }
        return self
    }
    
    @discardableResult
    public func color(_ value: UIColor, _ type: ColorType = .background) -> Self {
        if let tag = RZObserveController.Tag(rawValue: type.rawValue) { view.observeController.remove(tag) }
        return _color(value, type)
    }
    @discardableResult
    public func color(_ value: RZObservable<UIColor>?, _ type: ColorType = .background) -> Self{
        let tag = RZObserveController.Tag(rawValue: type.rawValue)
        view.observeController.remove(tag)
        let result = value?.add(nil, {[weak view] in view?+>._color($0.new, type)}).use(.noAnimate)
        view.observeController.add(tag, result)
        return self
    }
    
    
    //MARK: - cornerRadius
    @discardableResult
    func _cornerRadius(_ value: CGFloat) -> Self{
        view.layer.cornerRadius = value
        return self
    }
    @discardableResult
    func _cornerRadius(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .cornerRadius) { $0.layer.cornerRadius = value.getValue($0) }
        return self
    }
    
    /// `RU: - `
    /// Устанавливает радиус скругления редактируемому view
    ///
    /// - Parameter value
    /// Радиус скругления
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self{
        view.observeController.remove(.cornerRadius)
        return _cornerRadius(value)
    }
    @discardableResult
    public func cornerRadius(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.cornerRadius)
        let result = value?.add(nil, {[weak view] in view?+>._cornerRadius($0.new)}).use(.noAnimate)
        view.observeController.add(.cornerRadius, result)
        return self
    }
    
    
    /// `RU: - `
    /// Устанавливает радиус скругления редактируемому view
    ///
    /// - Parameter value
    /// Радиус скругления в виде вычисляемого `RZProtoValue`
    @discardableResult
    public func cornerRadius(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.cornerRadius)
        return _cornerRadius(value)
    }
    @discardableResult
    public func cornerRadius(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ cornerRadius(value*) }
        return self
    }
    
    
    @discardableResult
    func _cornerRadius(_ value: CGFloat, _ corners: UIRectCorner) -> Self{
        view.layer.cornerRadius = 0
        view.roundCorners(corners, radius: value)
        return self
    }
    @discardableResult
    func _cornerRadius(_ value: RZProtoValue, _ corners: UIRectCorner) -> Self{
        value.setValueIn(view, .cornerRadius) {[weak self] in self?._cornerRadius(value.getValue($0), corners) }
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: CGFloat, _ corners: UIRectCorner) -> Self{
        view.observeController.remove(.cornerRadius)
        return _cornerRadius(value, corners)
    }
    
    @discardableResult
    public func cornerRadius(_ value: RZProtoValue, _ corners: UIRectCorner) -> Self{
        view.observeController.remove(.cornerRadius)
        return _cornerRadius(value, corners)
    }
    
    @discardableResult
    public func cornerRadius(_ value: RZObservable<RZProtoValue>?, _ corners: UIRectCorner) -> Self{
        if let value = value{ cornerRadius(value*) }
        return self
    }
    
    //MARK: - border
    /// `RU: - `
    /// Устанавливает толщину обводки
    ///
    /// Цвет обводки устанавливается методом `color` с параметром `.border`
    ///
    /// - Parameter value
    /// толщина обводки
    @discardableResult
    public func border(_ value: CGFloat) -> Self{
        view.layer.borderWidth = value
        return self
    }
    
    //MARK: - shadow
    /// `RU: - `
    /// Устанавливает толщину обводки.
    ///
    /// Цвет обводки устанавливается методом `color` с параметром `.border`
    ///
    /// - Parameter value
    /// толщина обводки
    @discardableResult
    public func shadow(_ radius: CGFloat, _ opacity: Float, _ offset: CGSize) -> Self{
        view.layer.shadowRadius = radius
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        return self
    }
    
    //MARK: - mask
    /// `RU: - `
    /// Устанавливает маску
    ///
    /// Размер маски по умолчанию равен размеру view. Маска выравнивается по центру view.
    ///
    /// - Parameter value
    /// view используемое как маска
    @discardableResult
    public func mask(_ value: UIView) -> Self{
        if value.frame.size == .zero{
            value+>.width(view|*.w).height(view|*.h)
        }
        value+>.x(view|*.scX, .center).y(view|*.scY, .center)
        view.mask = value
        return self
    }
    
    //MARK: - alpha
    @discardableResult
    func _alpha(_ value: CGFloat) -> Self{
        view.alpha = value
        return self
    }
    @discardableResult
    public func alpha(_ value: CGFloat) -> Self{
        view.observeController.remove(.alpha)
        return _alpha(value)
    }
    @discardableResult
    public func alpha(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.alpha)
        let result = value?.add {[weak view] in view?+>._alpha($0.new)}.use(.noAnimate)
        view.observeController.add(.alpha, result)
        return self
    }
    
    //MARK: - isHidden
    @discardableResult
    func _isHidden(_ value: Bool) -> Self{
        view.isHidden = value
        return self
    }
    @discardableResult
    public func isHidden(_ value: Bool) -> Self{
        view.observeController.remove(.isHidden)
        return _isHidden(value)
    }
    @discardableResult
    public func isHidden(_ value: RZObservable<Bool>?) -> Self{
        view.observeController.remove(.isHidden)
        let result = value?.add {[weak view] in view?+>._isHidden($0.new)}.use(.noAnimate)
        view.observeController.add(.isHidden, result)
        return self
    }
    
    //MARK: - template
    @discardableResult
    public func template(_ value: RZVBTemplate<V>) -> Self{
        value.use(view: view)
        return self
    }
    @discardableResult
    public func template(_ value: RZObservable<RZVBTemplate<V>>?, _ firstUse: Bool = true) -> Self{
        let result = value?.add {[weak view] in
            guard let view = view else {return}
            $0.new.use(view: view, $0.animationCompletion)
        }
        if firstUse { result?.use(.noAnimate) }
        return self
    }
    @discardableResult
    public func template(_ value: (V)->()) -> Self{
        value(view)
        return self
    }
    @discardableResult
    public func template(_ values: [RZVBTemplate<V>]) -> Self{
        values.forEach{template($0)}
        return self
    }
    @discardableResult
    public func template(_ values: RZVBTemplate<V>...) -> Self{
        values.forEach{template($0)}
        return self
    }
    @discardableResult
    public func template(@RZVBTemplateBuilder _ values: ()->[RZVBTemplate<V>]) -> Self{
        template(values())
        return self
    }
}

//MARK: - Frame only
extension RZViewBuilder{
    //MARK: - frame
    @discardableResult
    func _frame(_ value: CGRect, _ type: PointType = .topLeft) -> Self {
        return point(value.origin).size(value.size)
    }
    /// `RU: - `
    /// Устанавливает frame view
    ///
    /// - Parameter value
    /// Устанавливаемый frame
    ///
    /// - Parameter type
    /// Точка крепления view
    @discardableResult
    public func frame(_ value: CGRect, _ type: PointType = .topLeft) -> Self {
        view.observeController.remove(.frame)
        return _frame(value, type)
    }
    @discardableResult
    public func frame(_ value: RZObservable<CGRect>?, _ type: PointType = .topLeft) -> Self{
        view.observeController.remove(.frame)
        let result = value?.add {[weak view] in view?+>._frame($0.new, type)}.use(.noAnimate)
        view.observeController.add(.frame, result)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает frame view
    ///
    /// - Parameter value
    /// Устанавливаемый frame в виде вычисляемого `RZProtoFrame`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.topLeft`
//    @discardableResult
//    public func frame(_ value: RZProtoFrame, _ type: PointType = .topLeft) -> Self {
//        return point(value.origin).size(value.size)
//    }
//    @discardableResult
//    public func frame(_ value: RZObservable<RZProtoFrame>?, _ type: PointType = .topLeft) -> Self{
//        value?.add {[weak view] in view?+>.frame($0.new, type)}.use(.noAnimate)
//        return self
//    }
    
    //MARK: - size
    @discardableResult
    func _size(_ value: CGSize) -> Self{
        return width(value.width).height(value.height)
    }
    /// `RU: - `
    /// Устанавливает size view
    ///
    /// - Parameter value
    /// Устанавливаемый size
    @discardableResult
    public func size(_ value: CGSize) -> Self{
        view.observeController.remove(.size)
        return _size(value)
    }
    @discardableResult
    public func size(_ value: RZObservable<CGSize>?) -> Self{
        view.observeController.remove(.size)
        let result = value?.add {[weak view] in view?+>._size($0.new)}.use(.noAnimate)
        view.observeController.add(.size, result)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает size view
    ///
    /// - Parameter value
    /// Устанавливаемый size в виде вычисляемого `RZProtoSize`
//    @discardableResult
//    public func size(_ value: RZProtoSize) -> Self{
//        return width(value.width).height(value.height)
//    }
//    @discardableResult
//    public func size(_ value: RZObservable<RZProtoSize>?) -> Self{
//        value?.add {[weak view] in view?+>.size($0.new)}.use(.noAnimate)
//        return self
//    }
    
    public enum PointType: String{
        case center
        case topLeft
        case topRight
        case downRight
        case downLeft
    }
    
    //MARK: - point
    @discardableResult
    func _point(_ value: CGPoint, _ type: PointType = .topLeft) -> Self{
        switch type {
            case .topLeft:   return x(value.x)         .y(value.y)
            case .topRight:  return x(value.x, .right) .y(value.y)
            case .center:    return x(value.x, .center).y(value.y, .center)
            case .downLeft:  return x(value.x)         .y(value.y, .down)
            case .downRight: return x(value.x, .right) .y(value.y, .down)
        }
    }
    /// `RU: - `
    /// Устанавливает point view
    ///
    /// - Parameter value
    /// Устанавливаемый point
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.topLeft`
    @discardableResult
    public func point(_ value: CGPoint, _ type: PointType = .topLeft) -> Self{
        view.observeController.remove(.point)
        return _point(value, type)
    }
    @discardableResult
    public func point(_ value: RZObservable<CGPoint>?, _ type: PointType = .topLeft) -> Self{
        view.observeController.remove(.point)
        let result = value?.add {[weak view] in view?+>._point($0.new, type)}.use(.noAnimate)
        view.observeController.add(.point, result)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает point view
    ///
    /// - Parameter value
    /// Устанавливаемый point в виде вычисляемого `RZProtoPoint`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.topLeft`
//    @discardableResult
//    public func point(_ value: RZProtoPoint, _ type: PointType = .topLeft) -> Self{
//        switch type {
//            case .topLeft:   return x(value.x)         .y(value.y)
//            case .topRight:  return x(value.x, .right) .y(value.y)
//            case .center:    return x(value.x, .center).y(value.y, .center)
//            case .downLeft:  return x(value.x)         .y(value.y, .down)
//            case .downRight: return x(value.x, .right) .y(value.y, .down)
//        }
//    }
//    @discardableResult
//    public func point(_ value: RZObservable<RZProtoPoint>?, _ type: PointType = .topLeft) -> Self{
//        value?.add {[weak view] in view?+>.point($0.new, type)}.use(.noAnimate)
//        return self
//    }
    
    //MARK: - point
    @discardableResult
    func _width(_ value: CGFloat) -> Self{
        view.frame.size.width = value
        RZLabelSizeController.modUpdate(view, true)
        return self
    }
    @discardableResult
    func _width(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .width) { $0.frame.size.width = value.getValue($0); RZLabelSizeController.modUpdate($0, true) }
        return self
    }
    /// `RU: - `
    /// Устанавливает ширину view
    ///
    /// - Parameter value
    /// Устанавливаемая ширина
    @discardableResult
    public func width(_ value: CGFloat) -> Self{
        view.observeController.remove(.width)
        return _width(value)
    }
    @discardableResult
    public func width(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.width)
        let result = value?.add {[weak view] in view?+>._width($0.new)}.use(.noAnimate)
        view.observeController.add(.width, result)
        return self
    }
    
    //MARK: - width
    /// `RU: - `
    /// Устанавливает ширину view
    ///
    /// - Parameter value
    /// Устанавливаемая ширина в виде вычисляемого `RZProtoValue`
    @discardableResult
    public func width(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.width)
        return _width(value)
    }
    @discardableResult
    public func width(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ width(value*) }
        return self
    }
    
    //MARK: - height
    @discardableResult
    func _height(_ value: CGFloat) -> Self{
        view.frame.size.height = value
        return self
    }
    @discardableResult
    func _height(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .height) { $0.frame.size.height = value.getValue($0) }
        return self
    }
    /// `RU: - `
    /// Устанавливает высоту view
    ///
    /// - Parameter value
    /// Устанавливаемая высота
    @discardableResult
    public func height(_ value: CGFloat) -> Self{
        view.observeController.remove(.height)
        return _height(value)
    }
    @discardableResult
    public func height(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.height)
        let result = value?.add {[weak view] in view?+>._height($0.new)}.use(.noAnimate)
        view.observeController.add(.height, result)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает высоту view
    ///
    /// - Parameter value
    /// Устанавливаемая высота в виде вычисляемого `RZProtoValue`
    @discardableResult
    public func height(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.height)
        return _height(value)
    }
    @discardableResult
    public func height(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ height(value*) }
        return self
    }
    
    public enum XType: String{
        case center
        case left
        case right
    }
    
    //MARK: - х
    @discardableResult
    func _x(_ value: CGFloat,  _ type: XType = .left) -> Self{
        switch type {
            case .left:   view.frame.origin.x = value
            case .right:  view.frame.origin.x = value - view.frame.width
            case .center: view.center.x = value
        }
        return self
    }
    @discardableResult
    func _x(_ value: RZProtoValue,  _ type: XType = .left) -> Self{
        value.setValueIn(view, .x) {[weak view] in view?+>._x(value.getValue($0), type)}
        return self
    }
    /// `RU: - `
    /// Устанавливает х view
    ///
    /// - Parameter value
    /// Устанавливаемый х
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.left`
    @discardableResult
    public func x(_ value: CGFloat,  _ type: XType = .left) -> Self{
        view.observeController.remove(.x)
        _x(value, type)
        if type != .left {
            view|*.w.setValueIn(view, .x) { ($0 as? V)?+>._x(value, type) }
        }
        return self
    }
    @discardableResult
    public func x(_ value: RZObservable<CGFloat>?,  _ type: XType = .left) -> Self{
        view.observeController.remove(.x)
        let result = value?.add {[weak view] in view?+>._x($0.new, type)}.use(.noAnimate)
        view.observeController.add(.x, result)
        if type != .left {
            view|*.w.setValueIn(view, .x) {[weak value] in
                guard let value = value else {return}
                ($0 as? V)?+>._x(value.wrappedValue, type)
            }
        }
        return self
    }
    
    /// `RU: - `
    /// Устанавливает х view
    ///
    /// - Parameter value
    /// Устанавливаемый х в виде вычисляемого `RZProtoValue`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.left`
    @discardableResult
    public func x(_ value: RZProtoValue,  _ type: XType = .left) -> Self{
        view.observeController.remove(.x)
        _x(value, type)
        if type != .left {
            view|*.w.setValueIn(view, .x) {[weak view] in
                guard let view = view else {return}
                ($0 as? V)?+>._x(value.getValue(view), type)
            }
        }
        return self
    }
    @discardableResult
    public func x(_ value: RZObservable<RZProtoValue>?, _ type: XType = .left) -> Self{
        if let value = value{ x(value*, type) }
        return self
    }
    
    public enum YType: String{
        case center
        case top
        case down
    }
    
    //MARK: - y
    @discardableResult
    func _y(_ value: CGFloat,  _ type: YType = .top) -> Self{
        switch type {
            case .top:    view.frame.origin.y = value
            case .down:   view.frame.origin.y = value - view.frame.height
            case .center: view.center.y = value
        }
        return self
    }
    @discardableResult
    func _y(_ value: RZProtoValue,  _ type: YType = .top) -> Self{
        value.setValueIn(view, .y) {[weak view] in view?+>._y(value.getValue($0), type)}
        return self
    }
    /// `RU: - `
    /// Устанавливает y view
    ///
    /// - Parameter value
    /// Устанавливаемый y
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.top`
    @discardableResult
    public func y(_ value: CGFloat,  _ type: YType = .top) -> Self{
        view.observeController.remove(.y)
        _y(value, type)
        if type != .top {
            view|*.h.setValueIn(view, .y) { ($0 as? V)?+>._y(value, type) }
        }
        return self
    }
    @discardableResult
    public func y(_ value: RZObservable<CGFloat>?, _ type: YType = .top) -> Self{
        view.observeController.remove(.y)
        let result = value?.add {[weak view] in view?+>._y($0.new, type)}.use(.noAnimate)
        view.observeController.add(.y, result)
        if type != .top {
            view|*.h.setValueIn(view, .y) {[weak value] in
                guard let value = value else {return}
                ($0 as? V)?+>._y(value.wrappedValue, type)
            }
        }
        return self
    }
    
    /// `RU: - `
    /// Устанавливает y view
    ///
    /// - Parameter value
    /// Устанавливаемый в виде вычисляемого `RZProtoValue`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.top`
    @discardableResult
    public func y(_ value: RZProtoValue,  _ type: YType = .top) -> Self{
        view.observeController.remove(.y)
        _y(value, type)
        if type != .top {
            view|*.h.setValueIn(view, .y) {[weak view] in
                guard let view = view else {return}
                ($0 as? V)?+>._y(value.getValue(view), type)
            }
        }
        return self
    }
    @discardableResult
    public func y(_ value: RZObservable<RZProtoValue>?, _ type: YType = .top) -> Self{
        if let value = value{ y(value*, type) }
        return self
    }
    
    @discardableResult
    func _tx(_ value: CGFloat) -> Self{
        view.transform.tx = value
        return self
    }
    @discardableResult
    func _tx(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .tx) { $0+>._tx(value.getValue($0)) }
        return self
    }
    @discardableResult
    public func tx(_ value: CGFloat) -> Self{
        view.observeController.remove(.tx)
        return _tx(value)
    }
    @discardableResult
    public func tx(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.tx)
        let result = value?.add {[weak view] in view?+>._tx($0.new)}.use(.noAnimate)
        view.observeController.add(.tx, result)
        return self
    }
    
    @discardableResult
    public func tx(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.tx)
        return _tx(value)
    }
    @discardableResult
    public func tx(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ tx(value*) }
        return self
    }
    
    
    @discardableResult
    func _ty(_ value: CGFloat) -> Self{
        view.transform.ty = value
        return self
    }
    @discardableResult
    func _ty(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .ty) { $0+>._ty(value.getValue($0)) }
        return self
    }
    @discardableResult
    public func ty(_ value: CGFloat) -> Self{
        view.observeController.remove(.ty)
        return _ty(value)
    }
    @discardableResult
    public func ty(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.ty)
        let result = value?.add {[weak view] in view?+>._ty($0.new)}.use(.noAnimate)
        view.observeController.add(.ty, result)
        return self
    }
    
    @discardableResult
    public func ty(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.ty)
        return _ty(value)
    }
    @discardableResult
    public func ty(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ ty(value*) }
        return self
    }
    
    ///
    
    @discardableResult
    func _ta(_ value: CGFloat) -> Self{
        view.transform.a = value
        return self
    }
    @discardableResult
    func _ta(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .ta) { $0+>._ta(value.getValue($0)) }
        return self
    }
    @discardableResult
    public func ta(_ value: CGFloat) -> Self{
        view.observeController.remove(.ta)
        return _ta(value)
    }
    @discardableResult
    public func ta(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.ta)
        let result = value?.add {[weak view] in view?+>._ta($0.new)}.use(.noAnimate)
        view.observeController.add(.ta, result)
        return self
    }
    
    @discardableResult
    public func ta(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.ta)
        return _ta(value)
    }
    @discardableResult
    public func ta(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ ta(value*) }
        return self
    }
    
    ///
    
    @discardableResult
    func _tb(_ value: CGFloat) -> Self{
        view.transform.b = value
        return self
    }
    @discardableResult
    func _tb(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .tb) { $0+>._tb(value.getValue($0)) }
        return self
    }
    @discardableResult
    public func tb(_ value: CGFloat) -> Self{
        view.observeController.remove(.tb)
        return _tb(value)
    }
    @discardableResult
    public func tb(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.tb)
        let result = value?.add {[weak view] in view?+>._tb($0.new)}.use(.noAnimate)
        view.observeController.add(.tb, result)
        return self
    }
    
    @discardableResult
    public func tb(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.tb)
        return _tb(value)
    }
    @discardableResult
    public func tb(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ tb(value*) }
        return self
    }
    
    ///
    
    @discardableResult
    func _tc(_ value: CGFloat) -> Self{
        view.transform.c = value
        return self
    }
    @discardableResult
    func _tc(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .tc) { $0+>._tc(value.getValue($0)) }
        return self
    }
    @discardableResult
    public func tc(_ value: CGFloat) -> Self{
        view.observeController.remove(.tc)
        return _tc(value)
    }
    @discardableResult
    public func tc(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.tc)
        let result = value?.add {[weak view] in view?+>._tc($0.new)}.use(.noAnimate)
        view.observeController.add(.tc, result)
        return self
    }
    
    @discardableResult
    public func tc(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.tc)
        return _tc(value)
    }
    @discardableResult
    public func tc(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ tc(value*) }
        return self
    }
    
    ///
    
    @discardableResult
    func _td(_ value: CGFloat) -> Self{
        view.transform.d = value
        return self
    }
    @discardableResult
    func _td(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .td) { $0+>._td(value.getValue($0)) }
        return self
    }
    @discardableResult
    public func td(_ value: CGFloat) -> Self{
        view.observeController.remove(.td)
        return _td(value)
    }
    @discardableResult
    public func td(_ value: RZObservable<CGFloat>?) -> Self{
        view.observeController.remove(.td)
        let result = value?.add {[weak view] in view?+>._td($0.new)}.use(.noAnimate)
        view.observeController.add(.td, result)
        return self
    }
    
    @discardableResult
    public func td(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.td)
        return _td(value)
    }
    @discardableResult
    public func td(_ value: RZObservable<RZProtoValue>?) -> Self{
        if let value = value{ td(value*) }
        return self
    }
    
    @discardableResult
    func _transform(_ value: CGAffineTransform) -> Self{
        view.transform = value
        return self
    }
    @discardableResult
    public func transform(_ value: CGAffineTransform) -> Self{
        view.observeController.remove(.transform)
        return _transform(value)
    }
    @discardableResult
    public func transform(_ value: RZObservable<CGAffineTransform>?) -> Self{
        view.observeController.remove(.transform)
        let result = value?.add {[weak view] in view?+>._transform($0.new)}.use(.noAnimate)
        view.observeController.add(.transform, result)
        return self
    }
    
    
    //MARK: - sizeToFit
    /// `RU: - `
    /// Ресайзит view по размеру контента
    @discardableResult
    public func sizeToFit(_ value: Bool = true) -> Self {
        if value{ view.sizeToFit() }
        RZLabelSizeController.setMod(view, .sizeToFit, value)
        return self
    }
    @discardableResult
    public func sizeToFitOnce() -> Self {
        view.sizeToFit()
        return self
    }
    
    //MARK: - contentMode
    /// `RU: - `
    /// Устанавливает `contentMode`
    ///
    /// - Parameter value
    /// Мод контента
    @discardableResult
    public func contentMode(_ value: UIView.ContentMode) -> Self {
        view.contentMode = value
        return self
    }
}

// MARK: - UILabel
extension RZViewBuilder where V: UILabel{
    
    //MARK: - text
    @discardableResult
    func _text(_ value: String?) -> Self{
        view.text = value
        RZLabelSizeController.modUpdate(view)
        return self
    }
    /// `RU: - `
    /// Устанавливает текст для UILabel
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String?) -> Self{
        view.observeController.remove(.text)
        return _text(value)
    }
    @discardableResult
    public func text(_ value: RZObservable<String?>?) -> Self{
        view.observeController.remove(.text)
        let result = value?.add {[weak view] in view?+>._text($0.new)}.use(.noAnimate)
        view.observeController.add(.text, result)
        return self
    }
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        view.observeController.remove(.text)
        let result = value?.add {[weak view] in view?+>._text($0.new)}.use(.noAnimate)
        view.observeController.add(.text, result)
        return self
    }
    
    //MARK: - aligment
    /// `RU: - `
    /// Устанавливает aligment для UILabel
    ///
    /// - Parameter value
    /// Устанавливаемый aligment
    @discardableResult
    public func aligment(_ value: NSTextAlignment)  -> Self{
        view.textAlignment = value
        return self
    }
    
    
    //MARK: - font
    /// `RU: - `
    /// Устанавливает font и добавляет атрибуты для UILabel
    ///
    /// - Parameter value
    /// Устанавливаемый UIFont
    ///
    /// - Parameter attributes
    /// Добавляемые атрибуты
    @discardableResult
    public func font(_ value: UIFont, _ attributes: [NSAttributedString.Key: Any] = [:]) -> Self{
        if view.text == nil || view.text == "" { view.text = " " }
        view.font = value
        let textAlignment = view.textAlignment
        
        var attributedText: NSMutableAttributedString?
        if let attributedTextL = view.attributedText{
            attributedText = NSMutableAttributedString(attributedString: attributedTextL)
        }
        attributedText?.addAttributes(attributes, range: NSRange(location: 0, length: view.text?.count ?? 0))
        view.attributedText = attributedText
        
        view.textAlignment = textAlignment
        
        RZLabelSizeController.setMod(view, .font(view.font))
        return self
    }
    
//    @discardableResult
//    public func font(_ value: RZObservable<UIFont>?, _ attributes: [NSAttributedString.Key: Any] = [:]) -> Self{
//        value?.add {[weak view] in view?+>.font($0.new, attributes)}.use(.noAnimate)
//        return self
//    }
    
    //MARK: - sizes
    /// `RU: - `
    /// Функция автоматического масштабирования текста по размеру UILabel
    @discardableResult
    public func sizes(_ value: CGFloat = 0.1) -> Self{
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = value
        return self
    }
    
    //MARK: - value
    /// `RU: - `
    /// Устанавливает максимальное количество строк
    ///
    /// - Parameter value
    /// Максимальное количество строк, для снятия ограничения установите значение 0
    @discardableResult
    public func lines(_ value: Int) -> Self{
        view.numberOfLines = value
        return self
    }
    
}

// MARK: - UITextField
extension RZViewBuilder where V: UITextField{
    
    @discardableResult
    func _text(_ value: String?) -> Self{
        view.text = value
        RZLabelSizeController.modUpdate(view)
        return self
    }
    /// `RU: - `
    /// Устанавливает текст для UITextField
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String?) -> Self{
        view.observeController.remove(.text)
        return _text(value)
    }
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        view.observeController.remove(.text)
        let result = value?.add {[weak view] in view?+>._text($0.new)}.use(.noAnimate)
        view.observeController.add(.text, result)
        value?.setTextObserve(view)
        return self
    }
    
    //MARK: - aligment
    /// `RU: - `
    /// Устанавливает aligment для UITextField
    ///
    /// - Parameter value
    /// Устанавливаемый aligment
    @discardableResult
    public func aligment(_ value: NSTextAlignment)  -> Self{
        view.textAlignment = value
        return self
    }
    
    
    //MARK: - font
    /// `RU: - `
    /// Устанавливает font и добавляет атрибуты для UITextField
    ///
    /// - Parameter value
    /// Устанавливаемый UIFont
    ///
    /// - Parameter attributes
    /// Добавляемые атрибуты
    @discardableResult
    public func font(_ value: UIFont, _ attributes: [NSAttributedString.Key: Any] = [:]) -> Self{
        if view.text == nil || view.text == "" { view.text = " " }
        view.font = value
        let textAlignment = view.textAlignment
        
        var attributedText: NSMutableAttributedString?
        if let attributedTextL = view.attributedText{
            attributedText = NSMutableAttributedString(attributedString: attributedTextL)
        }
        attributedText?.addAttributes(attributes, range: NSRange(location: 0, length: view.text?.count ?? 0))
        view.attributedText = attributedText
        
        view.textAlignment = textAlignment
        
        RZLabelSizeController.setMod(view, .font(view.font ?? UIFont()))
        return self
    }
    
    @discardableResult
    public func font(_ value: RZObservable<UIFont>?, _ attributes: [NSAttributedString.Key: Any] = [:]) -> Self{
        value?.add {[weak view] in view?+>.font($0.new, attributes)}.use(.noAnimate)
        return self
    }
    
    public enum TextFieldViewPos {
        case left, right
    }
    
    @discardableResult
    public func sideView(_ value: UIView?, _ position: TextFieldViewPos = .left) -> Self {
        switch position {
            case .left: view.leftView = value
            case .right: view.rightView = value
        }
        return self
    }
    
    @discardableResult
    public func sideSpace(_ value: CGFloat, _ position: TextFieldViewPos = .left) -> Self {
        let spaceView = UIView()+>.height(view|*.h).width(value).view
        sideView(spaceView, position)
        return self
    }
    
    @discardableResult
    public func sideSpace(_ value: RZProtoValue, _ position: TextFieldViewPos = .left) -> Self {
        let spaceView = UIView()+>.height(view|*.h).width(value).view
        sideView(spaceView, position)
        return self
    }
    
    @discardableResult
    public func sideSpace(_ value: RZObservable<CGFloat>, _ position: TextFieldViewPos = .left) -> Self {
        let spaceView = UIView()+>.height(view|*.h).width(value).view
        sideView(spaceView, position)
        return self
    }
    
    @discardableResult
    public func sideSpace(_ value: RZObservable<RZProtoValue>, _ position: TextFieldViewPos = .left) -> Self {
        let spaceView = UIView()+>.height(view|*.h).width(value).view
        sideView(spaceView, position)
        return self
    }
    
    @discardableResult
    public func sideMode(_ value: UITextField.ViewMode, _ position: TextFieldViewPos = .left) -> Self {
        switch position {
            case .left: view.leftViewMode = value
            case .right: view.rightViewMode = value
        }
        return self
    }
    
    @discardableResult
    public func secured(_ secured: Bool) -> Self {
        view.isSecureTextEntry = secured
        return self
    }
    
    @discardableResult
    public func keyboard(_ keyboard: UIKeyboardType) -> Self {
        view.keyboardType = keyboard
        return self
    }
    
    @discardableResult
    public func capitalization(_ type: UITextAutocapitalizationType) -> Self {
        view.autocapitalizationType = type
        return self
    }
    
    @discardableResult
    func _placeholder(_ text: String) -> Self {
        view.placeholder = text
        return self
    }
    
    @discardableResult
    public func placeholder(_ text: String) -> Self {
        view.observeController.remove(.placeholder)
        return _placeholder(text)
    }
    
    @discardableResult
    public func placeholder(_ text: RZObservable<String>) -> Self {
        view.observeController.remove(.placeholder)
        let result = text.add {[weak self] in self?._placeholder($0.new) }.use(.noAnimate)
        view.observeController.add(.placeholder, result)
        return self
    }
}

// MARK: - UITextView
extension RZViewBuilder where V: UITextView{
    
    @discardableResult
    func _text(_ value: String?) -> Self{
        view.text = value
        RZLabelSizeController.modUpdate(view)
        return self
    }
    /// `RU: - `
    /// Устанавливает текст для UITextView
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String?) -> Self{
        view.observeController.remove(.text)
        return _text(value)
    }
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        view.observeController.remove(.text)
        let result = value?.add {[weak view] in view?+>._text($0.new)}.use(.noAnimate)
        view.observeController.add(.text, result)
        value?.setTextObserve(view)
        return self
    }
}

// MARK: - UIButton
extension RZViewBuilder where V: UIButton{

    //MARK: - text
    @discardableResult
    func _text(_ value: String?) -> Self{
        view.setTitle(value, for: .normal)
        return self
    }
    /// `RU: - `
    /// Устанавливает текст для UIButton
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String?) -> Self{
        view.observeController.remove(.text)
        return _text(value)
    }
    @discardableResult
    public func text(_ value: RZObservable<String?>?) -> Self{
        view.observeController.remove(.text)
        let result = value?.add {[weak view] in view?+>._text($0.new)}.use(.noAnimate)
        view.observeController.add(.text, result)
        return self
    }
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        view.observeController.remove(.text)
        let result = value?.add {[weak view] in view?+>._text($0.new)}.use(.noAnimate)
        view.observeController.add(.text, result)
        return self
    }
    
    //MARK: - font
    /// `RU: - `
    /// Устанавливает font и добавляет атрибуты для UIButton
    ///
    /// - Parameter value
    /// Устанавливаемый UIFont
    ///
    /// - Parameter attributes
    /// Добавляемые атрибуты
    @discardableResult
    public func font(_ value: UIFont, _ attributes: [NSAttributedString.Key:Any] = [:]) -> Self{
        view.titleLabel?+>.font(value, attributes)
        return self
    }
    
    //MARK: - addAction
    /// `RU: - `
    /// Задает action, который сработает при нажатии на кнопку
    ///
    /// - Parameter controlEvents
    /// Условие срабатывания action
    ///
    /// - Parameter closure
    /// Устанавливаемый action
    @discardableResult
    public func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) -> Self{
        view.addAction(for: controlEvents, closure)
        return self
    }
    
    public enum ImageType: String{
        case front
        case background
    }
    
    @discardableResult
    func _image(_ value: UIImage?, _ imageType: ImageType = .front) -> Self{
        if imageType == .background{
            view.setBackgroundImage(value, for: .normal)
        }else{
            view.setImage(value, for: .normal)
        }
        return self
    }
    @discardableResult
    public func image(_ value: UIImage?, _ imageType: ImageType = .front) -> Self{
        view.observeController.remove(.image)
        return _image(value, imageType)
    }

    @discardableResult
    public func image(_ value: RZObservable<UIImage>?, _ imageType: ImageType = .front) -> Self{
        view.observeController.remove(.image)
        let result = value?.add{[weak view] in view?+>._image($0.new, imageType)}.use(.noAnimate)
        view.observeController.add(.image, result)
        return self
    }
    
    @discardableResult
    public func image(_ value: RZObservable<UIImage?>?, _ imageType: ImageType = .front) -> Self{
        view.observeController.remove(.image)
        let result = value?.add{[weak view] in view?+>._image($0.new, imageType)}.use(.noAnimate)
        view.observeController.add(.image, result)
        return self
    }
    
    @discardableResult
    func _labelView(_ value: UIView?) -> Self{
        view.labelView = value
        return self
    }
    @discardableResult
    public func labelView(_ value: UIView?) -> Self{
        view.observeController.remove(.labelView)
        return _labelView(value)
    }
    @discardableResult
    public func labelView(_ value: RZObservable<UIView?>?) -> Self{
        view.observeController.remove(.labelView)
        let result = value?.add{[weak view] in view?+>._labelView($0.new)}
        view.observeController.add(.labelView, result)
        return self
    }
    @discardableResult
    public func labelView(_ value: (V) -> (UIView?)) -> Self{
        view.observeController.remove(.labelView)
        return _labelView(value(view))
    }
}

// MARK: - UIImageView
extension RZViewBuilder where V: UIImageView{
    @discardableResult
    func _image(_ value: UIImage?) -> Self {
        view.image = value
        return self
    }
    //MARK: - image
    /// `RU: - `
    /// Устанавливает изображение для `UIImageView`
    ///
    /// - Parameter value
    /// Устанавливаемое изображение
    @discardableResult
    public func image(_ value: UIImage?) -> Self {
        view.observeController.remove(.image)
        return _image(value)
    }
    @discardableResult
    public func image(_ value: RZObservable<UIImage?>?) -> Self{
        view.observeController.remove(.image)
        let result = value?.add {[weak view] in view?+>._image($0.new)}.use(.noAnimate)
        view.observeController.add(.image, result)
        return self
    }
    @discardableResult
    public func image(_ value: RZObservable<UIImage>?) -> Self{
        view.observeController.remove(.image)
        let result = value?.add {[weak view] in view?+>._image($0.new)}.use(.noAnimate)
        view.observeController.add(.image, result)
        return self
    }
}

// MARK: - UIScrollView
extension RZViewBuilder where V: UIScrollView{
    //MARK: - contentSize
    @discardableResult
    public func contentSize(_ value: CGSize) -> Self{
        view+>.contentWidth(value.width).contentHeight(value.height)
        return self
    }
    
    @discardableResult
    func _contentWidth(_ value: CGFloat) -> Self{
        view.contentSize.width = value
        return self
    }
    //MARK: - contentWidth
    @discardableResult
    public func contentWidth(_ value: CGFloat) -> Self{
        view.observeController.remove(.contentWidth)
        return _contentWidth(value)
    }
    @discardableResult
    public func contentWidth(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.contentWidth)
        value.setValueIn(view, .contentWidth) { ($0 as? UIScrollView)?+>._contentWidth(value.getValue($0)) }
        return self
    }
    
    @discardableResult
    func _contentHeight(_ value: CGFloat) -> Self{
        view.contentSize.height = value
        return self
    }
    @discardableResult
    public func contentHeight(_ value: CGFloat) -> Self{
        view.observeController.remove(.contentHeight)
        return _contentHeight(value)
    }
    
    @discardableResult
    public func contentHeight(_ value: RZProtoValue) -> Self{
        view.observeController.remove(.contentHeight)
        value.setValueIn(view, .contentHeight) { ($0 as? UIScrollView)?+>._contentHeight(value.getValue($0)) }
        return self
    }
}


public struct RZVBTemplate<View: UIView> {
    public typealias Complition = (@escaping ()->())->()
    private var template: (View, Complition)->()
    
    public func use(view: View){
        var complition = {}
        template(view, {complition = $0})
        complition()
    }
    func use(view: View, _ ac: RZAnimationCompletion){ template(view, { ac.completion = $0 }) }
    
    public init(_ template: @escaping (View)->()) { self.template = {view, _ in template(view)} }
    public init(_ template: @escaping (View, Complition)->()) { self.template = template }
}

//public enum RZVBTemplatePosition{
//    case vertical
//    case horizontal
//    case all
//
//    case right
//    case left
//    case up
//    case down
//}


//extension RZVBTemplate{
//    public static func custom(_ template: @escaping (View)->()) -> Self {RZVBTemplate(template)}
//
//    public static func center(_ position: RZVBTemplatePosition = .all) -> Self {
//        .custom {
//            switch position {
//                case .vertical:   $0+>.y(.screenTag(.scY), .center)
//                case .horizontal: $0+>.x(.screenTag(.scX), .center)
//                default:          $0+>.x(.screenTag(.scX), .center).y(.screenTag(.scY), .center)
//            }
//        }
//    }
//
//    public static func space(_ position: RZVBTemplatePosition = .all, _ value: RZProtoValue) -> Self {
//        .custom {
//            switch position {
//                case .left:  $0+>.x(value)
//                case .right: $0+>.x(.screenTag(.w) - value, .right)
//                case .up:    $0+>.y(value)
//                case .down:  $0+>.y(.screenTag(.h) - value, .down)
//            default: break
//            }
//        }
//    }
//
//}

@resultBuilder public struct RZVBTemplateBuilder{
    public static func buildBlock<View: UIView>(_ atrs: RZVBTemplate<View>...) -> [RZVBTemplate<View>] {
        return atrs
    }
}
