//
//  TransitionFromDetailToGallery.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 25.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import MapKit

class TransitionFromDetailToGallery: NSObject, UIViewControllerAnimatedTransitioning {
    
    var imageSnapshot: UIView!
    var containerView: UIView!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! DetailViewController
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! GalleryVC
        
        containerView = transitionContext.containerView()
        var duration = self.transitionDuration(transitionContext)
        
        var annotation = fromViewController.pointOfInterestAnnotation
        var viewForAnnotation = fromViewController.mapView.viewForAnnotation(annotation)
        
        viewForAnnotation == nil ? makeSnapshotFromView(fromViewController.imageViewForAnimation) : makeSnapshotFromView(viewForAnnotation)
        
        var cell = toViewController.collectionView?.cellForItemAtIndexPath(fromViewController.selectedCellIndexPath) as! PictureCell
        cell.imageView.hidden = true
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        containerView.addSubview(imageSnapshot)
        
        UIView.animateWithDuration(duration, animations: {
            fromViewController.view.alpha = 0.0
            self.imageSnapshot.frame = self.containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
            }, completion: {(finished: Bool) in
                self.imageSnapshot.removeFromSuperview()
                fromViewController.imageViewForAnimation.hidden = false
                cell.imageView.hidden = false
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    
    func makeSnapshotFromView(view: UIView) {
        if view is MKAnnotationView {
            imageSnapshot = view.snapshotViewAfterScreenUpdates(false)
        } else {
            imageSnapshot = view.snapshotViewAfterScreenUpdates(true)
        }
        imageSnapshot.frame = containerView.convertRect(view.frame, fromView: view.superview)
        view.hidden = true
        view.removeFromSuperview()
    }
}
