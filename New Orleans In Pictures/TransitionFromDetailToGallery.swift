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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! DetailViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! GalleryVC
        
        containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        let annotation = fromViewController.pointOfInterestAnnotation
        let viewForAnnotation = fromViewController.mapView.view(for: annotation!)
        
        viewForAnnotation == nil ? makeSnapshotFromView(fromViewController.imageViewForAnimation) : makeSnapshotFromView(viewForAnnotation!)
        
        let cell = toViewController.collectionView?.cellForItem(at: fromViewController.selectedCellIndexPath as IndexPath) as! PictureCell
        cell.imageView.isHidden = true
        
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        containerView.addSubview(imageSnapshot)
        
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0.0
            self.imageSnapshot.frame = self.containerView.convert(cell.imageView.frame, from: cell.imageView.superview)
            }, completion: {(finished: Bool) in
                self.imageSnapshot.removeFromSuperview()
                fromViewController.imageViewForAnimation.isHidden = false
                cell.imageView.isHidden = false
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func makeSnapshotFromView(_ view: UIView) {
        if view is MKAnnotationView {
            imageSnapshot = view.snapshotView(afterScreenUpdates: false)
        } else {
            imageSnapshot = view.snapshotView(afterScreenUpdates: true)
        }
        imageSnapshot.frame = containerView.convert(view.frame, from: view.superview)
        view.isHidden = true
        view.removeFromSuperview()
    }
}
