//
//  RZVBImageTests.swift
//  ExampleTests
//
//  Created by Valeriya Tarasenko on 18.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZVBImageTests: TestProtocol{
    
    static func test() {
        testUIButttonImage()
        testUIImageViewImage()
    }
    
    private static func testUIButttonImage(){
        let button = UIButton()
        
        //MARK: - UIImage
        let image = UIImage(systemName: "face.smiling") ?? UIImage()
        
        button+>.image(image)
        XCTAssertEqual(button.imageView?.image, image, "UIButton image")
        
        button+>.image(image, .background)
        XCTAssertEqual(button.currentBackgroundImage, image, "UIButton background image")
        
        //MARK: - RZObservable<UIImage>
        let imageOb = RZObservable<UIImage>(wrappedValue: image)
        button+>.image(imageOb)
        XCTAssertEqual(button.imageView?.image, imageOb.wrappedValue, "UIButton imageOb before")
        imageOb.wrappedValue = UIImage(systemName: "face.dashed.fill") ?? UIImage()
        XCTAssertEqual(button.imageView?.image, imageOb.wrappedValue, "UIButton imageOb after")
        
        button+>.image(imageOb, .background)
        XCTAssertEqual(button.currentBackgroundImage, imageOb.wrappedValue, "UIButton background imageOb before")
        imageOb.wrappedValue = UIImage(systemName: "face.dashed") ?? UIImage()
        XCTAssertEqual(button.currentBackgroundImage, imageOb.wrappedValue, "UIButton background imageOb after")
        
        //MARK: - RZObservable<UIImage?>
        let optionalOb = RZObservable<UIImage?>(wrappedValue: image)
        button+>.image(optionalOb)
        XCTAssertEqual(button.imageView?.image, optionalOb.wrappedValue, "UIButton optionalOb image before")
        optionalOb.wrappedValue = UIImage(systemName: "mustache")
        XCTAssertEqual(button.imageView?.image, optionalOb.wrappedValue, "UIButton optionalOb after")
        
        button+>.image(optionalOb, .background)
        XCTAssertEqual(button.currentBackgroundImage, optionalOb.wrappedValue, "UIButton optionalOb background imageOb before")
        optionalOb.wrappedValue = UIImage(systemName: "mustache.fill")
        XCTAssertEqual(button.currentBackgroundImage, optionalOb.wrappedValue, "UIButton optionalOb background imageOb after")
        
        //MARK: - labelView
        let view = UIView()
        button+>.labelView(view)
        XCTAssertEqual(button.labelView, view, "UIButton labelView after")
        
        let viewOb = RZObservable<UIView?>(wrappedValue: view)
        button+>.labelView(viewOb)
        XCTAssertEqual(button.labelView, viewOb.wrappedValue, "UIButton labelViewOb before")
        viewOb.wrappedValue = UIView(frame: CGRect(x: 1, y: 2, width: 20, height: 30))
        XCTAssertEqual(button.labelView, viewOb.wrappedValue, "UIButton labelViewOb after")
        
    }
    
    private static func testUIImageViewImage(){
        let imageView = UIImageView()
        
        //MARK: - UIImage
        let image = UIImage(systemName: "face.smiling") ?? UIImage()
        
        imageView+>.image(image)
        XCTAssertEqual(imageView.image, image, "UIImageView image")
        
        //MARK: - RZObservable<UIImage>
        let imageOb = RZObservable<UIImage>(wrappedValue: image)
        imageView+>.image(imageOb)
        XCTAssertEqual(imageView.image, imageOb.wrappedValue, "UIImageView imageOb before")
        imageOb.wrappedValue = UIImage(systemName: "face.dashed.fill") ?? UIImage()
        XCTAssertEqual(imageView.image, imageOb.wrappedValue, "UIImageView imageOb after")
 
        //MARK: - RZObservable<UIImage?>
        let optionalOb = RZObservable<UIImage?>(wrappedValue: image)
        imageView+>.image(optionalOb)
        XCTAssertEqual(imageView.image, optionalOb.wrappedValue, "UIImageView optionalOb image before")
        optionalOb.wrappedValue = UIImage(systemName: "mustache")
        XCTAssertEqual(imageView.image, optionalOb.wrappedValue, "UIImageView optionalOb after")
    }
}
