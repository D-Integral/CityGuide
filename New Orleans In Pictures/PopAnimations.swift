//
//  Animations.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

extension DetailViewController {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC === self && toVC.isKind(of: GalleryVC.self) {
            return TransitionFromDetailToGallery()
        } else {
            return nil
        }
    }
    
    func handlePopRecognizer(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        var progress = recognizer.translation(in: self.view).x / self.view.bounds.size.width * 1.0
        progress = min(1.0, max(0.0, progress))
        
        if recognizer.state == UIGestureRecognizerState.began {
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewController(animated: true)
        } else if recognizer.state == UIGestureRecognizerState.changed {
            self.interactivePopTransition.update(progress)
        } else if recognizer.state == UIGestureRecognizerState.ended || recognizer.state == UIGestureRecognizerState.cancelled {
            if progress > 0.5 {
                self.interactivePopTransition.finish()
            } else {
                self.interactivePopTransition.cancel()
            }
            self.interactivePopTransition = nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if animationController.isKind(of: TransitionFromDetailToGallery.self) {
            return self.interactivePopTransition
        } else {
            return nil
        }
    }
}

