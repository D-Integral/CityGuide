//
//  TransitionFromGaleryToDetail.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 25.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class TransitionFromGalleryToDetail: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! GalleryVC
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DetailViewController
        
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        var indexPaths = fromViewController.collectionView?.indexPathsForSelectedItems
        let cell = fromViewController.collectionView?.cellForItem(at: indexPaths![0]) as! PictureCell
        
        let cellImageSnapshot: UIView = cell.imageView.snapshotView(afterScreenUpdates: false)!
        cellImageSnapshot.frame = containerView.convert(cell.imageView.frame, from: cell.imageView.superview)
        cell.imageView.isHidden = true
        
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        toViewController.view.alpha = 0
        toViewController.imageViewForAnimation.isHidden = true
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(cellImageSnapshot)
        
        UIView.animate(withDuration: duration, animations: {
            
            toViewController.view.alpha = 1.0
            
            //move snapshot to DetailVC.imageView
            let frame = containerView.convert(toViewController.imageViewForAnimation.frame, from: toViewController.view)
            cellImageSnapshot.frame =  frame
            
            }, completion: {(finished: Bool) in
                
                toViewController.imageViewForAnimation.isHidden = false
                cell.isHidden = false
                cellImageSnapshot.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
