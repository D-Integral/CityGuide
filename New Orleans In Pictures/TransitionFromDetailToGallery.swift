//
//  TransitionFromDetailToGallery.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 25.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class TransitionFromDetailToGallery: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! DetailVC
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! GalleryVC
        
        var containerView = transitionContext.containerView()
        var duration = self.transitionDuration(transitionContext)
        
        var imageSnapshot: UIView = fromViewController.imageView!.snapshotViewAfterScreenUpdates(false)
        imageSnapshot.frame = containerView.convertRect(fromViewController.imageView.frame, fromView: fromViewController.imageView.superview)
        fromViewController.imageView.hidden = true
        
        var cell = toViewController.collectionView?.cellForItemAtIndexPath(fromViewController.chosenCellIndexPath) as! PictureCell
        cell.imageView.hidden = true
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        containerView.addSubview(imageSnapshot)
        
        UIView.animateWithDuration(duration, animations: {
            fromViewController.view.alpha = 0.0
            imageSnapshot.frame = containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
            }, completion: {(finished: Bool) in
                imageSnapshot.removeFromSuperview()
                fromViewController.imageView.hidden = false
                cell.imageView.hidden = false
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
