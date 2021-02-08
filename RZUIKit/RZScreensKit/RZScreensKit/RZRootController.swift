//
//  RootViewController.swift
//  NewArc
//
//  Created by Александр Сенин on 26.06.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

public class RZRootController: UIViewController {
    //var lines: [RZLine] = []
    
    var plase: UIView?
    weak var scene: UIScene?
    
    private static var instancesClosures: [()->(RZRootController?)] = []
    public static var instances: [RZRootController] {
        var instances = [RZRootController]()
        instancesClosures.forEach{
            if let rootController = $0(){
                instances.append(rootController)
            }
        }
        
        return instances
    }
    private static func addInstances(_ rootController: RZRootController){
        instancesClosures.append {[weak rootController] in rootController}
    }
    
    public static func setupRootViewController(scene: UIScene?) -> UIWindow?{
        if let windowScene = scene as? UIWindowScene {
            
            let window = UIWindow(windowScene: windowScene)
            let rVC = RZRootController()
            rVC.scene = scene
            window.rootViewController = rVC
            window.makeKeyAndVisible()
            NotificationCenter().addObserver(self, selector: #selector(close), name: UIApplication.willTerminateNotification, object: nil)
            return window
        }
        return nil
    }
    
    @objc public func close(){
        
        guard let scene = scene else { return }
        UIApplication.shared.requestSceneSessionDestruction(scene.session, options: nil, errorHandler: nil)
    }
    
    private func registring(){
        Self.addInstances(self)
        let plase = UIView(frame: view.bounds)
        view.addSubview(plase)
        if let uiPacC = UIPacInstaller.needOpen{
            RZTransition(.In, self).view(plase).uiPacC(uiPacC).transit()
        }else{
            RZTransition(.In, self).view(plase).line(RZLineController.rootLine).transit()
        }
        self.plase = plase
        
        
    }
    
    func roatateCild(){
        var orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait
        if orientation != .unknown{
            RZRotater.lastOrintation = orientation
        }else{
            orientation = RZRotater.lastOrintation
        }
        for child in children{
            if let child = child as? RZUIPacControllerNJProtocol{
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
        DispatchQueue.main.async {
            self.registring()
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if plase?.frame.width == size.height, plase?.frame.height == size.width{
            DispatchQueue.main.async {
                self.roatateCild()
            }
        }else{
            self.plase?.frame.size = size
        }

    }
    
    
}
