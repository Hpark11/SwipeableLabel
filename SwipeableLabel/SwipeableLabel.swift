//
//  SwipeableLabel.swift
//  Pods-SwipeableLabel_Example
//
//  Created by hPark11 on 2018. 2. 8..
//

import UIKit

open class SwipeableLabel: UILabel {
    
    /// func numberOfItems(in label: SwipeableLabel) -> Int
    /// recognize the number of strings that will be used in the label
    ///
    /// - Parameters:
    ///   - label: SwipeableLabel itself
    ///
    /// - Return: Int
    ///
    /// func swipableLabel(_ label: SwipeableLabel, textForItem at: Int) -> String
    /// connect with the collection of data to the label
    ///
    /// - Parameters:
    ///   - label: SwipeableLabel itself
    ///   - at: Integer Index
    ///
    /// - Return: String
    open weak var delegate: SwipeableLabelDelegate?
    
    /// Determine which effect the label takes when swipe
    ///
    /// - Cases:
    ///   - It only can be applied to the label that use dash movement
    open var offset: CGFloat = 0
    
    /// Determine which effect the label takes when swipe
    ///
    /// - Cases:
    ///   - dash: label text moves like dash
    ///   - cubic: moves like rotating box
    ///   - circular: circular movement
    open var movementType: MovementType = .dash
    
    /// When user selected which direction the label swipe, proper reconizers will be added to the target
    ///
    /// - Cases:
    ///   - horizontal: able to swipe to left and right
    ///   - vertical: able to swipe to up and down
    open var direction: SwipeDirection = .horizontal {
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
    
    ///
    /// Collection index in SwipeableLabel is formed with Integer type
    ///
    internal var currentIndex: Int = 0
    
    enum Move: Int {
        case previous = -1
        case next = 1
    }
    
    private let swipingLeftGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .left
        return recognizer
    }()
    
    private let swipingRightGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .right
        return recognizer
    }()
    
    private let swipingUpGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .up
        return recognizer
    }()
    
    private let swipingDownGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .down
        return recognizer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        removeAllGestureRecognizerTargets()
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
    
    private func removeAllGestureRecognizerTargets() {
        swipingLeftGestureRecognizer.removeTarget(self, action: #selector(swipeToNext))
        swipingRightGestureRecognizer.removeTarget(self, action: #selector(swipeToPrev))
        swipingUpGestureRecognizer.removeTarget(self, action: #selector(swipeToNext))
        swipingDownGestureRecognizer.removeTarget(self, action: #selector(swipeToPrev))
    }
    
    @objc func swipeToPrev(_ sender: UISwipeGestureRecognizer) {
        switch movementType {
        case .dash:
            dash(to: .previous, direction: sender.direction)
        case .cubical:
            cubic(to: .previous, direction: sender.direction)
        default: break
        }
    }
    
    @objc func swipeToNext(_ sender: UISwipeGestureRecognizer) {
        switch movementType {
        case .dash:
            dash(to: .next, direction: sender.direction)
        case .cubical:
            cubic(to: .next, direction: sender.direction)
        default: break
        }
    }
    
    internal func representativeCopiedLabelModel() -> UILabel {
        let presentLabel = UILabel(frame: self.bounds)
        
        presentLabel.font = font
        presentLabel.textAlignment = textAlignment
        presentLabel.textColor = textColor
        presentLabel.backgroundColor = .clear
        presentLabel.adjustsFontSizeToFitWidth = true
        presentLabel.alpha = 1
        
        return presentLabel
    }
    
    internal func textToReplace(to: Move) -> String {
        guard let delegate = delegate else { return "" }
        
        if to == .next {
            if currentIndex + 1 < delegate.numberOfItems(in: self) {
                return delegate.swipableLabel(self, textForItem: currentIndex + 1)
            }
        } else {
            if currentIndex > 0 {
                return delegate.swipableLabel(self, textForItem: currentIndex - 1)
            }
        }
        return text!
    }
    
    internal func moveIndex(to: Move) {
        guard let delegate = delegate else { return }
        
        if to == .next {
            if currentIndex + 1 < delegate.numberOfItems(in: self) {
                currentIndex += 1
            }
        } else {
            if currentIndex > 0 {
                currentIndex -= 1
            }
        }
    }
}

