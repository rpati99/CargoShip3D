//
//  ViewControllerTransitionExtensions.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 09/11/21.
//

import Foundation
import UIKit

// MARK: - UIViewControllerTransitioningDelegate methods


extension ViewController: UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.currentMode = .present
        transition.startingPoint = nextButton.center
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.currentMode = .dismiss
        transition.startingPoint = nextButton.center
        return transition
    }
}
