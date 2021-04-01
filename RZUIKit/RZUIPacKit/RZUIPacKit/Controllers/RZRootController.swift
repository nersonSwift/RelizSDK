//
//  RootViewController.swift
//  NewArc
//
//  Created by Александр Сенин on 26.06.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

open class RZRootController: UIViewController {
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
        let place = UIView(frame: view.bounds)
        view.addSubview(place)
        if let uiPacC = UIPacInstaller.needOpen{
            RZTransition(.In, self).view(place).uiPacC(uiPacC).transit()
        }else{
            RZTransition(.In, self).view(place).line(RZLineController.rootLine).transit()
        }
        self.plase = place
    }
    
    func roatateCild(_ animate: Bool = true){
        let orientation = UIApplication.orientation
        if orientation == .unknown{ return }
        RZRotater.isRotate = true
        RZRotater.lastOrintation = orientation
        for child in children{
            if let child = child as? RZUIPacControllerNJProtocol{
                RZRotater.resizeAllChild(
                    parent: false,
                    child: child,
                    parentOrientation: orientation,
                    orientation,
                    animate: animate
                )
            }
        }
        RZRotater.oldOrintation = RZRotater.lastOrintation
        RZRotater.rotate()
        RZRotater.isRotate = false
    }
    
    open override func viewDidLoad() {
        DispatchQueue.main.async { self.registring() }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.isHorizontal != view.frame.size.isHorizontal || view.frame.size == size{
            DispatchQueue.main.async {
                if UIApplication.orientation != RZRotater.oldOrintation{
                    self.roatateCild()
                }
            }
        }else{
            self.plase?.frame.size = size
        }
    }
}
