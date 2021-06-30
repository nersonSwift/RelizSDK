//
//  DictionaryExtension.swift
//  RZViewBuilder
//
//  Created by Александр Сенин on 22.12.2020.
//

import Foundation


extension Dictionary{
    static func +(left: Dictionary, right: Dictionary) -> Dictionary {
        var dic = left
        for (key, value) in right{
            dic[key] = value
        }
        return dic
    }
}
