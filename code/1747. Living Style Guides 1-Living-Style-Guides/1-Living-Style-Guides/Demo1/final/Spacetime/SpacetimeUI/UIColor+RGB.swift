//
//  UIColor+RGB.swift
//  Spacetime
//
//  Created by Ellen Shapiro on 11/26/17.
//  Copyright © 2017 RayWenderlich.com. All rights reserved.
//

import UIKit

extension UIColor {
  
  /// Takes integer values for Red, Green, and Blue channels to make
  /// creating colors from RGB a bit easier.
  ///
  /// Note: Assertions will fire during development if inappropriate values are passed.
  ///
  /// - Parameters:
  ///   - r: An integer between 0 and 255 representing the red channel value
  ///   - g: An integer between 0 and 255 representing the green channel value
  ///   - b: An integer between 0 and 255 representing the blue channel value
  ///   - a: A CGFloat between 0.0 and 1.0 representing the alpha (0.0 is transparent, 1.0 is opaque).
  /// - Returns: The created UIColor
  public static func spc_from(r: Int, g: Int, b: Int, a: CGFloat = 1.0) -> UIColor {
    assert((0 <= r && r <= 255), "Use a red value between 0 and 255!")
    assert((0 <= g && g <= 255), "Use a green value between 0 and 255!")
    assert((0 <= b && b <= 255), "Use a blue value between 0 and 255!")
    assert((0.0 <= a && a <= 1.0), "Use and alpha value between 0 and 1!")
    return UIColor(red: CGFloat(r) / 255.0,
                   green: CGFloat(g) / 255.0,
                   blue: CGFloat(b) / 255.0,
                   alpha: a)
  }
}
