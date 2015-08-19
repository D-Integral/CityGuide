//
//  TransitionFromGaleryToDetail.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 25.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class TransitionFromGalleryToDetail: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! GalleryVC
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
        
        var containerView = transitionContext.containerView()
        var duration = self.transitionDuration(transitionContext)
        
        var indexPaths = fromViewController.collectionView?.indexPathsForSelectedItems()
        var cell = fromViewController.collectionView?.cellForItemAtIndexPath((indexPaths as! [NSIndexPath])[0]) as! PictureCell
        
        var cellImageSnapshot: UIView = cell.imageView.snapshotViewAfterScreenUpdates(false)
        cellImageSnapshot.frame = containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
        cell.imageView.hidden = true
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        toViewController.view.alpha = 0
        toViewController.imageViewForAnimation.hidden = true
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(cellImageSnapshot)
        
        UIView.animateWithDuration(duration, animations: {
            
            toViewController.view.alpha = 1.0
            
            //move snapshot to DetailVC.imageView
            var frame = containerView.convertRect(toViewController.imageViewForAnimation.frame, fromView: toViewController.view)
            cellImageSnapshot.frame =  frame
            
            }, completion: {(finished: Bool) in
                
                toViewController.imageViewForAnimation.hidden = false
                cell.hidden = false
                cellImageSnapshot.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
