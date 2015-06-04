//
//  CE_UITabBar.swift
//  Centipede
//
//  Created by kelei on 2015/6/4.
//  Copyright (c) 2015年 kelei. All rights reserved.
//

import UIKit

public extension UITabBar {
    
    private var ce: UITabBar_Delegate {
        struct Static {
            static var AssociationKey: UInt8 = 0
        }
        if let obj = objc_getAssociatedObject(self, &Static.AssociationKey) as? UITabBar_Delegate {
            return obj
        }
        if let delegate = self.delegate {
            if delegate is UITabBar_Delegate {
                return delegate as! UITabBar_Delegate
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
    
    internal func getDelegateInstance() -> UITabBar_Delegate {
        return UITabBar_Delegate()
    }
    
    public func ce_didSelectItem(handle: (tabBar: UITabBar, item: UITabBarItem!) -> Void) -> Self {
        ce._didSelectItem = handle
        rebindingDelegate()
        return self
    }
    public func ce_willBeginCustomizingItems(handle: (tabBar: UITabBar, items: [AnyObject]) -> Void) -> Self {
        ce._willBeginCustomizingItems = handle
        rebindingDelegate()
        return self
    }
    public func ce_didBeginCustomizingItems(handle: (tabBar: UITabBar, items: [AnyObject]) -> Void) -> Self {
        ce._didBeginCustomizingItems = handle
        rebindingDelegate()
        return self
    }
    public func ce_willEndCustomizingItems(handle: (tabBar: UITabBar, items: [AnyObject], changed: Bool) -> Void) -> Self {
        ce._willEndCustomizingItems = handle
        rebindingDelegate()
        return self
    }
    public func ce_didEndCustomizingItems(handle: (tabBar: UITabBar, items: [AnyObject], changed: Bool) -> Void) -> Self {
        ce._didEndCustomizingItems = handle
        rebindingDelegate()
        return self
    }
    
}

internal class UITabBar_Delegate: NSObject, UITabBarDelegate {
    
    var _didSelectItem: ((UITabBar, UITabBarItem!) -> Void)?
    var _willBeginCustomizingItems: ((UITabBar, [AnyObject]) -> Void)?
    var _didBeginCustomizingItems: ((UITabBar, [AnyObject]) -> Void)?
    var _willEndCustomizingItems: ((UITabBar, [AnyObject], Bool) -> Void)?
    var _didEndCustomizingItems: ((UITabBar, [AnyObject], Bool) -> Void)?
    
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        
        let funcDic1: [Selector : Any?] = [
            "tabBar:didSelectItem:" : _didSelectItem,
            "tabBar:willBeginCustomizingItems:" : _willBeginCustomizingItems,
            "tabBar:didBeginCustomizingItems:" : _didBeginCustomizingItems,
            "tabBar:willEndCustomizingItems:changed:" : _willEndCustomizingItems,
            "tabBar:didEndCustomizingItems:changed:" : _didEndCustomizingItems,
        ]
        if let f = funcDic1[aSelector] {
            return f != nil
        }
        
        return super.respondsToSelector(aSelector)
    }
    
    
    @objc func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        _didSelectItem!(tabBar, item)
    }
    @objc func tabBar(tabBar: UITabBar, willBeginCustomizingItems items: [AnyObject]) {
        _willBeginCustomizingItems!(tabBar, items)
    }
    @objc func tabBar(tabBar: UITabBar, didBeginCustomizingItems items: [AnyObject]) {
        _didBeginCustomizingItems!(tabBar, items)
    }
    @objc func tabBar(tabBar: UITabBar, willEndCustomizingItems items: [AnyObject], changed: Bool) {
        _willEndCustomizingItems!(tabBar, items, changed)
    }
    @objc func tabBar(tabBar: UITabBar, didEndCustomizingItems items: [AnyObject], changed: Bool) {
        _didEndCustomizingItems!(tabBar, items, changed)
    }
}