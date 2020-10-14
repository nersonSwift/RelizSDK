//
//  RootViewController.swift
//  NewArc
//
//  Created by Александр Сенин on 26.06.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

public class RZRootController: UIViewController {
    var lines: [RZLine] = []
    var select: String = "Main"

    
    public static func setupRootViewController(_ installableScreenProtocol: RZScreenControllerProtocol) -> RZRootController{
        return setupRootViewController(["Main": installableScreenProtocol], "Main")
    }
    
    public static func setupRootViewController(_ screenLines: [RZLine], _ select: RZScreenLines) -> RZRootController{
        setupRootViewController(screenLines, select.id)
    }

    public static func setupRootViewController(_ screenLines: [RZLine], _ select: String) -> RZRootController{
        let rVC = RZRootController()
        rVC.lines = screenLines
        rVC.select = select
        return rVC
    }
    
    public static func setupRootViewController(_ screenLines: [String: RZScreenControllerProtocol], _ select: String) -> RZRootController{
        var lines: [RZLine] = []
        screenLines.forEach(){
            lines.append(RZLine(id: $0.key, controller: $0.value))
        }
        return setupRootViewController(lines, select)
    }
    
    public static func setupRootViewController(_ screenLines: [RZScreenLines: RZScreenControllerProtocol], _ select: RZScreenLines) -> RZRootController{
        var lines: [RZLine] = []
        screenLines.forEach(){
            lines.append(RZLine(id: $0.key, controller: $0.value))
        }
        return setupRootViewController(lines, select)
    }
    
    private func registring(){
        if lines.count == 0 {return}
        ScreensInstaller.rootViewController = self
        RZLineController.addLines(lines)
        lines = []
        let plase = UIView(frame: view.bounds)
        view.addSubview(plase)
        RZTransition(.In, self).view(plase).line(select).transit()
    }
    
    func roatateCild(){
        var orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait
        if orientation != .unknown{
            RZRotater.lastOrintation = orientation
        }else{
            orientation = RZRotater.lastOrintation
        }
        for child in children{
            if let child = child as? RZScreenControllerProtocol{
                RZRotater.resizeAllChild(parent: false,
                                       child: child,
                                       parentOrientation: orientation,
                                       orientation)
            }
        }
        
        RZRotater.oldOrintation = RZRotater.lastOrintation
        RZRotater.rotate()
    }
    
    public override func viewDidLoad() {
        registring()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        roatateCild()
    }
}
