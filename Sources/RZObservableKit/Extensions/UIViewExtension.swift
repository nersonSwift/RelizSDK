//
//  UIViewExtension.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import UIKit

class RZUIViewFrameObserve{
    private var keys: [NSKeyValueObservation?] = []
    @RZObservable var rzFrame: CGRect = .zero
    
    @RZObservable var rzX: CGFloat = .zero
    @RZObservable var rzY: CGFloat = .zero
    @RZObservable var rzWidth: CGFloat = .zero
    @RZObservable var rzHeight: CGFloat = .zero
    
    private weak var view: UIView?
    
    init(_ view: UIView) {
        self.view = view
        rzFrame = view.frame
        setObserve(view)
    }
    
    private func setObserve(_ view: UIView){
        keys.append(view.observe(\.frame, options: [.old, .new]) {[weak self] (view, value) in
            if value.oldValue == value.newValue {return}
            self?.rzFrame = view.frame
        })
        keys.append(view.observe(\.center, options: [.old, .new]) {[weak self] (view, value) in
            if value.oldValue == value.newValue {return}
            self?.rzFrame = view.frame
        })
        keys.append(view.observe(\.bounds, options: [.old, .new]) {[weak self] (view, value) in
            if value.oldValue == value.newValue {return}
            self?.rzFrame = view.frame
        })
        $rzFrame.add {[weak self] value in
            if value.new.minX != self?.rzX        {self?.rzX = value.new.minX}
            if value.new.minY != self?.rzY        {self?.rzY = value.new.minY}
            if value.new.width != self?.rzWidth   {self?.rzWidth = value.new.width}
            if value.new.height != self?.rzHeight {self?.rzHeight = value.new.height}
        }.use(.noAnimate)
    }
}


extension UIView{
    private var rzFrameKey: String {"frame"}
    private var rzFrameObserve: RZUIViewFrameObserve{
        if let rzFrameO = Associated(self).get(.hashable(rzFrameKey)) as? RZUIViewFrameObserve{
            return rzFrameO
        }else{
            let rzFrameO = RZUIViewFrameObserve(self)
            Associated(self).set(rzFrameO, .hashable(rzFrameKey), .OBJC_ASSOCIATION_RETAIN)
            return rzFrameO
        }
    }
    
    public var rzFrame: RZObservable<CGRect>{ return rzFrameObserve.$rzFrame }
    public var rzX: RZObservable<CGFloat>{ return rzFrameObserve.$rzX }
    public var rzY: RZObservable<CGFloat>{ return rzFrameObserve.$rzY }
    public var rzWidth: RZObservable<CGFloat>{ return rzFrameObserve.$rzWidth }
    public var rzHeight: RZObservable<CGFloat>{ return rzFrameObserve.$rzHeight }
    
    public static var isAnimation: Bool {
        if !Thread.isMainThread {return false}
        let view = UIView()
        view.alpha = 0
        return view.layer.animationKeys() != nil
    }
}

class UIViewHoveringContainer{
    @RZObservable var rzIsHovering: Bool = false
    
    init(_ view: UIView) {
        let hoverGesture = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        view.addGestureRecognizer(hoverGesture)
    }
    
    @objc private func handleHover(_ gesture: UIHoverGestureRecognizer) {
        switch gesture.state {
            case .began: rzIsHovering = true
            case .ended: rzIsHovering = false
        default: break
        }
    }
}

extension UIView{
    private var hoveringContainerKey: String {"HoveringContainer"}
    private var hoveringContainer: UIViewHoveringContainer{
        if let container = Associated(self).get(.hashable(hoveringContainerKey)) as? UIViewHoveringContainer{
            return container
        }else{
            let container = UIViewHoveringContainer(self)
            Associated(self).set(container, .hashable(hoveringContainerKey), .OBJC_ASSOCIATION_RETAIN)
            return container
        }
    }
    
    public var rzIsHovering: RZObservable<Bool> {
        hoveringContainer.$rzIsHovering
    }
}



class RZUIScrollViewContentOffSetObserve{
    private var key: NSKeyValueObservation?
    @RZObservable var rzContentOffSet: CGPoint = .zero
    private weak var view: UIScrollView?
    
    init(_ view: UIScrollView) {
        self.view = view
        rzContentOffSet = view.contentOffset
        key = view.observe(\.contentOffset) {[weak self] (scroll, _) in
            if self?.rzContentOffSet != scroll.contentOffset{
                self?.rzContentOffSet = scroll.contentOffset
            }
        }
    }
}


extension UIScrollView{
    private var rzContentOffSetKey: String {"contentOffSet"}
    
    public var rzContentOffset: RZObservable<CGPoint>{
        if let scrollViewContentOffSetObserve = Associated(self).get(.hashable(rzContentOffSetKey)) as? RZUIScrollViewContentOffSetObserve{
            return scrollViewContentOffSetObserve.$rzContentOffSet
        }else{
            let scrollViewContentOffSetObserve = RZUIScrollViewContentOffSetObserve(self)
            Associated(self).set(scrollViewContentOffSetObserve, .hashable(rzContentOffSetKey), .OBJC_ASSOCIATION_RETAIN)
            return scrollViewContentOffSetObserve.$rzContentOffSet
        }
    }
}
