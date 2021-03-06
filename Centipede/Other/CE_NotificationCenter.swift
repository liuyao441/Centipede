//
//  CE_NotificationCenter.swift
//  Centipede
//
//  Created by kelei on 15/4/19.
//  Copyright (c) 2015年 kelei. All rights reserved.
//

import Foundation

public extension NSObject {
    
    private struct Static { static var AssociationKey: UInt8 = 0 }
    private var _delegate: NSObject_Delegate? {
        get { return objc_getAssociatedObject(self, &Static.AssociationKey) as? NSObject_Delegate }
        set { objc_setAssociatedObject(self, &Static.AssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    private var ce: NSObject_Delegate {
        if let obj = _delegate {
            return obj
        }
        let obj = NSObject_Delegate()
        _delegate = obj
        return obj
    }
    
    public func ce_addObserverForName(name: String, handle: (notification: NSNotification) -> Void) -> Self {
        ce.addNotificationForName(name, handle: handle)
        NSNotificationCenter.defaultCenter().addObserver(ce, selector: #selector(NSObject_Delegate.observerHandlerAction(_:)), name: name, object: nil)
        return self
    }
    
    public func ce_removeObserverForName(name: String) -> Self {
        NSNotificationCenter.defaultCenter().removeObserver(ce, name: name, object: nil)
        return self
    }
    
    public func ce_removeObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(ce)
    }
    
}

private class NSObject_Delegate: NSObject {
    
    typealias NotificationAction = (NSNotification) -> Void
    private var dic = [String : NotificationAction]()
    
    func addNotificationForName(name: String, handle: (notification: NSNotification) -> Void) {
        dic[name] = handle
    }
    
    @objc func observerHandlerAction(notification: NSNotification) {
        if let action = dic[notification.name] {
            action(notification)
        }
    }

}
