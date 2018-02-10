//
//  SwipeableLable+DashMovement.swift
//  SwipeableLabel
//
//  Created by hPark11 on 2018. 2. 9..
//

import Foundation

extension SwipeableLabel {
    internal func dash(to: Move, direction: UISwipeGestureRecognizerDirection) {
        let presentLabel = representativeCopiedLabelModel()
        let affineTransform = dashTransform(direction: direction)
        
        presentLabel.transform = affineTransform
        addSubview(presentLabel)
        
        presentLabel.alpha = 0
        presentLabel.text = textToReplace(to: to)
        
        UIView.animate(withDuration: 0.32, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = affineTransform
            self.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.24, delay: 0.06, options: .curveEaseIn, animations: {
            presentLabel.transform = .identity
            presentLabel.alpha = 1.0
        }, completion: {_ in
            presentLabel.removeFromSuperview()
            
            self.moveIndex(to: to)
            
            UIView.animate(withDuration: 0.10, delay: 0.0, options: .curveEaseIn, animations: {
                self.alpha = 1.0
                self.transform = .identity
            }, completion: nil)
        })
    }
    
    fileprivate func dashTransform(direction: UISwipeGestureRecognizerDirection) -> CGAffineTransform {
        switch direction {
        case .left: return CGAffineTransform(translationX: offset, y: 0)
        case .right: return CGAffineTransform(translationX: -offset, y: 0)
        case .down: return CGAffineTransform(translationX: 0, y: offset)
        case .up: return CGAffineTransform(translationX: 0, y: -offset)
        default: return CGAffineTransform(translationX: 0, y: 0)
        }
    }
}
