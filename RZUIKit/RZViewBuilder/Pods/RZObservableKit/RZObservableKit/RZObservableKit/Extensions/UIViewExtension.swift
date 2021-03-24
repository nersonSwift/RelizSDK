//
//  UIViewExtension.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import UIKit

extension UIView{
    private var rzFrameKey: String {"frame"}
    public var rzFrame: RZObservable<CGRect>{
        if let rzFrameO = Associated(self).get(.hashable(rzFrameKey)) as? RZUIViewFrameObserve{
            return rzFrameO.$rzFrame
        }else{
            let rzFrameO = RZUIViewFrameObserve(self)
            Associated(self).set(rzFrameO, .hashable(rzFrameKey), .OBJC_ASSOCIATION_RETAIN)
            return rzFrameO.$rzFrame
        }
    }
    
    public static var isAnimation: Bool {
        let view = UIView()
        view.alpha = 0
        return view.layer.animationKeys() != nil
    }
}

class RZUIViewFrameObserve{
    private var keys: [NSKeyValueObservation?] = []
    @RZObservable var rzFrame: CGRect = .zero
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
    }
}
