//
//  CubicMovement.swift
//  SwipeableLabel
//
//  Created by hPark11 on 2018. 2. 9..
//

import Foundation

extension SwipeableLabel {
    func cubic(to: Move, direction: UISwipeGestureRecognizerDirection) {
        let presentLabel = representativeCopiedLabelModel()
        let flag = CGFloat(to.rawValue)
        presentLabel.text = textToReplace(to: to)
        
        if direction == .up || direction == .down {
            presentLabel.transform = CGAffineTransform(translationX: 0, y: frame.size.height / 2 * flag)
                .scaledBy(x: 1, y: 0.1)
        } else {
            presentLabel.transform = CGAffineTransform(translationX: frame.size.width / 2 * flag, y: 0)
                .scaledBy(x: 0.1, y: 1)
        }
        
        superview?.addSubview(presentLabel)
        
        UIView.animate(withDuration: 0.42, delay: 0.0, options: .curveEaseOut, animations: {
            presentLabel.transform = .identity
            
            if direction == .up || direction == .down {
                self.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height / 2 * -flag)
                    .scaledBy(x: 1, y: 0.1)
            } else {
                self.transform = CGAffineTransform(translationX: self.frame.size.width / 2 * -flag, y: 0)
                    .scaledBy(x: 0.1, y: 1)
            }
            
        }, completion: { _ in
            self.transform = .identity
            self.moveIndex(to: to)
            self.text = presentLabel.text
            presentLabel.removeFromSuperview()
        })
    }
}
