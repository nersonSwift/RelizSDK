//
//  Rotater.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

extension UIInterfaceOrientation{
    func getStateNumber() -> Int {
        switch self {
            case .portrait: return 0
            case .landscapeLeft: return 1
            case .portraitUpsideDown: return 2
            case .landscapeRight: return 3
        default: return -1
        }
    }
    
    func getStateNumberNew() -> Int {
        switch self {
            case .portrait: return 0
            case .landscapeRight: return 1
            case .portraitUpsideDown: return 2
            case .landscapeLeft: return 3
        default: return -1
        }
    }
    
    static func getRotationAt(state: Int) -> UIInterfaceOrientation {
        var state = state % 4
        if state < 0 { state += 4 }
        switch state {
            case 0: return .portrait
            case 1: return .landscapeRight
            case 2: return .portraitUpsideDown
            case 3: return .landscapeLeft
        default: return .unknown
        }
    }
    
    var isHorizontal: Bool{
        switch self {
            case .portrait: return false
            case .landscapeRight: return true
            case .portraitUpsideDown: return false
            case .landscapeLeft: return true
        default: return false
        }
    }
}

extension UIInterfaceOrientationMask{
    var orientations: [UIInterfaceOrientation]{
        switch self {
        case .all:
            return [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]
        case .landscape:
            return [.landscapeLeft, .landscapeRight]
        case .portrait:
            return [.portrait, .portraitUpsideDown]
        case .landscapeLeft:
            return [.landscapeLeft]
        case .landscapeRight:
            return [.landscapeRight]
        case .portraitUpsideDown:
            return [.portraitUpsideDown]
        default:
            return []
        }
    }
}


public class RZRotater: UIView{
    weak var mateController: RZUIPacControllerNGProtocol?
    weak var mate: UIView?
    var mateOrientation: UIInterfaceOrientation?
    var mateGoodOrientation: [UIInterfaceOrientation] = []
    static var lastOrintation: UIInterfaceOrientation = UIApplication.orientation
    static var oldOrintation: UIInterfaceOrientation = UIApplication.orientation
    static var isRotate: Bool = false
    
    static func resizeAllChild(
        isInstall: Bool = false,
        child: RZUIPacControllerNGProtocol,
        parentOrientation: UIInterfaceOrientation,
        parentRotatin: RotateMode,
        transitionDuration: CGFloat? = nil
    ){
        let parentRotatin = child.rotater?.rotateMate(
            isInstall: isInstall,
            parentRotatin: parentRotatin,
            parentOrientation: parentOrientation,
            transitionDuration: transitionDuration
        ) ?? .non
        
        for childL in child.children{
            if let childL = childL as? RZUIPacControllerNGProtocol{
                resizeAllChild(
                    isInstall: isInstall,
                    child: childL,
                    parentOrientation: child.rotater?.mateOrientation ?? .portrait,
                    parentRotatin: parentRotatin,
                    transitionDuration: transitionDuration
                )
                
            }
        }
    }
    
    func rotateMate(
        isInstall: Bool,
        parentRotatin: RotateMode,
        parentOrientation: UIInterfaceOrientation,
        transitionDuration: CGFloat?
    ) -> RotateMode{
        let (newOrintation, oldOrintation) = getOrientation(RZRotater.lastOrintation, parentOrientation)
        let rootRotation = RotateMode.getRotete(from: RZRotater.oldOrintation, to: RZRotater.lastOrintation)
        let interfaceRotation = RotateMode.getRotete(from: oldOrintation, to: newOrintation, priority: rootRotation.type)
        let rotation = interfaceRotation - parentRotatin
        let needResize = oldOrintation.isHorizontal != newOrintation.isHorizontal
        
        let animation = {self.animationBody(rotation.pi, needResize, isInstall)}
        
        if let transitionDuration {
            UIView.animate(withDuration: transitionDuration, animations: animation)
        }else {
            animation()
        }
        
        mateController?.isHorizontal = newOrintation.isHorizontal
        if !isInstall, let mateController = mateController{
            Self.rotatingUIPacC.append(mateController)
        }
        mateOrientation = newOrintation
        
        return interfaceRotation
    }
    
   
    //MARK: - Orientation
    private func getOrientation(
        _ deviceOrientation: UIInterfaceOrientation,
        _ parentOrientation: UIInterfaceOrientation
    ) -> (UIInterfaceOrientation, UIInterfaceOrientation) {
        var newOrintation = deviceOrientation
        if !isGoodOrientation(deviceOrientation){
            newOrintation = mateOrientation ?? mateGoodOrientation[0]
        }
        let oldOrintation = mateOrientation ?? parentOrientation
        return (newOrintation, oldOrintation)
    }
    
    //MARK: - Animation Body
    private func animationBody(_ piMode: CGFloat, _ needResize: Bool, _ isInstall: Bool){
        setTransform(piMode)
        
        if needResize{
            let old = mate?.frame.size ?? .zero
            frame.size.swap()
            if old == mate?.frame.size{
                mate?.frame.size.swap()
            }
        }
        setOriginsZero()
        setPlaceSize()
    }
    
    private func setTransform(_ piMode: CGFloat){
        transform = transform.rotated(by: piMode / 2)
        transform = transform.rotated(by: piMode / 2)
    }
    
    private func setOriginsZero(){
        frame.origin = .zero
    }
    
    private func setPlaceSize(){
        superview?.frame.size = frame.size
    }
    
    private func isGoodOrientation(_ deviceOrientation: UIInterfaceOrientation) -> Bool{
        mateGoodOrientation.contains(deviceOrientation)
    }
    
   
    
    private static var rotatingUIPacC: [RZUIPacControllerNGProtocol] = []
    static func rotate(){
        for uiPacC in rotatingUIPacC{
            uiPacC.rotate()
        }
        rotatingUIPacC = []
    }
    
    public init(viewController: UIViewController) {
        let view: UIView = viewController.view
        super.init(frame: view.frame)
        let superV = view.superview
        superV?.addSubview(self)
        
        superV?.rzFrame.add{[weak self, weak view, weak viewController] in
            guard let self = self, let view = view else {return}
            if RZRotater.isRotate {return}
            
            if self.frame.size != $0.new.size{
                self.frame.size = $0.new.size
            }
            if view.frame.size != $0.new.size{
                view.frame.size = $0.new.size
            }
            (viewController as? RZUIPacControllerNGProtocol)?.resize()
        }
    
        view.frame.origin = .zero
        addSubview(view)
        mate = view
        if let viewController = viewController as? RZUIPacControllerNGProtocol{
            mateController = viewController
        }
        mateGoodOrientation = viewController.supportedInterfaceOrientations.orientations
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct RotateMode{
    enum RotateType{
        case left
        case right
        case non
        
        func createMode(value: Int) -> RotateMode{
            switch self{
                case .left: return .left(value)
                case .right: return .right(value)
                case .non: return .non
            }
        }
    }
    var value: Int = 0
    var pi: CGFloat { (.pi / 2) * CGFloat(value) }
    var type: RotateType {
        switch value{
            case ..<0:  return .left
            case 0:     return .non
            case 1...:  return .right
            default: return .non
        }
    }
    
    init(){}
    init(value: Int){self.value = value}
    static func left(_ value: Int) -> Self{ .init(value: -value) }
    static func right(_ value: Int) -> Self{ .init(value: value) }
    static var non: Self { .init(value: 0) }
    
    static func -=(left: inout Self, right: Self){
        left.value -= right.value
    }
    
    static func -(left: Self, right: Self) -> Self{
        .init(value: left.value - right.value)
    }
    
    static func +=(left: inout Self, right: Self){
        left.value += right.value
    }
    
    static func +(left: Self, right: Self) -> Self{
        .init(value: left.value + right.value)
    }
    
    func getOrientation(old rotation: UIInterfaceOrientation) -> UIInterfaceOrientation{
        UIInterfaceOrientation.getRotationAt(state: rotation.getStateNumberNew() - value)
    }
    
    static func getRotete(from: UIInterfaceOrientation, to: UIInterfaceOrientation, priority: RotateType = .right) -> Self{
        var new = to.getStateNumberNew() - from.getStateNumberNew()
        if new == 3{
            new = -1
        }else if new == -3{
            new = 1
        }else if new == -2, priority == .right{
            new = 2
        }else if new == 2, priority == .left{
            new = -2
        }
        return .init(value: new)
    }
}




