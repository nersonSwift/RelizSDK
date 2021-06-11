//
//  ColorTests.swift
//  ExampleTests
//
//  Created by Александр Сенин on 11.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZVBColorTests{
    static func testUIColor(){
        let color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        
        //MARK: - UIView
        let view = UIView()
        //MARK: - Background Color
        view+>.color(color)
        XCTAssertEqual(view.backgroundColor, color, "Background Color")
        
        //MARK: - Border Color
        view+>.color(color, .border)
        XCTAssertEqual(view.layer.borderColor, color.cgColor, "Border Color")
        
        //MARK: - Shadow Color
        view+>.color(color, .shadow)
        XCTAssertEqual(view.layer.shadowColor, color.cgColor, "Shadow Color")
        
        //MARK: - Tint Color
        view+>.color(color, .tint)
        XCTAssertEqual(view.tintColor, color, "Tint Color")
        
        
        //MARK: - UILabel
        let label = UILabel()
        //MARK: - Content Color
        label+>.color(color, .content)
        XCTAssertEqual(label.textColor, color, "Content Color")
        
        
        //MARK: - UITextView
        let textView = UITextView()
        //MARK: - Content Color
        textView+>.color(color, .content)
        XCTAssertEqual(textView.textColor, color, "Content Color")
        
        
        //MARK: - UITextField
        let textField = UITextField()
        //MARK: - Content Color
        textField+>.color(color, .content)
        XCTAssertEqual(textField.textColor, color, "Content Color")
        
        
        //MARK: - UIButton
        let button = UIButton()
        //MARK: - Content Color
        button+>.color(color, .content)
        XCTAssertEqual(button.titleColor(for: .normal), color, "Content Color")
    }
    
    static func testRZOUIColor() {
        let rzoColor = RZObservable<UIColor>(wrappedValue: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        var color = rzoColor.wrappedValue
        
        
        //MARK: - UIView
        let view = UIView()
        //MARK: - Background Color
        view+>.color(rzoColor)
        XCTAssertEqual(view.backgroundColor, color, "Background Color")
        
        //MARK: - Border Color
        view+>.color(rzoColor, .border)
        XCTAssertEqual(view.layer.borderColor, color.cgColor, "Border Color")
        
        //MARK: - Shadow Color
        view+>.color(rzoColor, .shadow)
        XCTAssertEqual(view.layer.shadowColor, color.cgColor, "Shadow Color")
        
        //MARK: - Tint Color
        view+>.color(rzoColor, .tint)
        XCTAssertEqual(view.tintColor, color, "Tint Color")
        
        
        //MARK: - UILabel
        let label = UILabel()
        //MARK: - Content Color
        label+>.color(rzoColor, .content)
        XCTAssertEqual(label.textColor, color, "Content Color")
        
        
        //MARK: - UITextView
        let textView = UITextView()
        //MARK: - Content Color
        textView+>.color(rzoColor, .content)
        XCTAssertEqual(textView.textColor, color, "Content Color")
        
        
        //MARK: - UITextField
        let textField = UITextField()
        //MARK: - Content Color
        textField+>.color(rzoColor, .content)
        XCTAssertEqual(textField.textColor, color, "Content Color")
        
        
        //MARK: - UIButton
        let button = UIButton()
        //MARK: - Content Color
        button+>.color(rzoColor, .content)
        XCTAssertEqual(button.titleColor(for: .normal), color, "Content Color")
        
        
        rzoColor.wrappedValue = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        color = rzoColor.wrappedValue
        
        //MARK: - UIView
        //MARK: - Background Color
        XCTAssertEqual(view.backgroundColor, color, "Background Color")
        
        //MARK: - Border Color
        XCTAssertEqual(view.layer.borderColor, color.cgColor, "Border Color")
        
        //MARK: - Shadow Color
        XCTAssertEqual(view.layer.shadowColor, color.cgColor, "Shadow Color")
        
        //MARK: - Tint Color
        XCTAssertEqual(view.tintColor, color, "Tint Color")
        
        
        //MARK: - UILabel
        //MARK: - Content Color
        XCTAssertEqual(label.textColor, color, "Content Color")
        
        
        //MARK: - UITextView
        //MARK: - Content Color
        XCTAssertEqual(textView.textColor, color, "Content Color")
        
        
        //MARK: - UITextField
        //MARK: - Content Color
        XCTAssertEqual(textField.textColor, color, "Content Color")
        
        
        //MARK: - UIButton
        //MARK: - Content Color
        XCTAssertEqual(button.titleColor(for: .normal), color, "Content Color")
    }
}
