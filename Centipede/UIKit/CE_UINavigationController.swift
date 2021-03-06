//
//  CE_UINavigationController.swift
//  Centipede
//
//  Created by kelei on 2015/6/4.
//  Copyright (c) 2015年 kelei. All rights reserved.
//

import UIKit

public extension UINavigationController {
    
    private struct Static { static var AssociationKey: UInt8 = 0 }
    private var _delegate: UINavigationController_Delegate? {
        get { return objc_getAssociatedObject(self, &Static.AssociationKey) as? UINavigationController_Delegate }
        set { objc_setAssociatedObject(self, &Static.AssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    private var ce: UINavigationController_Delegate {
        if let obj = _delegate {
            return obj
        }
        if let obj = self.delegate {
            if obj is UINavigationController_Delegate {
                return obj as! UINavigationController_Delegate
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
    
    internal override func getDelegateInstance() -> UINavigationController_Delegate {
        return UINavigationController_Delegate()
    }
    
    public func ce_willShowViewController(handle: (navigationController: UINavigationController, viewController: UIViewController, animated: Bool) -> Void) -> Self {
        ce._willShowViewController = handle
        rebindingDelegate()
        return self
    }
    public func ce_didShowViewController(handle: (navigationController: UINavigationController, viewController: UIViewController, animated: Bool) -> Void) -> Self {
        ce._didShowViewController = handle
        rebindingDelegate()
        return self
    }
    public func ce_supportedInterfaceOrientations(handle: (navigationController: UINavigationController) -> UIInterfaceOrientationMask) -> Self {
        ce._supportedInterfaceOrientations = handle
        rebindingDelegate()
        return self
    }
    public func ce_preferredInterfaceOrientationForPresentation(handle: (navigationController: UINavigationController) -> UIInterfaceOrientation) -> Self {
        ce._preferredInterfaceOrientationForPresentation = handle
        rebindingDelegate()
        return self
    }
    public func ce_interactionControllerForAnimationController(handle: (navigationController: UINavigationController, animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?) -> Self {
        ce._interactionControllerForAnimationController = handle
        rebindingDelegate()
        return self
    }
    public func ce_animationControllerForOperation(handle: (navigationController: UINavigationController, operation: UINavigationControllerOperation, fromVC: UIViewController, toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?) -> Self {
        ce._animationControllerForOperation = handle
        rebindingDelegate()
        return self
    }
    
}

internal class UINavigationController_Delegate: UIViewController_Delegate, UINavigationControllerDelegate {
    
    var _willShowViewController: ((UINavigationController, UIViewController, Bool) -> Void)?
    var _didShowViewController: ((UINavigationController, UIViewController, Bool) -> Void)?
    var _supportedInterfaceOrientations: ((UINavigationController) -> UIInterfaceOrientationMask)?
    var _preferredInterfaceOrientationForPresentation: ((UINavigationController) -> UIInterfaceOrientation)?
    var _interactionControllerForAnimationController: ((UINavigationController, UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?)?
    var _animationControllerForOperation: ((UINavigationController, UINavigationControllerOperation, UIViewController, UIViewController) -> UIViewControllerAnimatedTransitioning?)?
    
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        
        let funcDic1: [Selector : Any?] = [
            #selector(navigationController(_:willShowViewController:animated:)) : _willShowViewController,
            #selector(navigationController(_:didShowViewController:animated:)) : _didShowViewController,
            #selector(navigationControllerSupportedInterfaceOrientations(_:)) : _supportedInterfaceOrientations,
            #selector(navigationControllerPreferredInterfaceOrientationForPresentation(_:)) : _preferredInterfaceOrientationForPresentation,
            #selector(navigationController(_:interactionControllerForAnimationController:)) : _interactionControllerForAnimationController,
            #selector(navigationController(_:animationControllerForOperation:fromViewController:toViewController:)) : _animationControllerForOperation,
        ]
        if let f = funcDic1[aSelector] {
            return f != nil
        }
        
        return super.respondsToSelector(aSelector)
    }
    
    
    @objc func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        _willShowViewController!(navigationController, viewController, animated)
    }
    @objc func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        _didShowViewController!(navigationController, viewController, animated)
    }
    @objc func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return _supportedInterfaceOrientations!(navigationController)
    }
    @objc func navigationControllerPreferredInterfaceOrientationForPresentation(navigationController: UINavigationController) -> UIInterfaceOrientation {
        return _preferredInterfaceOrientationForPresentation!(navigationController)
    }
    @objc func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return _interactionControllerForAnimationController!(navigationController, animationController)
    }
    @objc func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return _animationControllerForOperation!(navigationController, operation, fromVC, toVC)
    }
}
