//
//  RZTextViewDelegate.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import UIKit

class RZTextViewDelegate: NSObject, UITextViewDelegate{
    weak var dopDelegate: UITextViewDelegate?
    weak var rzObservable: RZObservable<String>?
    weak var textView: UITextView?
    var key: NSKeyValueObservation?
    
    static func setDelegate(_ textView: UITextView, _ rzObservable: RZObservable<String>){
        let delegate = RZTextViewDelegate()
        
        delegate.textView = textView
        delegate.rzObservable = rzObservable
        Associated(textView).set(delegate, .hashable("RZTextViewDelegate"), .OBJC_ASSOCIATION_RETAIN)
        
        if let delegateL = delegate.textView?.delegate{
            if !(delegateL is RZTextViewDelegate){
                delegate.dopDelegate = delegateL
            }
        }
        textView.delegate = delegate
         
        delegate.key = delegate.textView?.observe(\.delegate, options: [.old, .new], changeHandler: {textView, value in
            if value.newValue is RZTextViewDelegate { return }
            if let rzTextViewDelegate = value.oldValue as? RZTextViewDelegate{
                rzTextViewDelegate.dopDelegate = value.newValue as? UITextViewDelegate
                textView.delegate = rzTextViewDelegate
            }
        })
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        dopDelegate?.textViewShouldBeginEditing?(textView) ?? true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        dopDelegate?.textViewShouldEndEditing?(textView) ?? true
    }

    func textViewDidBeginEditing(_ textView: UITextView){
        dopDelegate?.textViewDidBeginEditing?(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView){
        dopDelegate?.textViewDidEndEditing?(textView)
    }

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool{
        dopDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }

    func textViewDidChange(_ textView: UITextView){
        dopDelegate?.textViewDidChange?(textView)
        if rzObservable?.wrappedValue != textView.text{ rzObservable?.wrappedValue = textView.text }
    }

    func textViewDidChangeSelection(_ textView: UITextView){
        dopDelegate?.textViewDidChangeSelection?(textView)
    }

    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool{
        dopDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }

    func textView(
        _ textView: UITextView,
        shouldInteractWith textAttachment: NSTextAttachment,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool{
        dopDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
}
