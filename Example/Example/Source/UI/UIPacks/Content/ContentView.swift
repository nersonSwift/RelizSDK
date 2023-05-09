//
//  ContentView.swift
//  Example
//
//  Created by Александр Сенин on 10.06.2021.
//

import RelizKit

class ContentC: RZUIPacController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {.portrait}
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? { ContentV.self }
    var iPadViewType: RZUIPacAnyViewProtocol.Type? { ContentV.self }
    
    var router = ContentR.setup()
    
   
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
        self+>.color(.c6P)
    }
    
    private func createTextField(){
        textField.build{$0
            .width(86 % self*.w).height(10 % self*.w)
            .x(self|*.scX, .center).y(self|*.scY, .center)
            .cornerRadius(.selfTag(.h) / 4*).border(2)
            .color(.c1P, .border, .tint)
            .secured(true).capitalization(.none).keyboard(.emailAddress)
            .sideSpace(5 % self*.w).sideMode(.always)
            .sideSpace(5 % self*.w, .right).sideMode(.always, .right)
            .addToSuperview(self)
        }
    }
}
