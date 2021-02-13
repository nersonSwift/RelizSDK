//
//  TransitionAnimation.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

public struct RZTransitionAnimation: Equatable{
    public static func == (lhs: RZTransitionAnimation, rhs: RZTransitionAnimation) -> Bool {
        lhs.name == rhs.name
    }
    
    public typealias TAnimation = (_ oldView: UIView?, _ newView: UIView?, _ placeView: UIView, _ end: @escaping ()->()) -> ()
    public var funcAnim: TAnimation
    public var name: String = ""
    
    
    public init(_ name: String, _ funcAnim: @escaping TAnimation){
        self.funcAnim = funcAnim
        self.name = name
    }
    
    public static var ezAnim: RZTransitionAnimation{
        RZTransitionAnimation("ezAnim") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let newView = newView{
                newView.transform.ty += rootSize.height
                UIView.animate(withDuration: 0.6,
                               delay: 0.0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 0,
                               options: [.curveEaseInOut],
                animations:{
                    newView.transform.ty = 0
                    oldView?.transform.ty -= rootSize.height * 0.3
                }){_ in
                    oldView?.transform.ty = 0
                    end()
                }
            }
        }
    }
    
    public static var ezAnimR: RZTransitionAnimation{
        RZTransitionAnimation("ezAnimR") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView{
                placeView.bringSubviewToFront(oldView)
                newView?.transform.ty -= rootSize.height * 0.3
                UIView.animate(withDuration: 0.5, animations: {
                    oldView.transform.ty += rootSize.height
                    newView?.transform.ty = 0
                }){_ in
                    oldView.transform.ty = 0
                    end()
                }
            }
        }
    }
    
    public static var ezAnimRSlou: RZTransitionAnimation{
        RZTransitionAnimation("ezAnimRSlou") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView{
                placeView.bringSubviewToFront(oldView)
                UIView.animate(withDuration: 0.5, animations: {
                    oldView.transform.ty += rootSize.height
                }){_ in
                    oldView.transform.ty = 0
                    end()
                }
            }
        }
    }
    
    public static var appearance: RZTransitionAnimation{
        RZTransitionAnimation("appearance") { oldView, newView, placeView, end in
            if let newView = newView{
                newView.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    newView.alpha = 1
                }){_ in end()}
            }
        }
    }
    
    public static var exhaustion: RZTransitionAnimation{
        RZTransitionAnimation("exhaustion") { oldView, newView, placeView, end in
            if let oldView = oldView{
                placeView.bringSubviewToFront(oldView)
                UIView.animate(withDuration: 0.2, animations: {
                    oldView.alpha = 0
                }){(ending) in
                    end()
                    oldView.alpha = 1
                }
            }
        }
    }
    
    public static var swipeRight: RZTransitionAnimation{
        RZTransitionAnimation("swipeRight") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView{
                newView?.transform.tx -= rootSize.width * 0.3
                placeView.bringSubviewToFront(oldView)
                UIView.animate(withDuration: 0.3, animations: {
                    oldView.transform.tx += rootSize.width
                    newView?.transform.tx = 0
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static var shiftLeft: RZTransitionAnimation{
        RZTransitionAnimation("shiftLeft") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView, let newView = newView{
                newView.transform.tx += rootSize.width
                UIView.animate(withDuration: 0.3, animations: {
                    newView.transform.tx = 0
                    oldView.transform.tx -= rootSize.width
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static var shiftRight: RZTransitionAnimation{
        RZTransitionAnimation("shiftRight") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView, let newView = newView{
                newView.transform.tx -= rootSize.width
                UIView.animate(withDuration: 0.3, animations: {
                    newView.transform.tx = 0
                    oldView.transform.tx += rootSize.width
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static var shiftLeftEz: RZTransitionAnimation{
        RZTransitionAnimation("shiftLeftEz") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView, let newView = newView{
                newView.transform.tx += rootSize.width
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    newView.transform.tx = 0
                    oldView.transform.tx -= rootSize.width
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static var shiftRightEz: RZTransitionAnimation{
        RZTransitionAnimation("shiftRightEz") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView, let newView = newView{
                newView.transform.tx -= rootSize.width
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    newView.transform.tx = 0
                    oldView.transform.tx += rootSize.width
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static func circle(_ point: CGPoint) -> RZTransitionAnimation{
        RZTransitionAnimation("circle") { oldView, newView, placeView, end in
            if let newView = newView{
                let foundationFrame = CGRect(x: point.x,
                                             y: point.y,
                                             width: 0,
                                             height: 0)
                let foundation = UIView(frame: foundationFrame)
                
                newView.frame.origin.x = -point.x
                newView.frame.origin.y = -point.y
                foundation.layer.masksToBounds = true
                placeView.addSubview(foundation)
                foundation.addSubview(newView)
                UIView.animate(withDuration: 2, animations: {
                    foundation.frame = CGRect(x: -(placeView.frame.height * 2 - placeView.frame.width) / 2,
                                              y: -placeView.frame.height / 2,
                                              width: placeView.frame.height * 2,
                                              height: placeView.frame.height * 2)
                    
                    newView.frame.origin.x = (placeView.frame.height * 2 - placeView.frame.width) / 2
                    newView.frame.origin.y = placeView.frame.height / 2
                    foundation.layer.cornerRadius = foundation.frame.height / 2
                }){(ending) in
                    placeView.addSubview(newView)
                    newView.frame.origin.x = 0
                    newView.frame.origin.y = 0
                    foundation.removeFromSuperview()
                    end()
                }
            }
        }
    }
    
    public static func circleP(rect: CGRect, color: UIColor, borderColor: UIColor? = nil) -> RZTransitionAnimation{
        RZTransitionAnimation("circleP") { oldView, newView, placeView, end in
            if let newView = newView{
                let foundation = UIView(frame: rect)
                foundation.alpha = 0
                foundation.layer.cornerRadius = foundation.frame.height / 2
                
                newView.transform.a = 0.001
                newView.transform.d = 0.001
                
                placeView.addSubview(foundation)
                
                placeView.bringSubviewToFront(newView)
                
                newView.frame.origin.x = rect.minX + rect.width / 2
                newView.frame.origin.y = rect.minY + rect.height / 2
                newView.alpha = 0
                
                foundation.backgroundColor = color
                
                if let borderColor = borderColor{
                    foundation.layer.borderWidth = 3
                    foundation.layer.borderColor = borderColor.cgColor
                }
                
                UIView.animate(withDuration: 0.5, animations: {
                    newView.transform.a = 1
                    newView.transform.d = 1
                    newView.frame.origin.x = 0
                    newView.frame.origin.y = 0
                })
                
                UIView.animate(withDuration: 0.6, animations: {
                    foundation.frame = CGRect(x: -(placeView.frame.height * 2 - placeView.frame.width) / 2,
                                              y: -placeView.frame.height / 2,
                                              width: placeView.frame.height * 2,
                                              height: placeView.frame.height * 2)
                    foundation.layer.cornerRadius = foundation.frame.height / 2
                    
                }, completion: {(ending) in
                    
                })
                
                
                UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
                    newView.alpha = 1
                }){(ending) in
                    placeView.addSubview(newView)
                    newView.frame.origin.x = 0
                    newView.frame.origin.y = 0
                    foundation.removeFromSuperview()
                    end()
                }
                
                UIView.animate(withDuration: 0.05, animations: {
                    foundation.alpha = 1
                })
            }
        }
    }
    
    public static func circlePR(rect: CGRect, color: UIColor) -> RZTransitionAnimation{
        RZTransitionAnimation("circlePR") { oldView, newView, placeView, end in
            if let oldView = oldView{
                let foundation = UIView(frame: CGRect())
                placeView.addSubview(foundation)
                foundation.backgroundColor = color
                placeView.bringSubviewToFront(oldView)
                
                foundation.frame = CGRect(x: -(placeView.frame.height * 2 - placeView.frame.width) / 2,
                                          y: -placeView.frame.height / 2,
                                          width: placeView.frame.height * 2,
                                          height: placeView.frame.height * 2)
                foundation.layer.cornerRadius = foundation.frame.height / 2
                
                
                UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
                    oldView.center.x = rect.minX + rect.width / 2
                    oldView.center.y = rect.minY + rect.height / 2
                    
                    oldView.transform.a = 0.001
                    oldView.transform.d = 0.001
                }, completion: {(ending) in
                    oldView.transform.a = 1
                    oldView.transform.d = 1
                    oldView.alpha = 1
                    
                    foundation.removeFromSuperview()
                    end()
                })
                
                UIView.animate(withDuration: 0.6, animations: {
                    foundation.frame = rect
                    foundation.layer.cornerRadius = foundation.frame.height / 2
                })
                
                UIView.animate(withDuration: 0.4, animations: {
                    oldView.alpha = 0
                })
                
                UIView.animate(withDuration: 0.05, delay: 0.55, animations: {
                    foundation.alpha = 0
                })
            }
        }
    }
    
    
    public static var shiftRightPopUp: RZTransitionAnimation{
        RZTransitionAnimation("shiftRightPopUp") { _, popUpView, backView, end in
            UIView.animate(withDuration: 0.7,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [], animations: {
               backView.alpha = 0
               popUpView?.transform.tx = backView.frame.width
            }){_ in
                backView.alpha = 1
                popUpView?.transform.tx = 0
                end()
            }
        }
    }
    
    public static var shiftLeftPopUp: RZTransitionAnimation{
        RZTransitionAnimation("shiftLeftPopUp") { _, popUpView, backView, end in
            backView.alpha = 0
            popUpView?.transform.tx = backView.frame.width
            UIView.animate(withDuration: 0.7,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [], animations: {
               backView.alpha = 1
               popUpView?.transform.tx = 0
                            
            }){_ in
                end()
            }
        }
    }
}
