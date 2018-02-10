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
        presentLabel.text = textToReplace(to: to)
        
        presentLabel.transform = cubicTransform(multiplier: CGFloat(to.rawValue), direction: direction)
        superview?.addSubview(presentLabel)
        
        UIView.animate(withDuration: 0.42, delay: 0.0, options: .curveEaseOut, animations: {
            presentLabel.transform = .identity
            
            self.transform = self.cubicTransform(multiplier: -CGFloat(to.rawValue), direction: direction)
        }, completion: { _ in
            self.transform = .identity
            self.moveIndex(to: to)
            self.text = presentLabel.text
            presentLabel.removeFromSuperview()
        })
    }
    
    fileprivate func cubicTransform(multiplier: CGFloat, direction: UISwipeGestureRecognizerDirection) -> CGAffineTransform {
        if direction == .up || direction == .down {
            return CGAffineTransform(translationX: 0, y: frame.size.height / 2 * multiplier)
                .scaledBy(x: 1, y: 0.1)
        } else {
            return CGAffineTransform(translationX: frame.size.width / 2 * multiplier, y: 0)
                .scaledBy(x: 0.1, y: 1)
        }
    }
}
