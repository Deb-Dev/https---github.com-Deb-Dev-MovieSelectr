//
//  MovieTransitioning.swift
//  MovieSelectr
//
//  Created by NXP Tims on 12/01/17.
//  Copyright © 2017 deb. All rights reserved.
//

import UIKit

class MovieAnimatedTransitioning: NSObject,UIViewControllerAnimatedTransitioning {
    var isPresentation = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = fromVC!.view

        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC!.view
        
        let containerView = transitionContext.containerView
        
        if isPresentation{
            containerView.addSubview(toView!)
            
        }
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC?.view
        
        let apperedFrame = transitionContext.finalFrame(for: animatingVC!)
        var dismissedFrame = apperedFrame
        
        dismissedFrame.origin.y += dismissedFrame.size.height
        
        let initialFrame = isPresentation ? dismissedFrame : apperedFrame
        let finalFrame = isPresentation ? apperedFrame : dismissedFrame
        
        animatingView?.frame = initialFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 300, initialSpringVelocity: 5, options: [.allowUserInteraction , .beginFromCurrentState], animations: {
            animatingView?.frame = finalFrame
            
            if !self.isPresentation{
                animatingView?.alpha = 0
            }
            
        }){(isSuccess : Bool) in
            if !self.isPresentation {
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(true)

        }

    }
}

class MovieTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = MoviePresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
        
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animatioController  = MovieAnimatedTransitioning()
        
        animatioController.isPresentation = true
        return animatioController
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animatioController  = MovieAnimatedTransitioning()
        
        animatioController.isPresentation = false
        return animatioController
        
    }
}
