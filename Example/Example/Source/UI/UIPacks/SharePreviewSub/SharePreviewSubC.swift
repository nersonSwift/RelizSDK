//  
//  SharePreviewSubC.swift
//  Example
//
//  Created by Александр Сенин on 25.05.2023.
//

import RelizKit

class SharePreviewSubC: RZUIPacController{
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? { SharePreviewSubIPhoneV.self }
    var router = SharePreviewSubR.setup()

    func start() {
        print(superShared[.sharePreviewChain.router]?.previewText ?? "")
    }
}




