//  
//  SharePreviewC.swift
//  Example
//
//  Created by Александр Сенин on 25.05.2023.
//

import RelizKit

extension RZUIPacSharedKeyChain<SharePreviewC>{
    var router: RZUIPacSharedKey<Self, SharePreviewR> { .init(key: "router") }
}

extension RZUIPacSharedKey{
    static var sharePreviewChain: RZUIPacSharedKeyChain<SharePreviewC> { .init() }
}


class SharePreviewC: RZUIPacController, RZUIPacShareProtocol{
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? { SharePreviewIPhoneV.self }
    var router = SharePreviewR.setup()
    
    var shared: RZUIPacSharedStorage {
        .init(key: .sharePreviewChain.router, value: router)
    }
}



