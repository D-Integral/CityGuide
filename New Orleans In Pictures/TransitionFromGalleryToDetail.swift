//
//  TransitionFromGaleryToDetail.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 25.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class TransitionFromGalleryToDetail: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! GalleryVC
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
        
        let containerView = transitionContext.containerView()
        let duration = self.transitionDuration(transitionContext)
        
        var indexPaths = fromViewController.collectionView?.indexPathsForSelectedItems()
        let cell = fromViewController.collectionView?.cellForItemAtIndexPath(indexPaths![0]) as! PictureCell
        
        let cellImageSnapshot: UIView = cell.imageView.snapshotViewAfterScreenUpdates(false)
        cellImageSnapshot.frame = containerView!.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
        cell.imageView.hidden = true
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        toViewController.view.alpha = 0
        toViewController.imageViewForAnimation.hidden = true
        
        containerView!.addSubview(toViewController.view)
        containerView!.addSubview(cellImageSnapshot)
        
        UIView.animateWithDuration(duration, animations: {
            
            toViewController.view.alpha = 1.0
            
            //move snapshot to DetailVC.imageView
            let frame = containerView!.convertRect(toViewController.imageViewForAnimation.frame, fromView: toViewController.view)
            cellImageSnapshot.frame =  frame
            
            }, completion: {(finished: Bool) in
                
                toViewController.imageViewForAnimation.hidden = false
                cell.hidden = false
                cellImageSnapshot.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
