//
//  CE_UITextView.swift
//  Centipede
//
//  Created by kelei on 2015/6/4.
//  Copyright (c) 2015年 kelei. All rights reserved.
//

import UIKit

public extension UITextView {
    
    private struct Static { static var AssociationKey: UInt8 = 0 }
    private var _delegate: UITextView_Delegate? {
        get { return objc_getAssociatedObject(self, &Static.AssociationKey) as? UITextView_Delegate }
        set { objc_setAssociatedObject(self, &Static.AssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    private var ce: UITextView_Delegate {
        if let obj = _delegate {
            return obj
        }
        if let obj = self.delegate {
            if obj is UITextView_Delegate {
                return obj as! UITextView_Delegate
            }
        }
        let obj = getDelegateInstance()
        _delegate = obj
        return obj
    }
    
    private func rebindingDelegate() {
        let delegate = ce
        self.delegate = nil
        self.delegate = delegate
    }
    
    internal override func getDelegateInstance() -> UITextView_Delegate {
        return UITextView_Delegate()
    }
    
    public func ce_shouldBeginEditing(handle: (textView: UITextView) -> Bool) -> Self {
        ce._shouldBeginEditing = handle
        rebindingDelegate()
        return self
    }
    public func ce_shouldEndEditing(handle: (textView: UITextView) -> Bool) -> Self {
        ce._shouldEndEditing = handle
        rebindingDelegate()
        return self
    }
    public func ce_didBeginEditing(handle: (textView: UITextView) -> Void) -> Self {
        ce._didBeginEditing = handle
        rebindingDelegate()
        return self
    }
    public func ce_didEndEditing(handle: (textView: UITextView) -> Void) -> Self {
        ce._didEndEditing = handle
        rebindingDelegate()
        return self
    }
    public func ce_shouldChangeTextInRange(handle: (textView: UITextView, range: NSRange, text: String) -> Bool) -> Self {
        ce._shouldChangeTextInRange = handle
        rebindingDelegate()
        return self
    }
    public func ce_didChange(handle: (textView: UITextView) -> Void) -> Self {
        ce._didChange = handle
        rebindingDelegate()
        return self
    }
    public func ce_didChangeSelection(handle: (textView: UITextView) -> Void) -> Self {
        ce._didChangeSelection = handle
        rebindingDelegate()
        return self
    }
    public func ce_shouldInteractWithURL(handle: (textView: UITextView, URL: NSURL, characterRange: NSRange) -> Bool) -> Self {
        ce._shouldInteractWithURL = handle
        rebindingDelegate()
        return self
    }
    public func ce_shouldInteractWithTextAttachment(handle: (textView: UITextView, textAttachment: NSTextAttachment, characterRange: NSRange) -> Bool) -> Self {
        ce._shouldInteractWithTextAttachment = handle
        rebindingDelegate()
        return self
    }
    
}

internal class UITextView_Delegate: UIScrollView_Delegate, UITextViewDelegate {
    
    var _shouldBeginEditing: ((UITextView) -> Bool)?
    var _shouldEndEditing: ((UITextView) -> Bool)?
    var _didBeginEditing: ((UITextView) -> Void)?
    var _didEndEditing: ((UITextView) -> Void)?
    var _shouldChangeTextInRange: ((UITextView, NSRange, String) -> Bool)?
    var _didChange: ((UITextView) -> Void)?
    var _didChangeSelection: ((UITextView) -> Void)?
    var _shouldInteractWithURL: ((UITextView, NSURL, NSRange) -> Bool)?
    var _shouldInteractWithTextAttachment: ((UITextView, NSTextAttachment, NSRange) -> Bool)?
    
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        
        let funcDic1: [Selector : Any?] = [
            #selector(textViewShouldBeginEditing(_:)) : _shouldBeginEditing,
            #selector(textViewShouldEndEditing(_:)) : _shouldEndEditing,
            #selector(textViewDidBeginEditing(_:)) : _didBeginEditing,
            #selector(textViewDidEndEditing(_:)) : _didEndEditing,
            #selector(textView(_:shouldChangeTextInRange:replacementText:)) : _shouldChangeTextInRange,
            #selector(textViewDidChange(_:)) : _didChange,
            #selector(textViewDidChangeSelection(_:)) : _didChangeSelection,
        ]
        if let f = funcDic1[aSelector] {
            return f != nil
        }
        
        let funcDic2: [Selector : Any?] = [
            #selector(textView(_:shouldInteractWithURL:inRange:)) : _shouldInteractWithURL,
            #selector(textView(_:shouldInteractWithTextAttachment:inRange:)) : _shouldInteractWithTextAttachment,
        ]
        if let f = funcDic2[aSelector] {
            return f != nil
        }
        
        return super.respondsToSelector(aSelector)
    }
    
    
    @objc func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return _shouldBeginEditing!(textView)
    }
    @objc func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return _shouldEndEditing!(textView)
    }
    @objc func textViewDidBeginEditing(textView: UITextView) {
        _didBeginEditing!(textView)
    }
    @objc func textViewDidEndEditing(textView: UITextView) {
        _didEndEditing!(textView)
    }
    @objc func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return _shouldChangeTextInRange!(textView, range, text)
    }
    @objc func textViewDidChange(textView: UITextView) {
        _didChange!(textView)
    }
    @objc func textViewDidChangeSelection(textView: UITextView) {
        _didChangeSelection!(textView)
    }
    @objc func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return _shouldInteractWithURL!(textView, URL, characterRange)
    }
    @objc func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return _shouldInteractWithTextAttachment!(textView, textAttachment, characterRange)
    }
}
