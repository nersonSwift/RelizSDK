//
//  Test.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 19.05.2022.
//

import Foundation

class RZUIQAction{
    var closure: (UIView) -> () = {_ in}
    weak var view: UIView?
    
    func use(){ closure(view ?? UIView()) }
    init(_ view: UIView, _ closure: @escaping (UIView) -> ()){
        self.view = view
        self.closure = closure
    }
}

struct RZUIQActionWrapper{
    weak var action: RZUIQAction?
    func use(){ action?.use() }
}

public class RZUIQueue{
    public enum Priority: Int{
        case low    = 0
        case medium = 1
        case high   = 2
    }
    
    public private(set) static var main = RZUIQueue()
    
    private var arr: [[RZUIQActionWrapper]] = [[],[],[]]
    private var dic = [[Int]: RZUIQAction]()
    
    public func add(priority: Priority, tag: RZObserveController.Tag, view: UIView, clusure: @escaping (UIView)->()){
        let action = RZUIQAction(view, clusure)
        dic[[tag.hashValue, view.hashValue]] = action
        arr[priority.rawValue].append(.init(action: action))
    }
    
    public func start(){
        use(Priority.high.rawValue)
    }
    
    private func use(_ priority: Int){
        if arr[priority].count == 0{
            for i in (0..<arr.count).reversed() {
                if arr[i].count != 0{ use(i); return }
            }
            end()
            return
        }
        arr[priority].removeFirst().use()
        use(priority)
    }
    
    private func end(){
        dic = [:]
    }
}
