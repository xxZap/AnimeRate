//
//  FadingView.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class FadingView: UIView {

    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    @IBInspectable var invertMode:      Bool =  false { didSet { updateColors() }}

    private let gradientLayerMask = CAGradientLayer()

    private func updatePoints() {
        if horizontalMode {
            gradientLayerMask.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayerMask.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayerMask.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayerMask.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }

    private func updateLocations() {
        gradientLayerMask.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }

    private func updateSize() {
        gradientLayerMask.frame = bounds
    }

    private func updateColors() {
        gradientLayerMask.colors = invertMode ? [UIColor.white.cgColor, UIColor.clear.cgColor] : [UIColor.clear.cgColor, UIColor.white.cgColor]
    }

    private func commonInit() {
        layer.mask = gradientLayerMask
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateSize()
        updateColors()
    }
}
