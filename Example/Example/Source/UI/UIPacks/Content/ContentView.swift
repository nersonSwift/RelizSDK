//
//  ContentView.swift
//  Example
//
//  Created by Александр Сенин on 10.06.2021.
//

import RelizKit

class ContentC: RZUIPacController {
    typealias Dependency = ContentR
    
    var router = ContentR.setup()
    
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? { ContentV.self }
}

class ContentR: RZUIPacRouter { required init(){} }

class ContentV: RZUIPacView {
    var router: ContentR!
    var textField = UITextField()
    
    func create() {
        createSelf()
        
        createTextField()
    }
    
    private func createSelf() {
        self+>.color(.systemBackground)
    }
    
    private func createTextField(){
        addSubview(
            textField+>
                .width(86 % self*.w).height(10 % self*.w)
                .x(self*.cX, .center).y(self*.cY, .center)
                .cornerRadius(.selfTag(.h) / 4*).border(2)
                .color(.c1P, .border, .tint)
                .secured(true).capitalization(.none).keyboard(.emailAddress)
                .sideSpace(5 % self*.w).sideMode(.always)
                .sideSpace(5 % self*.w, .right).sideMode(.always, .right)
                .view
        )
    }
}
