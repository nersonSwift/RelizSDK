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
    /// Принемает view для редактирования
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
    
    public enum ColorType {
        case background
        case content
        case boder
        case shadow
    }
    
    //MARK: - color
    /// `RU: - `
    /// Устанавливает цвет редактироемому view
    ///
    /// - Parameter value
    /// Устанавливаемый цвет, при необоходимости конвертирует цвет в `CGColor`
    ///
    /// Поддерживает адаптивные цвета RZDarkModeKit
    ///
    /// - Parameter type
    /// Тег мета установки цвета
    @discardableResult
    public func color(_ value: UIColor, _ type: ColorType = .background) -> Self {
        switch type {
            case .background: view <- { $0.backgroundColor = value }
            case .content: self.setContentColor(value)
            case .boder: view <- { $0.layer.borderColor = value.cgColor }
            case .shadow: view <- { $0.layer.shadowColor = value.cgColor }
        }
        return self
    }
    @discardableResult
    public func color(_ value: RZObservable<UIColor>?, _ type: ColorType = .background) -> Self{
        value?.add {[weak view] in view?+>.color($0.new, type)}.use(.noAnimate)
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
    
    //MARK: - cornerRadius
    /// `RU: - `
    /// Устанавливает радиус скругления редактироемому view
    ///
    /// - Parameter value
    /// Радиус скругления
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self{
        view.layer.cornerRadius = value
        return self
    }
    @discardableResult
    public func cornerRadius(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.cornerRadius($0.new)}.use(.noAnimate)
        return self
    }
    
    
    /// `RU: - `
    /// Устанавливает радиус скругления редактироемому view
    ///
    /// - Parameter value
    /// Радиус скругления в ввиде вычесляемого `RZProtoValue`
    @discardableResult
    public func cornerRadius(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .cornerRadius) { $0.layer.cornerRadius = value.getValue($0) }
        return self
    }
    @discardableResult
    public func cornerRadius(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.cornerRadius($0.new)}.use(.noAnimate)
        return self
    }
    
    //MARK: - border
    /// `RU: - `
    /// Устанавливает толщину обводки
    ///
    /// Цвет обводки устанавливается методом `color` с паремметром `.border`
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
    /// Цвет обводки устанавливается методом `color` с паремметром `.border`
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
    /// Устанавливает устанавливает маску
    ///
    /// Размер маски по умолчанию равен размеру view. Маска выравнивается по центру view.
    ///
    /// - Parameter value
    /// view используемое как маска
    @discardableResult
    public func mask(_ value: UIView) -> Self{
        if value.frame.size == .zero{
            value+>.size(RZProtoSize(width: view|*.w, height: view|*.h))
        }
        value+>.x(view|*.scX, .center).y(view|*.scY, .center)
        view.mask = value
        return self
    }
    
    @discardableResult
    public func alpha(_ value: CGFloat) -> Self{
        view.alpha = value
        return self
    }
    @discardableResult
    public func alpha(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.alpha($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func isHidden(_ value: Bool) -> Self{
        view.isHidden = value
        return self
    }
    @discardableResult
    public func isHidden(_ value: RZObservable<Bool>?) -> Self{
        value?.add {[weak view] in view?+>.isHidden($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func template(_ value: RZVBTemplate<V>) -> Self{
        value.use(view: view)
        return self
    }
    @discardableResult
    public func template(_ value: RZObservable<RZVBTemplate<V>>?) -> Self{
        value?.add {[weak view] in
            guard let view = view else {return}
            $0.new.use(view: view, $0.animationCompletion)
        }.use(.noAnimate)
        return self
    }
    @discardableResult
    public func template(_ value: (V)->()) -> Self{
        value(view)
        return self
    }
    @discardableResult
    public func template(_ value: RZObservable<(V)->()>?) -> Self{
        value?.add {[weak view] in view?+>.template($0.new)}.use(.noAnimate)
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
    /// `RU: - `
    /// Устанавливает frame view
    ///
    /// - Parameter value
    /// Устанавляиваемый frame
    ///
    /// - Parameter type
    /// Точка крепления view
    @discardableResult
    public func frame(_ value: CGRect, _ type: PointType = .topLeft) -> Self {
        return point(value.origin).size(value.size)
    }
    @discardableResult
    public func frame(_ value: RZObservable<CGRect>?, _ type: PointType = .topLeft) -> Self{
        value?.add {[weak view] in view?+>.frame($0.new, type)}.use(.noAnimate)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает frame view
    ///
    /// - Parameter value
    /// Устанавляиваемый frame в ввиде вычесляемого `RZProtoFrame`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.topLeft`
    @discardableResult
    public func frame(_ value: RZProtoFrame, _ type: PointType = .topLeft) -> Self {
        return point(value.origin).size(value.size)
    }
    @discardableResult
    public func frame(_ value: RZObservable<RZProtoFrame>?, _ type: PointType = .topLeft) -> Self{
        value?.add {[weak view] in view?+>.frame($0.new, type)}.use(.noAnimate)
        return self
    }
    
    //MARK: - size
    /// `RU: - `
    /// Устанавливает size view
    ///
    /// - Parameter value
    /// Устанавляиваемый size
    @discardableResult
    public func size(_ value: CGSize) -> Self{
        return width(value.width).height(value.height)
    }
    @discardableResult
    public func size(_ value: RZObservable<CGSize>?) -> Self{
        value?.add {[weak view] in view?+>.size($0.new)}.use(.noAnimate)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает size view
    ///
    /// - Parameter value
    /// Устанавляиваемый size в ввиде вычесляемого `RZProtoSize`
    @discardableResult
    public func size(_ value: RZProtoSize) -> Self{
        return width(value.width).height(value.height)
    }
    @discardableResult
    public func size(_ value: RZObservable<RZProtoSize>?) -> Self{
        value?.add {[weak view] in view?+>.size($0.new)}.use(.noAnimate)
        return self
    }
    
    public enum PointType: String{
        case center
        case topLeft
        case topRight
        case downRight
        case downLeft
    }
    
    //MARK: - point
    /// `RU: - `
    /// Устанавливает point view
    ///
    /// - Parameter value
    /// Устанавляиваемый point
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.topLeft`
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
    public func point(_ value: RZObservable<CGPoint>?, _ type: PointType = .topLeft) -> Self{
        value?.add {[weak view] in view?+>.point($0.new, type)}.use(.noAnimate)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает point view
    ///
    /// - Parameter value
    /// Устанавляиваемый point в ввиде вычесляемого `RZProtoPoint`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.topLeft`
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
    public func point(_ value: RZObservable<RZProtoPoint>?, _ type: PointType = .topLeft) -> Self{
        value?.add {[weak view] in view?+>.point($0.new, type)}.use(.noAnimate)
        return self
    }
    
    //MARK: - point
    /// `RU: - `
    /// Устанавливает ширену view
    ///
    /// - Parameter value
    /// Устанавляиваемая ширена
    @discardableResult
    public func width(_ value: CGFloat) -> Self{
        view.frame.size.width = value
        RZLabelSizeController.modUpdate(view, true)
        return self
    }
    @discardableResult
    public func width(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.width($0.new)}.use(.noAnimate)
        return self
    }
    
    //MARK: - width
    /// `RU: - `
    /// Устанавливает ширену view
    ///
    /// - Parameter value
    /// Устанавляиваемая ширена в виде вычесляемого `RZProtoValue`
    @discardableResult
    public func width(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .width) { $0.frame.size.width = value.getValue($0); RZLabelSizeController.modUpdate($0, true) }
        return self
    }
    @discardableResult
    public func width(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.width($0.new)}.use(.noAnimate)
        return self
    }
    
    //MARK: - height
    /// `RU: - `
    /// Устанавливает высоту view
    ///
    /// - Parameter value
    /// Устанавляиваемая высота
    @discardableResult
    public func height(_ value: CGFloat) -> Self{
        view.frame.size.height = value
        return self
    }
    @discardableResult
    public func height(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.height($0.new)}.use(.noAnimate)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает высоту view
    ///
    /// - Parameter value
    /// Устанавляиваемая высота в виде вычесляемого `RZProtoValue`
    @discardableResult
    public func height(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .height) { $0.frame.size.height = value.getValue($0) }
        return self
    }
    @discardableResult
    public func height(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.height($0.new)}.use(.noAnimate)
        return self
    }
    
    public enum XType: String{
        case center
        case left
        case right
    }
    
    //MARK: - х
    /// `RU: - `
    /// Устанавливает х view
    ///
    /// - Parameter value
    /// Устанавляиваемый х
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.left`
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
    public func x(_ value: RZObservable<CGFloat>?,  _ type: XType = .left) -> Self{
        value?.add {[weak view] in view?+>.x($0.new, type)}.use(.noAnimate)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает х view
    ///
    /// - Parameter value
    /// Устанавляиваемый х в виде вычесляемого `RZProtoValue`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.left`
    @discardableResult
    public func x(_ value: RZProtoValue,  _ type: XType = .left) -> Self{
        switch type {
        case .left:   value.setValueIn(view, .x) { $0.frame.origin.x = value.getValue($0) }
        case .right:
            value.setValueIn(view, .x) { $0.frame.origin.x = value.getValue($0) - $0.frame.width }
            view|*.w.setValueIn(view, .x, false) { $0.frame.origin.x = value.getValue($0) - $0.frame.width }
        case .center:
            value.setValueIn(view, .x) { $0.center.x = value.getValue($0) }
            view|*.w.setValueIn(view, .x, false) { $0.center.x = value.getValue($0) }
        }
        return self
    }
    @discardableResult
    public func x(_ value: RZObservable<RZProtoValue>?, _ type: XType = .left) -> Self{
        value?.add {[weak view] in view?+>.x($0.new, type)}.use(.noAnimate)
        return self
    }
    
    public enum YType: String{
        case center
        case top
        case down
    }
    
    //MARK: - y
    /// `RU: - `
    /// Устанавливает y view
    ///
    /// - Parameter value
    /// Устанавляиваемый y
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.top`
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
    public func y(_ value: RZObservable<CGFloat>?, _ type: YType = .top) -> Self{
        value?.add {[weak view] in view?+>.y($0.new, type)}.use(.noAnimate)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает y view
    ///
    /// - Parameter value
    /// Устанавляиваемый y виде вычесляемого `RZProtoValue`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.top`
    @discardableResult
    public func y(_ value: RZProtoValue,  _ type: YType = .top) -> Self{
        switch type {
        case .top:    value.setValueIn(view, .y) { $0.frame.origin.y = value.getValue($0) }
        case .down:
            value.setValueIn(view, .y) { $0.frame.origin.y = value.getValue($0) - $0.frame.height }
            view|*.h.setValueIn(view, .y, false) { $0.frame.origin.y = value.getValue($0) - $0.frame.height }
        case .center:
            value.setValueIn(view, .y) { $0.center.y = value.getValue($0) }
            view|*.h.setValueIn(view, .y, false) { $0.center.y = value.getValue($0) }
        }
        
        return self
    }
    @discardableResult
    public func y(_ value: RZObservable<RZProtoValue>?, _ type: YType = .top) -> Self{
        value?.add {[weak view] in view?+>.y($0.new, type)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func tx(_ value: CGFloat) -> Self{
        view.transform.tx = value
        return self
    }
    @discardableResult
    public func tx(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.tx($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func tx(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .tx) { $0.transform.tx = value.getValue($0) }
        return self
    }
    @discardableResult
    public func tx(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.tx($0.new)}.use(.noAnimate)
        return self
    }
    
    
    @discardableResult
    public func ty(_ value: CGFloat) -> Self{
        view.transform.ty = value
        return self
    }
    @discardableResult
    public func ty(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.ty($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func ty(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .ty) { $0.transform.ty = value.getValue($0) }
        return self
    }
    @discardableResult
    public func ty(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.ty($0.new)}.use(.noAnimate)
        return self
    }
    
    
    @discardableResult
    public func ta(_ value: CGFloat) -> Self{
        view.transform.a = value
        return self
    }
    @discardableResult
    public func ta(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.ta($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func ta(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .ta) { $0.transform.a = value.getValue($0) }
        return self
    }
    @discardableResult
    public func ta(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.tb($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func tb(_ value: CGFloat) -> Self{
        view.transform.b = value
        return self
    }
    @discardableResult
    public func tb(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.tb($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func tb(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .tb) { $0.transform.b = value.getValue($0) }
        return self
    }
    @discardableResult
    public func tb(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.tb($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func tc(_ value: CGFloat) -> Self{
        view.transform.c = value
        return self
    }
    @discardableResult
    public func tc(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.tc($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func tc(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .tc) { $0.transform.c = value.getValue($0) }
        return self
    }
    @discardableResult
    public func tc(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.tc($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func td(_ value: CGFloat) -> Self{
        view.transform.d = value
        return self
    }
    @discardableResult
    public func td(_ value: RZObservable<CGFloat>?) -> Self{
        value?.add {[weak view] in view?+>.td($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func td(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .td) { $0.transform.d = value.getValue($0) }
        return self
    }
    @discardableResult
    public func td(_ value: RZObservable<RZProtoValue>?) -> Self{
        value?.add {[weak view] in view?+>.td($0.new)}.use(.noAnimate)
        return self
    }
    
    @discardableResult
    public func transform(_ value: CGAffineTransform) -> Self{
        view.transform = value
        return self
    }
    @discardableResult
    public func transform(_ value: RZObservable<CGAffineTransform>?) -> Self{
        value?.add {[weak view] in view?+>.transform($0.new)}.use(.noAnimate)
        return self
    }
    
    
    //MARK: - sizeToFit
    /// `RU: - `
    /// Ресайзит view по размеру контента
    @discardableResult
    public func sizeToFit(_ value: Bool = true) -> Self {
        view.sizeToFit()
        RZLabelSizeController.setMod(view, .sizeToFit)
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
    /// `RU: - `
    /// Устанавливает текст для UILabel
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String?) -> Self{
        view.text = value
        RZLabelSizeController.modUpdate(view)
        return self
    }
    @discardableResult
    public func text(_ value: RZObservable<String?>?) -> Self{
        value?.add {[weak view] in view?+>.text($0.new)}.use(.noAnimate)
        return self
    }
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        value?.add {[weak view] in view?+>.text($0.new)}.use(.noAnimate)
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
    
    @discardableResult
    public func font(_ value: RZObservable<UIFont>?, _ attributes: [NSAttributedString.Key: Any] = [:]) -> Self{
        value?.add {[weak view] in view?+>.font($0.new, attributes)}.use(.noAnimate)
        return self
    }
    
    //MARK: - sizes
    /// `RU: - `
    /// Функция автоматического маштабирования текста по размеру UILabel
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
    /// Максимально количество строк, для снятивания ограничения установите значение 0
    @discardableResult
    public func lines(_ value: Int) -> Self{
        view.numberOfLines = value
        return self
    }
    
}

// MARK: - UILabel
extension RZViewBuilder where V: UITextField{
    
    //MARK: - text
    /// `RU: - `
    /// Устанавливает текст для UILabel
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String?) -> Self{
        view.text = value
        RZLabelSizeController.modUpdate(view)
        return self
    }
    
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        value?.add {[weak view] in view?+>.text($0.new)}.use(.noAnimate)
        value?.setTextObserve(view)
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
        
        RZLabelSizeController.setMod(view, .font(view.font ?? UIFont()))
        return self
    }
    
    @discardableResult
    public func font(_ value: RZObservable<UIFont>?, _ attributes: [NSAttributedString.Key: Any] = [:]) -> Self{
        value?.add {[weak view] in view?+>.font($0.new, attributes)}.use(.noAnimate)
        return self
    }
    
}

// MARK: - UILabel
extension RZViewBuilder where V: UITextView{
    
    //MARK: - text
    /// `RU: - `
    /// Устанавливает текст для UILabel
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String?) -> Self{
        view.text = value
        RZLabelSizeController.modUpdate(view)
        return self
    }
    
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        value?.add {[weak view] in view?+>.text($0.new)}.use(.noAnimate)
        value?.setTextObserve(view)
        return self
    }
}

// MARK: - UIButton
extension RZViewBuilder where V: UIButton{
    //MARK: - text
    /// `RU: - `
    /// Устанавливает текст для UIButton
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String) -> Self{
        view.setTitle(value, for: .normal)
        return self
    }
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        value?.add {[weak view] in view?+>.text($0.new)}.use(.noAnimate)
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
    /// Задает action который сработает при нажатии на кнопку
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

}

// MARK: - UIImageView
extension RZViewBuilder where V: UIImageView{
    //MARK: - image
    /// `RU: - `
    /// Устанавливает изображение для `UIImageView`
    ///
    /// - Parameter value
    /// Устанавливаемое изображение
    @discardableResult
    public func image(_ value: UIImage?) -> Self {
        view.image = value
        return self
    }
    @discardableResult
    public func image(_ value: RZObservable<UIImage?>?) -> Self{
        value?.add {[weak view] in view?+>.image($0.new)}.use(.noAnimate)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает изображение для `UIImageView`
    ///
    /// - Parameter value
    /// Устанавливаемое изображение в виде динамического `RZImageSeter`
    @discardableResult
    public func image(_ value: RZImageSeter) -> Self{
        value.setImageView(view)
        return self
    }
    @discardableResult
    public func image(_ value: RZObservable<RZImageSeter>?) -> Self{
        value?.add {[weak view] in view?+>.image($0.new)}.use(.noAnimate)
        return self
    }
}

extension RZViewBuilder where V: UIScrollView{
    //MARK: - contentSize
    @discardableResult
    public func contentSize(_ value: CGSize) -> Self{
        view.contentSize = value
        return self
    }
    
    @discardableResult
    public func contentSize(_ value: RZProtoSize) -> Self{
        return self.contentWidth(value.width).contentHeight(value.height)
    }
    
    //MARK: - contentWidth
    @discardableResult
    public func contentWidth(_ value: CGFloat) -> Self{
        view.contentSize.width = value
        return self
    }
    @discardableResult
    public func contentWidth(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .contentWidth) { ($0 as? UIScrollView)?.contentSize.width = value.getValue($0) }
        return self
    }
    
    @discardableResult
    public func contentHeight(_ value: CGFloat) -> Self{
        view.contentSize.height = value
        return self
    }
    
    @discardableResult
    public func contentHeight(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, .contentHeight) { ($0 as? UIScrollView)?.contentSize.height = value.getValue($0) }
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

@_functionBuilder public struct RZVBTemplateBuilder{
    public static func buildBlock<View: UIView>(_ atrs: RZVBTemplate<View>...) -> [RZVBTemplate<View>] {
        return atrs
    }
}
