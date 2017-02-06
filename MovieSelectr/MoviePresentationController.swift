//
//  MoviePresentationController.swift
//  MovieSelectr
//
//  Created by NXP Tims on 12/01/17.
//  Copyright © 2017 deb. All rights reserved.
//

import UIKit

class MoviePresentationController: UIPresentationController,UIAdaptivePresentationControllerDelegate {
    
    var dimmingView = UIView()
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        dimmingView.alpha = 0
    }
    
    override func presentationTransitionWillBegin() {
        self.dimmingView.frame = self.containerView!.bounds
        self.dimmingView.alpha = 0
        
        if let coordinator = presentedViewController.transitionCoordinator{
            coordinator.animate(alongsideTransition: { (context :UIViewControllerTransitionCoordinatorContext) in
                self.dimmingView.alpha = 1
            }, completion: nil)
        }else{
            self.dimmingView.alpha = 1
        }
    }
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator{
            coordinator.animate(alongsideTransition: { (context :UIViewControllerTransitionCoordinatorContext) in
                self.dimmingView.alpha = 0
            }, completion: nil)
        }else{
            self.dimmingView.alpha = 0
        }
    }

    override func containerViewWillLayoutSubviews() {
        if let containerBound = containerView?.bounds{
            dimmingView.frame = containerBound
            presentedView?.frame = containerBound
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
}
