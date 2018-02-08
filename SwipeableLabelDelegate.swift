//
//  SwipeableLabel.swift
//  Pods-SwipeableLabel_Example
//
//  Created by hPark11 on 2018. 2. 8..
//

import Foundation

protocol SwipeableLabelDelegate: NSObjectProtocol {
    func numberOfItems(in label: SwipeableLabel) -> Int
    
    func swipableLabel(_ label: SwipeableLabel, textForItem at: Int) -> String
}
