//
//  RZUIViewWraper.swift
//  RelizApp
//
//  Created by Александр Сенин on 16.11.2020.
//

import SwiftUI
import RZObservableKit

public class RZSUIViewWraper: UIView{
    public convenience init <V: View>(@ViewBuilder _ view: @escaping ()->V){
        self.init(RZUIViewWraperObservable()) {_, _ in view()}
    }
    public convenience init <V: View, ObObj: ObservableObject>(_ observable: ObObj, @ViewBuilder _ view: @escaping (ObObj)->V){
        self.init(observable) {_, obObj in view(obObj)}
    }
    
    public init<V: View, ObObj: ObservableObject>(_ observable: ObObj, @ViewBuilder _ view: @escaping (Self, ObObj)->V){
        super.init(frame: .zero)
        guard let self = self as? Self else { return }
        observable.setRZObservables()
        let controller = UIHostingController(rootView: RZObserveView<V, Self, ObObj>(view, uiView: self).environmentObject(observable))
        let view = controller.view ?? UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        rzFrame.add{[weak view] in
            view?.frame.size.width = $0.new.width
            view?.frame.size.height = $0.new.height
        }.use(.noAnimate)
        addSubview(view)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class RZUIViewWraperObservable: ObservableObject{
    @Published var updater: Bool = false
}

struct RZObserveView<V: View, UIV: UIView, ObObj: ObservableObject>: View {
    @EnvironmentObject var enviroment: ObObj
    var view: (ObObj)->V?
    init(_ view: @escaping (UIV, ObObj)->V, uiView: UIV){
        self.view = {[weak uiView] obObj in
            guard let uiView = uiView else { return nil }
            return view(uiView, obObj)
        }
    }
    var body: some View {
        view(enviroment)
    }
}


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
    public func makeUIView(context: Context) -> V {
        return view
    }
    public func updateUIView(_ nsView: V, context: Context) {
        update(nsView)
    }
}
