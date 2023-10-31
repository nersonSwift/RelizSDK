//
//  RZUIViewWraper.swift
//  RelizApp
//
//  Created by Александр Сенин on 16.11.2020.
//

import SwiftUI
import RZObservableKit

public struct RZViewWrapper<V: UIView>: UIViewRepresentable{
    var view: V
    var update: (V) -> ()
    public init(_ initClosure: () -> V, _ update: @escaping (V) -> () = {_ in}){
        self.init(initClosure(), update)
    }
    public init(_ view: V, _ update: @escaping (V) -> ()){
        self.view = view
        self.update = update
        update(view)
    }
    public func makeUIView(context: Context) -> V { view }
    public func updateUIView(_ nsView: V, context: Context) { update(nsView) }
}
