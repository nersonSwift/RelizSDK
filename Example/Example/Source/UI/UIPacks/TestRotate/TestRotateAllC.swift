//
//  TestRotateAllC.swift
//  Example
//
//  Created by Александр Сенин on 26.01.2023.
//

import RelizKit

class TestRotateAllC: RZUIPacController{
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {.all}
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? {TestRotateAllV.self}
    var router = TestRotateAllR.setup()
    
    func start() {
        self.view+>.color(.c1L)
        self.view.addSubview(
            UIView()+>
                .color(.c9ED)
                .width(10 % self.view*.w).height(.selfTag(.w))
                .view
        )
//        _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
            let place = UIView()+>
                .width(70 % self.view*.w).height(70 % self.view*.h)
                .x(self.view|*.scX, .center).y(self.view|*.scY, .center)
                .view
            self.view.addSubview(place)
        RZTransition(.In, self).view(place).uiPacC(TestRotatePortC()).saveTranslite(false).animation(.ezAnim).transit()
//        })
    }
}
class TestRotateAllR: RZUIPacRouter{
    required init(){}
}
class TestRotateAllV: RZUIPacView{
    var router: TestRotateAllR!
}

class TestRotatePortC: RZUIPacController{
    var iPhoneViewType: RZUIPacAnyViewProtocol.Type? {TestRotatePortV.self}
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {.all}
    func start() {
        self.view+>.color(.c2L)
        self.view.addSubview(
            UIView()+>
                .color(.c9ED)
                .width(10 % self.view*.w).height(.selfTag(.w))
                .view
        )
        
//        _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
//            let place = UIView()+>
//                .width(70 % self.view*.w).height(70 % self.view*.h)
//                .x(self.view|*.scX, .center).y(self.view|*.scY, .center)
//                .view
//            self.view.addSubview(place)
//        RZTransition(.In, self).view(place).uiPacC(TestRotateLandC()).saveTranslite(false).animation(.ezAnim).transit()
//        })
        
    }
}

class TestRotatePortR: RZUIPacRouter{
    required init(){}
}
class TestRotatePortV: RZUIPacView{
    var router: TestRotatePortR!
}

class TestRotateLandC: RZUIPacController{
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {.all}
    func start() {
        self.view+>.color(.c3L)
        self.view.addSubview(
            UIView()+>
                .color(.c9ED)
                .width(10 % self.view*.w).height(.selfTag(.w))
                .view
        )
//        let place = UIView()+>
//            .width(70 % self.view*.w).height(70 % self.view*.h)
//            .x(self.view|*.scX, .center).y(self.view|*.scY, .center)
//            .view
//        self.view.addSubview(place)
//        RZTransition(.In, self).view(place).uiPacC(TestRotatePortC()).saveTranslite(false).transit()
    }
}

