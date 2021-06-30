//
//  RZDarkModeKit.swift
//  RelizKit
//
//  Created by Александр Сенин on 16.10.2020.
//

import UIKit

extension UIColor{
    public func dark(_ color: UIColor) -> UIColor {
        let colorL = UIColor { sdf -> UIColor in
            if RZDarkModeKit.last != UIScreen.main.traitCollection.userInterfaceStyle {
                RZDarkModeKit.last = UIScreen.main.traitCollection.userInterfaceStyle
                RZDarkModeKit.updateColorise()
            }
            if sdf.isDarkMode{
                return color
            }else{
                return self
            }
        }
        return colorL
    }
    
    public static func |(light: UIColor, dark: UIColor) -> UIColor{
        return light.dark(dark)
    }
}

public extension UITraitCollection {
    var isDarkMode: Bool {
        if case .auto = RZDarkModeKit.mod{
            return self.userInterfaceStyle == .dark
        }
        if case .mod(let state) = RZDarkModeKit.mod{
            return state == .dark
        }
        return false
    }
}

public class RZDarkModeKit {
    static var last: UIUserInterfaceStyle?
    
    public enum ColorMod {
        public enum ModState{
            case dark
            case light
        }
        case auto
        case mod(_ modState: ModState? = nil)
    }
    
    public static var mod: ColorMod{
        set(mod){
            if case .auto = mod{
                autoMod = true
            }
            if case .mod(let state) = RZDarkModeKit.mod{
                autoMod = false
                if state == .dark{
                    darkMod = true
                }
                if state == .light{
                    darkMod = false
                }
            }
            RZDarkModeKit.updateColorise()
        }
        get{
            return autoMod ? .auto : .mod(darkMod ? .dark : .light)
        }
    }
    
    private static var autoModKey = "autoMod"
    private static var autoMod: Bool{
        set(autoMod){
            UserDefaults.standard.set(autoMod, forKey: autoModKey)
        }
        get{
            return UserDefaults.standard.bool(forKey: autoModKey)
        }
    }
    
    private static var darkModKey = "darkMod"
    private static var darkMod: Bool{
        set(darkMod){
            UserDefaults.standard.set(darkMod, forKey: darkModKey)
        }
        get{
            return UserDefaults.standard.bool(forKey: darkModKey)
        }
    }
    
    static var coloriseClosure: [()->(AnyObject?)] = []
    public static func updateColorise(){
        DispatchQueue.main.async {
            coloriseClosure = coloriseClosure.filter{$0() != nil}
        }
    }
    public static func colorise(_ closer: @escaping ()->(AnyObject?)){
        if closer() != nil{
            coloriseClosure.append(closer)
        }
    }
}

infix operator <-
public func <-<T: AnyObject>(object: T, closure: @escaping (T)->()){
    RZDarkModeKit.colorise { [weak object] in
        guard let object = object else {return nil}
        closure(object)
        return object
    }
}


