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
            case .landscapeRight: return 3
            case .portraitUpsideDown: return 2
            case .landscapeLeft: return 1
        default: return -1
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


public class RZRotater: UIView{
    weak var mateController: RZUIPacControllerNGProtocol?
    weak var mate: UIView?
    var mateOrientation: UIInterfaceOrientation?
    var mateGoodOrientation: [UIInterfaceOrientation] = []
    static var lastOrintation: UIInterfaceOrientation = .portrait
    static var oldOrintation: UIInterfaceOrientation = .portrait
    static var isRotate: Bool = false
    
    func rotateMate(
        parent: Bool = true,
        parentOrientation: UIInterfaceOrientation,
        deviceOrientation: UIInterfaceOrientation,
        coordinator: UIViewControllerTransitionCoordinator?
    ){
        let deviceO = deviceOrientation != .unknown ? deviceOrientation : Self.lastOrintation
        let (newO, oldO) = getOrientation(deviceO)
        
        let rangeG = getRangeG(parentOrientation, newO)
        let rangeL = getRangeL(oldO, newO)
        let rangeR = getRangeR(deviceO)
        
        let (piMode, time) = getAnimationValues(rangeR, rangeG)
        
        if isNeedAnimation(piMode) || (rangeL % 2 != 0 && newO == deviceO) {
            let animation = {self.animationBody(self.frame, piMode, newO, parentOrientation, deviceO, rangeL, rangeG)}
            
            if let coordinator {
                print("Huh", "aa")
                coordinator.animate {
                    print("Huh", $0.transitionDuration)
                    
                    animation()
                    
                }
            }else {
                animation()
            }
        }
        
        mateController?.isHorizontal = newO.isHorizontal
        if let mateController = mateController{
            Self.rotatingUIPacC.append(mateController)
        }
        mateOrientation = newO
        
    }
    
    //MARK: - Ranges
    private func getRangeG(_ parentOrientation: UIInterfaceOrientation, _ newOrientation: UIInterfaceOrientation) -> Int{
        var range = parentOrientation.getStateNumber() - newOrientation.getStateNumber()
        if range == 3{
            range -= 4
        }else if range == -3{
            range += 4
        }
        return range
    }
    private func getRangeL(_ oldOrintation: UIInterfaceOrientation, _ newOrientation: UIInterfaceOrientation) -> Int{
        oldOrintation.getStateNumber() - newOrientation.getStateNumber()
    }
    private func getRangeR(_ deviceOrientation: UIInterfaceOrientation) -> Int{
        RZRotater.oldOrintation.getStateNumber() - deviceOrientation.getStateNumber()
    }
    
    //MARK: - Orientation
    private func getOrientation(_ deviceOrientation: UIInterfaceOrientation) -> (UIInterfaceOrientation, UIInterfaceOrientation) {
        var newOrintation = deviceOrientation
        if !isGoodOrientation(deviceOrientation){
            newOrintation = mateOrientation ?? mateGoodOrientation[0]
        }
        let oldOrintation = mateOrientation ?? deviceOrientation
        return (newOrintation, oldOrintation)
    }
    
    //MARK: - Animation Values
    private func getAnimationValues(_ rangeR: Int, _ rangeG: Int) -> (CGFloat, TimeInterval){
        var piMode = (CGFloat.pi / 2) * CGFloat(rangeG)
        var time: TimeInterval = 0.3
        
        if rangeR % 2 == 0, rangeR != 0, piMode != 0{
            if rangeR > 0{
                piMode = -(CGFloat.pi * 2 - piMode)
            }
            time = 0.6
        }
        return (piMode, time)
    }
    
    private func isNeedAnimation(_ piMode: CGFloat) -> Bool{
        let t = UIView().transform.rotated(by: piMode)
        return !compare(keys: \.a, \.b, \.c, \.d, v1: t, v2: transform)
    }
    
    //MARK: - Animation Body
    private func animationBody(
        _ frame: CGRect,
        _ piMode: CGFloat,
        _ newO: UIInterfaceOrientation,
        _ parentO: UIInterfaceOrientation,
        _ deviceO: UIInterfaceOrientation,
        _ rangeL: Int,
        _ rangeG: Int
    ){
        setTransform(piMode)
        setSelfFrame(frame, newO, parentO, deviceO, rangeL)
        setMateSize(rangeG)
        setOriginsZero()
        setPlaceSize()
    }
    
    private func setTransform(_ piMode: CGFloat){
        transform = UIView().transform.rotated(by: piMode / 2)
        transform = transform.rotated(by: piMode / 2)
    }
    
    private func setSelfFrame(
        _ frame: CGRect,
        _ newO: UIInterfaceOrientation,
        _ parentO: UIInterfaceOrientation,
        _ deviceO: UIInterfaceOrientation,
        _ rangeL: Int
    ){
        if rangeL % 2 != 0, newO == deviceO{
            self.frame.size = CGSize(width: self.frame.height, height: self.frame.width)
        }
        
        if (rangeL != 0 && newO != deviceO) || (newO != parentO && newO == deviceO){
            self.frame = frame
        }
    }
    
    private func setMateSize(_ rangeG: Int){
        if rangeG % 2 == 0{
            self.mate?.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        }else{
            self.mate?.frame.size = CGSize(width: self.frame.height, height: self.frame.width)
        }
    }
    
    private func setOriginsZero(){
        self.frame.origin = .zero
        mate?.frame.origin = .zero
    }
    
    private func setPlaceSize(){
        superview?.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    private func compare(keys: KeyPath<CGAffineTransform, CGFloat>..., v1: CGAffineTransform, v2: CGAffineTransform) -> Bool{
        var flag = true
        for i in keys{
            if v1[keyPath: i] != v2[keyPath: i] {flag = false; break}
        }
        return flag
    }
    
    private func isGoodOrientation(_ deviceOrientation: UIInterfaceOrientation) -> Bool{
        for orientation in mateGoodOrientation{
            if deviceOrientation == orientation{
                return true
            }
        }
        return false
    }
    
    static func resizeAllChild(parent: Bool = true,
                               child: RZUIPacControllerNGProtocol,
                               parentOrientation: UIInterfaceOrientation,
                               _ deviceOrientation: UIInterfaceOrientation,
                               coordinator: UIViewControllerTransitionCoordinator?){
        child.rotater?.rotateMate(parent: parent,
                                  parentOrientation: parentOrientation,
                                  deviceOrientation: deviceOrientation,
                                  coordinator: coordinator)
        
        for childL in child.children{
            if let childL = childL as? RZUIPacControllerNGProtocol{
                resizeAllChild(child: childL,
                               parentOrientation: child.rotater?.mateOrientation ?? .portrait,
                               deviceOrientation,
                               coordinator: coordinator)
                
            }
        }
    }
    
    private static var rotatingUIPacC: [RZUIPacControllerNGProtocol] = []
    static func rotate(){
        for uiPacC in rotatingUIPacC{
            uiPacC.rotate()
        }
        rotatingUIPacC = []
    }
    private var key: NSKeyValueObservation?
    
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
    
        view.frame.origin = CGPoint()
        self.addSubview(view)
        mate = view
        if let viewController = viewController as? RZUIPacControllerNGProtocol{
            mateController = viewController
        }
        setGoodOrintation(supportedInterfaceOrientations: viewController.supportedInterfaceOrientations)
    }
    
    func setGoodOrintation(supportedInterfaceOrientations: UIInterfaceOrientationMask){
        switch supportedInterfaceOrientations {
        case .all:
            mateGoodOrientation = [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]
        case .landscape:
            mateGoodOrientation = [.landscapeLeft, .landscapeRight]
        case .portrait:
            mateGoodOrientation = [.portrait]
        case .landscapeLeft:
            mateGoodOrientation = [.landscapeLeft]
        case .landscapeRight:
            mateGoodOrientation = [.landscapeRight]
        case .portraitUpsideDown:
            mateGoodOrientation = [.portraitUpsideDown]
        default: break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



