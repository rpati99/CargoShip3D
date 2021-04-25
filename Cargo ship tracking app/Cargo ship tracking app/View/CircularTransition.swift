//
//  CircularTransition.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 25/04/21.
//

import UIKit

class CircularTransition: NSObject {
    
    var circle = UIView()
    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    enum TransitionMode: Int {
        case present, dismiss, pop
    }
    
    var currentMode: TransitionMode = .present
}


extension CircularTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let parentView = transitionContext.containerView
        
        if currentMode == .present {
            if let presentedView = transitionContext.view(forKey: .to) {
                let viewCenter = parentView.center
                let viewSize = parentView.frame.size
                
                
                circle = UIView()
                circle.frame = createFrame(center: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.width / 2
                circle.center = startingPoint
                circle.backgroundColor = .white
                circle.transform = CGAffineTransform(scaleX: 0, y: 0)
                
                parentView.addSubview(circle)
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0, y: 0)
                presentedView.alpha = 0
                parentView.addSubview(presentedView)
                
                UIView.animate(withDuration: 0.2) {
                    self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                } completion: { (status: Bool) in
                    transitionContext.completeTransition(status)
                }
                
                
            }
        } else {
            let modeKey = (currentMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: modeKey) {
                
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = createFrame(center: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.width / 2
                circle.center = startingPoint
                
                UIView.animate(withDuration: 0.2) {
                    self.circle.transform = CGAffineTransform(scaleX: 0, y: 0)
                    returningView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    returningView.alpha = 0
                    
                    
                    if self.currentMode == .pop {
                        parentView.insertSubview(returningView, belowSubview: returningView)
                        parentView.insertSubview(self.circle, belowSubview: returningView)
                        
                    }
                } completion: { (status: Bool) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    self.circle.removeFromSuperview()
                    transitionContext.completeTransition(status)
                }
            }
            
        }
    }
    
    
    func createFrame(center: CGPoint, size: CGSize, startPoint: CGPoint) -> CGRect {
        
        let xLength = fmax(startPoint.x, size.width - startPoint.x)
        let yLength = fmax(startPoint.y, size.height - startPoint.y)
        
        let offSetVector = sqrt(xLength * xLength + yLength * yLength)
        
        return CGRect(origin: startPoint, size: CGSize(width: offSetVector, height: offSetVector))
        
    }
    
    
    
    
}
