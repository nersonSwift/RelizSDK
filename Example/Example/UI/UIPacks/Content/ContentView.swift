//
//  ContentView.swift
//  Example
//
//  Created by Александр Сенин on 10.06.2021.
//

import RelizKit

class ContentC: RZUIPacController {
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? { ContentV.self }
    var router = ContentR()
}

class ContentR: RZUIPacRouter { }

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
                .color(.c1P, .border).color(.c1P, .tint).color(.a1_6P_8M, .content)
                .secured(true).capitalization(.none).keyboard(.emailAddress)
                .subview(.left, nil, .always, 30)
                .view
        )
    }
}
