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
    weak var mateController: RZScreenControllerProtocol?
    weak var mate: UIView?
    var mateOrientation: UIInterfaceOrientation?
    var mateGoodOrientation: [UIInterfaceOrientation] = [] //UIInterfaceOrientationMask?
    static var lastOrintation: UIInterfaceOrientation = .portrait
    static var oldOrintation: UIInterfaceOrientation = .portrait
    
    func rotateMate(parent: Bool = true, parentOrientation: UIInterfaceOrientation, deviceOrientation: UIInterfaceOrientation){
        
        var deviceOrientation = deviceOrientation
        if deviceOrientation == .unknown{
            deviceOrientation = Self.lastOrintation
        }
        
        var newOrintation = deviceOrientation
        let oldOrintation = mateOrientation ?? deviceOrientation
         
        
        if !isGoodOrientation(deviceOrientation){
            
            newOrintation = mateOrientation ?? mateGoodOrientation[0]
        }
       
        
        var range = parentOrientation.getStateNumber() - newOrintation.getStateNumber()
        
        if range == 3{
            range -= 4
        }else if range == -3{
            range += 4
        }
        
        
        let rangeL = oldOrintation.getStateNumber() - newOrintation.getStateNumber()
        
        
        var piMode = (CGFloat.pi / 2) * CGFloat(range)
        
        var time: TimeInterval = 0.3
        
        let testo = RZRotater.oldOrintation.getStateNumber() - deviceOrientation.getStateNumber()
        
        if testo % 2 == 0, testo != 0, piMode != 0{
            if testo > 0{
                piMode = -(CGFloat.pi * 2 - piMode)
            }
            time = 0.6
        }
        
        let frame = self.frame
        
        //print(newOrintation.getStateNumber())
        UIView.animate(withDuration: time) {
            
            self.transform = UIView().transform.rotated(by: piMode / 2)
            self.transform = self.transform.rotated(by: piMode / 2)
            
            if rangeL % 2 != 0, newOrintation == deviceOrientation{
                let width = self.frame.width
                let height = self.frame.height
                
                self.frame.size.height = width
                self.frame.size.width = height
                
                //self.mate?.frame.size.width = self.frame.width
                //self.mate?.frame.size.height = self.frame.height
            }
            
            
            
            if (rangeL != 0 && newOrintation != deviceOrientation) ||
               (newOrintation != parentOrientation && newOrintation == deviceOrientation){
                self.frame = frame
            }
            
            
            if range % 2 == 0{
                self.mate?.frame.size.width = self.frame.width
                self.mate?.frame.size.height = self.frame.height
            }else{
                self.mate?.frame.size.width = self.frame.height
                self.mate?.frame.size.height = self.frame.width
            }
            
            
            self.frame.origin = CGPoint()
            self.mate?.frame.origin = CGPoint()
            
            
            self.superview?.frame.size.width = self.frame.width
            self.superview?.frame.size.height = self.frame.height
            if piMode != 0 || !parent{
                
                
            }
            
        }
        
        mateController?.isHorizontal = newOrintation.isHorizontal
        if let mateController = mateController{
            Self.rotatingSceens.append(mateController)
        }
        mateOrientation = newOrintation
        
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
                               child: RZScreenControllerProtocol,
                               parentOrientation: UIInterfaceOrientation,
                               _ deviceOrientation: UIInterfaceOrientation){
        
        child.rotater?.rotateMate(parent: parent,
                                  parentOrientation: parentOrientation,
                                  deviceOrientation: deviceOrientation)
        
        for childL in child.children{
            if let childL = childL as? RZScreenControllerProtocol{
                resizeAllChild(child: childL,
                               parentOrientation: child.rotater?.mateOrientation ?? .portrait,
                               deviceOrientation)
                
            }
        }
    }
    
    private static var rotatingSceens: [RZScreenControllerProtocol] = []
    static func rotate(){
        for screen in rotatingSceens{
            screen.rotate()
        }
        rotatingSceens = []
    }
    private var key: NSKeyValueObservation?
    
    public init(viewController: UIViewController) {
        let view: UIView = viewController.view
        super.init(frame: view.frame)
        let superV = view.superview
        superV?.addSubview(self)
        
        key = superV?.layer.observe(\.bounds, changeHandler: { [weak superV, weak self, weak view, weak viewController](_, _) in
            guard let superV = superV, let self = self, let view = view else {return}
            
            if self.frame.size == view.frame.size{
                self.frame.size = superV.frame.size
            }else{
                self.frame.size = CGSize(width: superV.frame.height, height: superV.frame.width)
            }
            view.frame.size = superV.frame.size
            (viewController as? RZScreenController)?.resize()
        })
        
        view.frame.origin = CGPoint()
        self.addSubview(view)
        mate = view
        if let viewController = viewController as? RZScreenControllerProtocol{
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
    
    func testOrintation(){
        var orintation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait
        if let test = mateController?.parent as? RZScreenControllerProtocol{
            rotateMate(parentOrientation: test.rotater?.mateOrientation ?? .portrait, deviceOrientation: orintation)
        }else{
            if orintation.getStateNumber() == -1{
                orintation = RZRotater.lastOrintation
            }
            rotateMate(parent: false, parentOrientation: orintation, deviceOrientation: orintation)
        }
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

