//
//  SwipeableLabel.swift
//  Pods-SwipeableLabel_Example
//
//  Created by hPark11 on 2018. 2. 8..
//

import UIKit

open class SwipeableLabel: UILabel {
    open weak var delegate: SwipeableLabelDelegate?
    
    var offset: CGFloat = 50
    
    let prevAuxilaryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let nextAuxilaryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let swipingLeftGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .left
        return recognizer
    }()
    
    let swipingRightGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .right
        return recognizer
    }()
    
    let swipingUpGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .up
        return recognizer
    }()
    
    let swipingDownGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .down
        return recognizer
    }()
    
    var direction: SwipeDirection = .horizontal {
        didSet {
            removeAllGestureRecognizerTargets()
            
            if direction == .horizontal {
                swipingLeftGestureRecognizer.addTarget(self, action: #selector(swipeToNext))
                swipingRightGestureRecognizer.addTarget(self, action: #selector(swipeToPrev))
            } else {
                swipingUpGestureRecognizer.addTarget(self, action: #selector(swipeToNext))
                swipingDownGestureRecognizer.addTarget(self, action: #selector(swipeToPrev))
            }
        }
    }
    
    enum Move {
        case previous
        case next
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let delegate = delegate, currentIndex < delegate.numberOfItems(in: self), currentIndex >= 0 {
            text = delegate.swipableLabel(self, textForItem: currentIndex)
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        direction = .horizontal
        
        addGestureRecognizer(swipingLeftGestureRecognizer)
        addGestureRecognizer(swipingRightGestureRecognizer)
        addGestureRecognizer(swipingUpGestureRecognizer)
        addGestureRecognizer(swipingDownGestureRecognizer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        removeAllGestureRecognizerTargets()
    }
    
    private var currentIndex: Int = 0
    
    private func transformTo(direction: UISwipeGestureRecognizerDirection) -> CGAffineTransform {
        switch direction {
        case .left: return CGAffineTransform(translationX: offset, y: 0)
        case .right: return CGAffineTransform(translationX: -offset, y: 0)
        case .down: return CGAffineTransform(translationX: offset, y: 0)
        case .up: return CGAffineTransform(translationX: offset, y: 0)
        default: return CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    private func removeAllGestureRecognizerTargets() {
        swipingLeftGestureRecognizer.removeTarget(self, action: #selector(swipeToNext))
        swipingRightGestureRecognizer.removeTarget(self, action: #selector(swipeToPrev))
        swipingUpGestureRecognizer.removeTarget(self, action: #selector(swipeToNext))
        swipingDownGestureRecognizer.removeTarget(self, action: #selector(swipeToPrev))
    }
    
    private func swipe(to: Move, affineTransform: CGAffineTransform) {
        guard let delegate = delegate else {return}
        let auxLabel = UILabel(frame: self.bounds)
        
        auxLabel.font = font
        auxLabel.textAlignment = textAlignment
        auxLabel.textColor = textColor
        auxLabel.backgroundColor = .clear
        auxLabel.transform = affineTransform
        auxLabel.adjustsFontSizeToFitWidth = true
        
        auxLabel.alpha = 0
        addSubview(auxLabel)
        
        let items = delegate.numberOfItems(in: self)
        for i in currentIndex-1...currentIndex+1 where i > 0 && i < items {
            
        }
        
        var textToReplace = self.text!
        
        if to == .next {
            if currentIndex + 1 < items {
                textToReplace = delegate.swipableLabel(self, textForItem: currentIndex + 1)
            }
        } else {
            if currentIndex > 0 {
                textToReplace = delegate.swipableLabel(self, textForItem: currentIndex - 1)
            }
        }
        
        auxLabel.text = textToReplace
        
        UIView.animate(withDuration: 0.32, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = affineTransform
            self.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.18, delay: 0.06, options: .curveEaseIn, animations: {
            auxLabel.transform = .identity
            auxLabel.alpha = 1.0
        }, completion: {_ in
            auxLabel.removeFromSuperview()
            
            if to == .next {
                if self.currentIndex + 1 < items {
                    self.currentIndex += 1
                }
            } else {
                if self.currentIndex > 0 {
                    self.currentIndex -= 1
                }
            }
            self.alpha = 1.0
            self.transform = .identity
        })
    }
    
    @objc func swipeToPrev(_ sender: UISwipeGestureRecognizer) {
        let transform = transformTo(direction: sender.direction)
        swipe(to: .previous, affineTransform: transform)
    }
    
    @objc func swipeToNext(_ sender: UISwipeGestureRecognizer) {
        let transform = transformTo(direction: sender.direction)
        swipe(to: .next, affineTransform: transform)
    }
}
