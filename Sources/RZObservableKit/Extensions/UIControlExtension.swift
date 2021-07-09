//
//  UIControlExtension.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import UIKit

fileprivate final class ClosureSleeve: NSObject {
    let closure: ()->()

    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        Associated(self).set(sleeve, .random, .OBJC_ASSOCIATION_RETAIN)
    }
}
