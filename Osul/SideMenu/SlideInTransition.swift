//
//  SlideInTransition.swift
//  Hermosa
//
//  Created by apple on 11/21/19.
//  Copyright © 2019 Softagi. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    let dimmingView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width * 0.7
         let Width = toViewController.view.bounds.width
        let finalHeight = toViewController.view.bounds.height
        
        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
           // dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)
            
            // Init frame off the screen
            toViewController.view.frame = CGRect(x: finalWidth, y: 0, width:   dimmingView.frame.size.width - finalWidth , height: finalHeight)
            UIView.animate(withDuration: 0.4) {
                toViewController.view.frame = CGRect(x: self.dimmingView.frame.size.width - finalWidth, y: 0, width: finalWidth, height: finalHeight)
                self.dimmingView.alpha = 1
                  }
        }


        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: self.dimmingView.frame.size.width - Width , y: 0)
        }
        
        
        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.5
            fromViewController.view.transform = .identity
        }
        
        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: 0.47, animations: {
            self.isPresenting ? transform() : identity()
            //   toViewController.view.frame = CGRect(x:  finalWidth, y: 0, width: self.dimmingView.frame.size.width  , height: finalHeight)
        }) { (_) in
//            self.dimmingView.removeFromSuperview()
//             toViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!isCancelled)
        }
    }
//            @objc func handleDismiss()
//            {
//                UIView.animate(withDuration: 0.47, animations: {
//                    let window = UIApplication.shared.keyWindow
//     let finalHeight = toViewController.view.bounds.height
//                    let width = (window?.frame.width)! - 150
//
//                    toViewController.view.frame = CGRect(x:  finalWidth, y: 0, width: self.dimmingView.frame.size.width - finalWidth , height: finalHeight)
//
//                    self.dimmingView.alpha = 0.5
//
//                }) { (completed) in
//                    self.dimmingView.removeFromSuperview()
//                    toViewController.view.removeFromSuperview()
//                }
//            }
}
