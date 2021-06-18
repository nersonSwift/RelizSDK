//
//  RZVBUILabelTests.swift
//  ExampleTests
//
//  Created by Valeriya Tarasenko on 17.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZVBTextandFontTests: TestProtocol{
    
    static func test() {
        testText()
        testFont()
    }
    
    private static func testText(){
        
        //MARK: - UILabel
        let label = UILabel()
        
        //MARK: - String
        let value = "Test"
        label+>.text(value)
        XCTAssertEqual(label.text, value, "UILabel text")
        
        //MARK: - RZObservable<String>
        let valueOb = RZObservable<String>(wrappedValue: value)
        label+>.text(valueOb)
        XCTAssertEqual(label.text, valueOb.wrappedValue, "UILabel textOb before")
        valueOb.wrappedValue = "Hello, World!"
        XCTAssertEqual(label.text, valueOb.wrappedValue, "UILabel textOb after")
        
        //MARK: - RZObservable<String?>
        let optional: String? = "Optional"
        let optionalOb = RZObservable<String?>(wrappedValue: optional)
        label+>.text(optionalOb)
        XCTAssertEqual(label.text, optionalOb.wrappedValue, "UILabel optionalOb before")
        optionalOb.wrappedValue = nil
        XCTAssertEqual(label.text, optionalOb.wrappedValue, "UILabel optionalOb after")
        
        // MARK: - UITextField
        let textField = UITextField()
        
        //MARK: - String
        textField+>.text(value)
        XCTAssertEqual(textField.text, value, "UITextField text")
        
        //MARK: - RZObservable<String>
        textField+>.text(valueOb)
        XCTAssertEqual(textField.text, valueOb.wrappedValue, "UITextField textOb before")
        valueOb.wrappedValue = "Hello, World!"
        XCTAssertEqual(textField.text, valueOb.wrappedValue, "UITextField textOb after")
        
        // MARK: - UITextView
        let textView = UITextView()
        
        //MARK: - String
        textView+>.text(value)
        XCTAssertEqual(textView.text, value, "UITextView text")
        
        //MARK: - RZObservable<String>
        textView+>.text(valueOb)
        XCTAssertEqual(textView.text, valueOb.wrappedValue, "UITextView textOb before")
        valueOb.wrappedValue = "Hello, World!"
        XCTAssertEqual(textView.text, valueOb.wrappedValue, "UITextView textOb after")
        
        //MARK: - UIButton
        let button = UIButton()
        
        //MARK: - String
        button+>.text(value)
        XCTAssertEqual(button.titleLabel?.text, value, "UIButton text")
        
        //MARK: - RZObservable<String>
        button+>.text(valueOb)
        XCTAssertEqual(button.titleLabel?.text, valueOb.wrappedValue, "UIButton textOb before")
        valueOb.wrappedValue = "Press"
        XCTAssertEqual(button.titleLabel?.text, valueOb.wrappedValue, "UIButton textOb after")
        
        //MARK: - RZObservable<String?>
        optionalOb.wrappedValue = "Test"
        button+>.text(optionalOb)
        XCTAssertEqual(button.titleLabel?.text, optionalOb.wrappedValue, "UIButton optionalOb before")
        optionalOb.wrappedValue = "Test 2"
        XCTAssertEqual(button.titleLabel?.text, optionalOb.wrappedValue, "UIButton optionalOb after")
    }
    
    private static func testFont(){
        
        //MARK: - UILabel
        let label = UILabel()
        
        //MARK: - UIFont
        let font = UIFont(name: "Arial", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.backgroundColor : UIColor.green]
        label+>.font(font, attributes)
        XCTAssertEqual(label.font, font, "UILabel font")
        
        // MARK: - UITextField
        let textField = UITextField()
        
        //MARK: - UIFont
        textField+>.font(font, attributes)
        XCTAssertEqual(textField.font, font, "UITextField font")
        
        //MARK: - RZObservable<UIFont>
        textField+>.font(font)
        let fontOb = RZObservable<UIFont>(wrappedValue: font)
        textField+>.font(fontOb)
        XCTAssertEqual(textField.font, fontOb.wrappedValue, "UITextField fontOb before")
        fontOb.wrappedValue = UIFont(name: "Avenir", size: 12) ?? UIFont.systemFont(ofSize: 12)
        XCTAssertEqual(textField.font, fontOb.wrappedValue, "UITextField textOb after")
        
        //MARK: - UIButton
        let button = UIButton()
        
        //MARK: - UIFont
        button+>.font(font, attributes)
        XCTAssertEqual(button.titleLabel?.font, font, "UIButton font")
    }
}
