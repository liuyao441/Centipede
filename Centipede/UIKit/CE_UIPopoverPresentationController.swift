//
//  CE_UIPopoverPresentationController.swift
//  Centipede
//
//  Created by kelei on 2015/6/4.
//  Copyright (c) 2015年 kelei. All rights reserved.
//

import UIKit

public extension UIPopoverPresentationController {
    
    private var ce: UIPopoverPresentationController_Delegate {
        struct Static {
            static var AssociationKey: UInt8 = 0
        }
        if let obj = objc_getAssociatedObject(self, &Static.AssociationKey) as? UIPopoverPresentationController_Delegate {
            return obj
        }
        if let delegate = self.delegate {
            if delegate is UIPopoverPresentationController_Delegate {
                return delegate as! UIPopoverPresentationController_Delegate
            }
        }
        let delegate = getDelegateInstance()
        objc_setAssociatedObject(self, &Static.AssociationKey, delegate, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        return delegate
    }
    
    private func rebindingDelegate() {
        let delegate = ce
        self.delegate = nil
        self.delegate = delegate
    }
    
    internal override func getDelegateInstance() -> UIPopoverPresentationController_Delegate {
        return UIPopoverPresentationController_Delegate()
    }
    
    public func ce_prepareForPopoverPresentation(handle: (popoverPresentationController: UIPopoverPresentationController) -> Void) -> Self {
        ce._prepareForPopoverPresentation = handle
        rebindingDelegate()
        return self
    }
    public func ce_shouldDismissPopover(handle: (popoverPresentationController: UIPopoverPresentationController) -> Bool) -> Self {
        ce._shouldDismissPopover = handle
        rebindingDelegate()
        return self
    }
    public func ce_didDismissPopover(handle: (popoverPresentationController: UIPopoverPresentationController) -> Void) -> Self {
        ce._didDismissPopover = handle
        rebindingDelegate()
        return self
    }
    public func ce_willRepositionPopoverToRect(handle: (popoverPresentationController: UIPopoverPresentationController, rect: UnsafeMutablePointer<CGRect>, view: AutoreleasingUnsafeMutablePointer<UIView?>) -> Void) -> Self {
        ce._willRepositionPopoverToRect = handle
        rebindingDelegate()
        return self
    }
    
}

internal class UIPopoverPresentationController_Delegate: UIPresentationController_Delegate, UIPopoverPresentationControllerDelegate {
    
    var _prepareForPopoverPresentation: ((UIPopoverPresentationController) -> Void)?
    var _shouldDismissPopover: ((UIPopoverPresentationController) -> Bool)?
    var _didDismissPopover: ((UIPopoverPresentationController) -> Void)?
    var _willRepositionPopoverToRect: ((UIPopoverPresentationController, UnsafeMutablePointer<CGRect>, AutoreleasingUnsafeMutablePointer<UIView?>) -> Void)?
    
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        
        let funcDic1: [Selector : Any?] = [
            "prepareForPopoverPresentation:" : _prepareForPopoverPresentation,
            "popoverPresentationControllerShouldDismissPopover:" : _shouldDismissPopover,
            "popoverPresentationControllerDidDismissPopover:" : _didDismissPopover,
            "popoverPresentationController:willRepositionPopoverToRect:inView:" : _willRepositionPopoverToRect,
        ]
        if let f = funcDic1[aSelector] {
            return f != nil
        }
        
        return super.respondsToSelector(aSelector)
    }
    
    
    @objc func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        _prepareForPopoverPresentation!(popoverPresentationController)
    }
    @objc func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return _shouldDismissPopover!(popoverPresentationController)
    }
    @objc func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        _didDismissPopover!(popoverPresentationController)
    }
    @objc func popoverPresentationController(popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverToRect rect: UnsafeMutablePointer<CGRect>, inView view: AutoreleasingUnsafeMutablePointer<UIView?>) {
        _willRepositionPopoverToRect!(popoverPresentationController, rect, view)
    }
}