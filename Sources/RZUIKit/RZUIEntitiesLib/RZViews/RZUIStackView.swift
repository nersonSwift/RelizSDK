//
//  RZUIStackView.swift
//  Example
//
//  Created by Александр Сенин on 07.10.2021.
//

import UIKit
import RZObservableKit
import RZViewBuilderKit

open class RZUIStackView: UIView{
    public enum PositingType {
        case vertical
        case horizontal
    }
    public enum AlignmentH {
        case top
        case bottom
        case center
    }
    public enum AlignmentV {
        case left
        case right
        case center
    }
    public struct ViewStorage {
        var view: UIView
        var resilt: RZOResult<CGRect>?
    }
    
    @RZObservable private var maxValueW: RZProtoValue = 0*
    @RZObservable private var maxValueH: RZProtoValue = 0*
    
    @RZObservable var space: RZProtoValue = 0*
    @RZObservable var positingType: PositingType = .horizontal
    @RZObservable var alignmentV: AlignmentV = .center
    @RZObservable var alignmentH: AlignmentH = .center
    
    private var viewStorages = [ViewStorage]()
    var views: [UIView] { viewStorages.map { $0.view } }
    
    public required init(){
        super.init(frame: .zero)
        $positingType.add {[weak self] _ in
            var lastView: UIView?
            for i in self?.viewStorages ?? []{
                self?.setViewPosition(i.view, lastView)
                self?.setViewAlignment(i.view, lastView)
                lastView = i.view
            }
            self?.setSelfSize()
        }
        $alignmentV.add {[weak self] _ in
            var lastView: UIView?
            for i in self?.viewStorages ?? []{
                self?.setViewAlignment(i.view, lastView)
                lastView = i.view
            }
        }
        $alignmentH.add {[weak self] _ in
            var lastView: UIView?
            for i in self?.viewStorages ?? []{
                self?.setViewAlignment(i.view, lastView)
                lastView = i.view
            }
        }
    }
    public convenience init(vertical alignment: AlignmentV, @UIViewBuilder _ views: ()->([UIView])){
        self.init()
        positingType = .vertical
        alignmentV = alignment
        addViews(views)
    }
    public convenience init(horizontal alignment: AlignmentH, @UIViewBuilder _ views: ()->([UIView])){
        self.init()
        positingType = .horizontal
        alignmentH = alignment
        addViews(views)
    }
    public convenience init(@UIViewBuilder _ views: ()->([UIView])){
        self.init()
        addViews(views)
    }
    
    public convenience init(vertical alignment: AlignmentV, _ views: UIView...){
        self.init()
        positingType = .vertical
        alignmentV = alignment
        addViews(views)
    }
    public convenience init(horizontal alignment: AlignmentH, _ views: UIView...){
        self.init()
        positingType = .horizontal
        alignmentH = alignment
        addViews(views)
    }
    public convenience init(_ views: UIView...){
        self.init()
        addViews(views)
    }
    
    public convenience init(vertical alignment: AlignmentV, _ views: [UIView] = []){
        self.init()
        positingType = .vertical
        alignmentV = alignment
        addViews(views)
    }
    public convenience init(horizontal alignment: AlignmentH, _ views: [UIView] = []){
        self.init()
        positingType = .horizontal
        alignmentH = alignment
        addViews(views)
    }
    public convenience init(_ views: [UIView]){
        self.init()
        addViews(views)
    }
    
    public convenience init(vertical alignment: AlignmentV, _ view: UIView){
        self.init()
        positingType = .vertical
        alignmentV = alignment
        addView(view)
    }
    public convenience init(horizontal alignment: AlignmentH, _ view: UIView){
        self.init()
        positingType = .horizontal
        alignmentH = alignment
        addViews(views)
    }
    public convenience init(_ view: UIView){
        self.init()
        addView(view)
    }
        
    public func addViews(@UIViewBuilder _ views: ()->([UIView])){ views().forEach{ self.addView($0) } }
    public func addViews(_ views: UIView...){ views.forEach{ self.addView($0) } }
    public func addViews(_ views: [UIView]){ views.forEach{ self.addView($0) } }
    public func addView(_ view: UIView){
        var viewStorage = ViewStorage(view: view)
        setViewPosition(view, viewStorages.last?.view)
        setViewAlignment(view, viewStorages.last?.view)
        addFrameObserver(&viewStorage)
        viewStorages.append(viewStorage)
        self.addSubview(view)
        setSelfSize()
        updateMaxValue()
    }
    
    public func removeView(_ view: UIView){
        guard let viewNumber = getViewNumber(view) else {return}
        removeView(viewNumber)
    }
    public func removeView(_ viewNumber: Int){
        viewStorages[viewNumber].resilt?.remove()
        viewStorages[viewNumber].view.removeFromSuperview()
        viewStorages.remove(at: viewNumber)
        
        updateViewPosition(viewNumber)
        updateMaxValue()
    }
    
    public func swapViews(_ viewF: UIView, _ viewS: UIView){
        guard let viewNumberF = getViewNumber(viewF) else {return}
        guard let viewNumberS = getViewNumber(viewS) else {return}
        swapViews(viewNumberF, viewNumberS)
    }
    
    public func swapViews(_ viewNumberF: Int, _ viewNumberS: Int){
        viewStorages.swapAt(viewNumberF, viewNumberS)
        
        updateViewPosition(viewNumberF)
        updateViewPosition(viewNumberF + 1)
        updateViewPosition(viewNumberS)
        updateViewPosition(viewNumberS + 1)
    }
    
    private func addFrameObserver(_ viewStorage: inout ViewStorage){
        viewStorage.resilt = viewStorage.view.rzFrame.add{ [weak self] value in
            if value.new.size == value.old.size {return}
            self?.updateMaxValue()
        }.use(.noAnimate)
    }
    
    private func setViewPosition(_ view: UIView, _ lastView: UIView?){
        positingType == .horizontal ? setViewHorizontalPosition(view, lastView) : setViewVerticalPosition(view, lastView)
    }
    private func setViewAlignment(_ view: UIView, _ lastView: UIView?){
        positingType == .horizontal ? setViewHorizontalAlignment(view, lastView) : setViewVerticalAlignment(view, lastView)
    }
    
    private func setViewHorizontalPosition(_ view: UIView, _ lastView: UIView?){
        if let lastView = lastView{
            view+>.x(lastView|*.mX + $space*)
        }else{
            view+>.x(0*)
        }
    }
    private func setViewHorizontalAlignment(_ view: UIView, _ lastView: UIView?){
        switch alignmentH {
            case .top:    view+>.y(0*)
            case .center: view+>.y(self|*.scY, .center)
            case .bottom: view+>.y(self|*.h, .down)
        }
    }
    
    private func setViewVerticalPosition(_ view: UIView, _ lastView: UIView?){
        if let lastView = lastView{
            view+>.y(lastView|*.mY + $space*)
        }else{
            view+>.y(0*)
        }
    }
    private func setViewVerticalAlignment(_ view: UIView, _ lastView: UIView?){
        switch alignmentV {
            case .left:   view+>.x(0*)
            case .center: view+>.x(self|*.scX, .center)
            case .right:  view+>.x(self|*.w, .right)
        }
    }
    
    private func setSelfSize(){
        if positingType == .horizontal{
            if let lastView = viewStorages.last?.view{
                self+>.width(lastView|*.mX).height($maxValueH*)
            }else{
                self+>.width(0*).height(0*)
            }
        }else{
            if let lastView = viewStorages.last?.view{
                self+>.width($maxValueW*).height(lastView|*.mY)
            }else{
                self+>.width(0*).height(0*)
            }
        }
    }
    
    private func updateMaxValue(){
        var maxValueW: CGFloat = 0
        var maxValueH: CGFloat = 0
        views.forEach { view in
            if view.frame.width > maxValueW {maxValueW = view.frame.width}
            if view.frame.height > maxValueH {maxValueH = view.frame.height}
        }
        self.maxValueW = maxValueW*
        self.maxValueH = maxValueH*
    }
    
    private func updateViewPosition(_ viewNumber: Int){
        if viewStorages.count > viewNumber{
            var lastView: UIView?
            if viewNumber > 0{ lastView = viewStorages[viewNumber - 1].view }
            setViewPosition(viewStorages[viewNumber].view, lastView)
        }else{
            setSelfSize()
        }
    }
    
    private func getViewNumber(_ view: UIView) -> Int?{
        for (i, viewStorage) in viewStorages.enumerated(){ if viewStorage.view == view {return i} }
        return nil
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView{
    public func removeFromRZStackView(){ (superview as? RZUIStackView)?.removeView(self) }
}

@resultBuilder public struct UIViewBuilder{
    public static func buildBlock(_ atrs: UIView...) -> [UIView] { return atrs }
}

extension RZBuilder where V: RZUIStackView{
    @discardableResult
    public func addViews(@UIViewBuilder _ views: ()->([UIView])) -> Self { view.addViews(views); return self }
    @discardableResult
    public func addViews(_ views: UIView...) -> Self { view.addViews(views); return self }
    @discardableResult
    public func addViews(_ views: [UIView]) -> Self { view.addViews(views); return self }
    @discardableResult
    public func addView(_ view: UIView) -> Self { self.view.addView(view); return self }
    
    @discardableResult
    public func alignmentV(_ value: RZUIStackView.AlignmentV) -> Self { view.alignmentV = value; return self }
    @discardableResult
    public func alignmentH(_ value: RZUIStackView.AlignmentH) -> Self { view.alignmentH = value; return self }
    
    @discardableResult
    public func positingType(_ value: RZUIStackView.PositingType) -> Self { view.positingType = value; return self }
    
    @discardableResult
    public func space(_ value: RZProtoValue) -> Self { view.space = value; return self }
    @discardableResult
    public func space(_ value: CGFloat) -> Self { view.space = value*; return self }
    
    @discardableResult
    public func removeView(_ value: UIView) -> Self { self.view.removeView(value); return self }
    @discardableResult
    public func removeView(_ value: Int) -> Self { self.view.removeView(value); return self }
    
    @discardableResult
    public func swapViews(_ valueF: UIView, _ valueS: UIView) -> Self { view.swapViews(valueF, valueS); return self }
    @discardableResult
    public func swapViews(_ valueF: Int, _ valueS: Int) -> Self { view.swapViews(valueF, valueS); return self }
}
