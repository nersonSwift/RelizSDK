//  
//  SharePreviewSubIPhoneV.swift
//  Example
//
//  Created by Александр Сенин on 25.05.2023.
//

import RelizKit

class SharePreviewSubIPhoneV: RZUIPacView{
    var router: SharePreviewSubR!
    
    func initActions() {}
    func create() {}
}

#if DEBUG
import SwiftUI

@available(iOS 15.0, *)
struct SharePreviewSubIPhone_Previews: PreviewProvider {
    static var previews: some View {
        RZViewWrapper {
            let v = SharePreviewSubIPhoneV()
            v.frame = UIScreen.main.bounds
            v.router = SharePreviewSubR()
            v.initActions()
            v.create()
            return v
        }
        .previewDevice("iPhone 12")
        .ignoresSafeArea(.all)
    }
}
#endif