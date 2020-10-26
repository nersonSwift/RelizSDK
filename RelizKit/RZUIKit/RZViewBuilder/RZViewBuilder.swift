//
//  RZViewBilder.swift
//  Yoga
//
//  Created by Александр Сенин on 15.10.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit
import SVGKit

//MARK: - UIView
public class RZViewBuilder<V: UIView>{
    //MARK: - view
    /// `RU: - `
    /// Редактируемое view
    public var view: V!
    
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
    
    /// `RU: - `
    /// Устанавливает радиус скругления редактироемому view
    ///
    /// - Parameter value
    /// Радиус скругления в ввиде вычесляемого `RZProtoValue`
    @discardableResult
    public func cornerRadius(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, 1) { $0.layer.cornerRadius = value.getValue($0.frame) }
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
    public func mask(_ value: UIView, _ size: RZProtoSize = RZProtoSize(width: 100 % RZProto().w, height: 100 % RZProto().h)) -> Self{
        value+>.size(size).x(view|*.cX, .center).y(view|*.cY, .center)
        view.mask = value
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
    
    /// `RU: - `
    /// Устанавливает size view
    ///
    /// - Parameter value
    /// Устанавляиваемый size в ввиде вычесляемого `RZProtoSize`
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
    
    //MARK: - point
    /// `RU: - `
    /// Устанавливает ширену view
    ///
    /// - Parameter value
    /// Устанавляиваемая ширена
    @discardableResult
    public func width(_ value: CGFloat) -> Self{
        view.frame.size.width = value
        RZLabelSizeController.modUpdate(view)
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
        value.setValueIn(view, 2) { $0.frame.size.width = value.getValue($0.frame); RZLabelSizeController.modUpdate($0) }
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
    
    /// `RU: - `
    /// Устанавливает высоту view
    ///
    /// - Parameter value
    /// Устанавляиваемая высота в виде вычесляемого `RZProtoValue`
    @discardableResult
    public func height(_ value: RZProtoValue) -> Self{
        value.setValueIn(view, 3) { $0.frame.size.height = value.getValue($0.frame) }
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
        case .left:   value.setValueIn(view, 4) { $0.frame.origin.x = value.getValue($0.frame) }
        case .right:  value.setValueIn(view, 4) { $0.frame.origin.x = value.getValue($0.frame) - $0.frame.width }
        case .center: value.setValueIn(view, 4) { $0.center.x = value.getValue($0.frame) }
        }
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
        case .top:    value.setValueIn(view, 5) { $0.frame.origin.y = value.getValue($0.frame) }
        case .down:   value.setValueIn(view, 5) { $0.frame.origin.y = value.getValue($0.frame) - $0.frame.height }
        case .center: value.setValueIn(view, 5) { $0.center.y = value.getValue($0.frame) }
        }
        
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
    
    private static func setSizeToFit(_ value: UIView){
        if let key = UnsafeRawPointer(bitPattern: 2){
            let flag = (objc_getAssociatedObject(value, key) as? Bool) ?? false
            if flag {
                value.sizeToFit()
            }
        }
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
    public func text(_ value: String) -> Self{
        view.text = value
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
    public func font(_ value: UIFont, _ attributes: [NSAttributedString.Key:Any] = [:]) -> Self{
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
    
    //MARK: - sizes
    /// `RU: - `
    /// Функция автоматического маштабирования текста по размеру UILabel
    @discardableResult
    public func sizes() -> Self{
        RZLabelSizeController.setMod(view, .sizes)
        RZLabelSizeController.modUpdate(view)
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
    
    /// `RU: - `
    /// Устанавливает изображение для `UIImageView`
    ///
    /// - Parameter value
    /// Устанавливаемое изображение
    @discardableResult
    public func image(_ value: SVGKImage?) -> Self {
        return image(value?.uiImage)
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
}





