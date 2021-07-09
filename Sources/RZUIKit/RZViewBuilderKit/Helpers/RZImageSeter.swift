//
//  RZImageSeter.swift
//  RelizKit
//
//  Created by Александр Сенин on 21.10.2020.
//

import UIKit


public class RZImageSeter{
    private var image: UIImage?
    private var placeHolder: UIImage?
    
    private weak var imageView: UIImageView?
    
    public func setImage(_ image: UIImage){
        placeHolder = nil
        if let imageView = imageView{
            DispatchQueue.main.async {
                imageView.image = image
            }
        }else{
            self.image = image
        }
    }
    
    func setImageView(_ imageView: UIImageView){
        if let image = image{
            DispatchQueue.main.async {
                imageView.image = image
                self.image = nil
            }
        }else{
            DispatchQueue.main.async {
                imageView.image = self.placeHolder
                self.placeHolder = nil
            }
        }
    }
    
    init(_ placeHolder: UIImage) {
        self.placeHolder = placeHolder
    }
}
