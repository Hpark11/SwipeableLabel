//
//  SwipeableLabel.swift
//  Pods-SwipeableLabel_Example
//
//  Created by hPark11 on 2018. 2. 8..
//

import Foundation

public protocol SwipeableLabelDelegate: NSObjectProtocol {
    
    /// recognize the number of strings that will be used in the label
    ///
    /// - Parameters:
    ///   - label: SwipeableLabel itself
    ///
    /// - Return: Int
    func numberOfItems(in label: SwipeableLabel) -> Int
    
    /// recognize the number of strings that will be used in the label
    ///
    /// - Parameters:
    ///   - label: SwipeableLabel itself
    ///
    /// - Return: String
    func swipableLabel(_ label: SwipeableLabel, textForItem at: Int) -> String
}
