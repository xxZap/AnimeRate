//
//  AttributeView.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import Foundation
import UIKit

protocol AttributeDelegate: class {
    func attributeSliderDidChange(forAttribute attribute: ScoreAttribute, withNewScore newScore: Float)
}

class AttributeView: UIView {
    // MARK: - IBOutlets
    /// The label with the name of attribute
    @IBOutlet internal weak var attributeLabel: UILabel!
    /// The slider
    @IBOutlet internal weak var scoreSlider: UISlider!
    /// The score fot the attribute
    @IBOutlet internal weak var scoreButton: UIButton!

    // MARK: - Variables
    /// The attribute this AttributeView is refering.
    internal var attribute: ScoreAttribute = .drawings
    /// The delegate for the attribute changes.
    internal weak var attributeDelegate: AttributeDelegate?
    /// The value for the slider snapt behaviour. It's also the possible allowed step between integer for the score.
    internal let stepValue: Float = 0.25

}

// MARK: - Public methods
extension AttributeView {
    /// Launch this when the view is loaded to give a basic configuration.
    func initialize(withDelegate newDelegate: AttributeDelegate?) {
        attributeDelegate = newDelegate
        scoreSlider.minimumValue = 0
        scoreSlider.maximumValue = 10
        scoreButton.isUserInteractionEnabled = false
        scoreButton.layer.cornerRadius = 3
    }
    /// Set the ```attribute```.
    func setAttribute(newAttribute: ScoreAttribute, value: Float?) {
        self.attribute = newAttribute
        self.attributeLabel.text = self.attribute.title
        setScore(to: value ?? 0)
    }
}

// MARK: - IBActions
extension AttributeView {
    /// The Attribute Slider has been changed.
    @IBAction func sliderDidChange(_ sender: UISlider) {
        let newStep: Float = roundf((sender.value) / self.stepValue)
        setScore(to: newStep * stepValue)
        attributeDelegate?.attributeSliderDidChange(forAttribute: attribute, withNewScore: scoreSlider.value)
    }
}

// MARK: - Private functions
extension AttributeView {
    /// Update the score of the attribute.
    internal func setScore(to value: Float) {
        let newColor = attribute.getColor(forScore: value)
        scoreButton.setTitle(String(format: "%.2f", value), for: .normal)
        scoreButton.backgroundColor = newColor
        scoreSlider.value = value
        scoreSlider.tintColor = newColor
    }
}
