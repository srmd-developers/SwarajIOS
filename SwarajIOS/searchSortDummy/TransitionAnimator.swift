//
//  TransitionManager.swift
//  JMFinanceApp
//
//  Created by Rupeeseed on 12/09/16.
//  Copyright © 2016 Rupeeseed. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    private var presenting = true
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    
    
    // animate a change from one viewcontroller to another
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        
        //let fromView = transitionContext.view(forKey: .from)!//transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        let toView : UIView!
        
        if (self.presenting){
            toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        }
        else {
            container.frame.origin.y = -container.frame.height
            toView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        }
        
        //let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // set up from 2D transforms that we'll use in the animation
        let offScreenRight = CGAffineTransform(translationX: 0, y: -container.frame.height)
        
        let offScreenLeft = CGAffineTransform(translationX: 0, y: container.frame.height)
        
        // prepare the toView for the animation
        if (self.presenting){
            toView.transform = offScreenRight
        }
        else {
            toView.transform = offScreenLeft
        }
        
        
        // add the both views to our view controller
        container.addSubview(toView)
       // container!.addSubview(fromView)
        
        // get the duration of the animation
        // DON'T just type '0.5s' -- the reason why won't make sense until the next post
        // but for now it's important to just follow this approach
        let duration = self.transitionDuration(using: transitionContext)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        
        
        UIView.animate(withDuration: duration, delay:0.0,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0,
                       animations: {
                        /*if (self.presenting){
                            fromView.transform = offScreenLeft
                        }
                        else {
                            fromView.transform = offScreenRight
                        }*/
                        toView.transform = .identity
        }, completion: { _ in
            
            transitionContext.completeTransition(true)
        })
        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // these methods are the perfect place to set our `presenting` flag to either true or false - voila!
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}
