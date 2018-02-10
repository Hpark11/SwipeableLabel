//
//  Configuration.swift
//  Pods-SwipeableLabel_Example
//
//  Created by hPark11 on 2018. 2. 8..
//

import Foundation

/// Determine which directions the label swipe
///
/// - Cases:
///   - horizontal: able to swipe to left and right
///   - vertical: able to swipe to up and down
public enum SwipeDirection {
    case horizontal
    case vertical
}

/// Determine which effect the label takes when swipe
///
/// - Cases:
///   - dash: label text moves like dash
///   - cubic: moves like rotating box
///   - circular: circular movement
public enum MovementType {
    case dash
    case cubical
    case circular
}

