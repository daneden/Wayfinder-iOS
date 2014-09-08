//
//  RoomCardSegue.swift
//  modalTransitions
//
//  Created by Daniel Eden on 8/25/14.
//  Copyright (c) 2014 Daniel Eden. All rights reserved.
//

import UIKit

class RoomCardSegue: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning  {
    
    var isPresenting: Bool!
    var duration = 0.4
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        if (isPresenting == true) {
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            toViewController.view.transform = CGAffineTransformMakeScale(0.2, 0.2)
            
            UIView.animateWithDuration(duration,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 4,
                options: nil,
                animations: {
                    
                    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
                    
                    fromViewController.view.alpha = 0.2
                    
                    toViewController.view.alpha = 1
                    toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9)
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
            }
            
        } else {
            
            UIView.animateWithDuration(duration/1.5,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    
                    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
                    toViewController.view.alpha = 1
                    fromViewController.view.frame.origin.y += toViewController.view.frame.height
                    
                }, completion: { (finished: Bool) -> Void in
                    fromViewController.removeFromParentViewController()
                    transitionContext.completeTransition(true)
            })
        }
        
        
    }
}
