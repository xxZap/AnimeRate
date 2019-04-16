//
//  AnimeElementCollectionViewCell.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import Foundation
import UIKit

protocol AnimeElementDelegate: class {
    func animeElementCloseButtonDidTap(_ cell: AnimeElementCollectionViewCell)
    func animeElementDeleteButtonDidTap(_ cell: AnimeElementCollectionViewCell)
    func animeElementShareButtonDidTap(_ cell: AnimeElementCollectionViewCell)
}

/// This cell expands and collapses as an ExpandableCell should do.
/// One expanded it shows command to edit data, save and close the cell.
class AnimeElementCollectionViewCell: ExpandableCell {
    // MARK: - IBOutlets
    /// The label about the name of the element.
    @IBOutlet internal weak var elementTitleLabel: UILabel!
    /// The close button to collapse the cell.
    @IBOutlet internal weak var closeButton: UIButton!
    /// The delete button to delete this element permanently
    @IBOutlet internal weak var deleteButton: UIButton!
    /// The share button to share this element.
    @IBOutlet internal weak var shareButton: UIButton!
    /// The custom photo on the right of the view.
    @IBOutlet internal weak var previewPicture: UIImageView!
    /// The total score label for this element.
    @IBOutlet internal weak var totalScoreLabel: UILabel!

    @IBOutlet internal weak var drawingAttributeView: AttributeView!
    @IBOutlet internal weak var storyAttributeView: AttributeView!
    @IBOutlet internal weak var charactersAttributeView: AttributeView!
    @IBOutlet internal weak var musicsAttributeView: AttributeView!
    @IBOutlet internal weak var endAttributeView: AttributeView!

    /// The textfield to write the image to use as preview.
    @IBOutlet internal weak var imageUrlTextField: UITextField!
    /// The button to save and refresh the preview image of this element.
    @IBOutlet internal weak var imageUrlReloadButton: UIButton!
    /// The textfield to write your favourite link for streaming.
    @IBOutlet internal weak var streamingUrlTextField: UITextField!

    // MARK: - Variables
    /// The responder of the cell events.
    internal weak var cellDelegate: AnimeElementDelegate?
    internal let smallScoreFontSize: CGFloat = 20
    internal let bigScoreFontSize: CGFloat = 34
    internal let smallTitleFontSize: CGFloat = 13
    internal let bigTitleFontSize: CGFloat = 17
    internal var attributesDictionary: [String: Float] = [
        ScoreAttribute.drawings.title: 6,
        ScoreAttribute.story.title: 7.5,
        ScoreAttribute.characters.title: 8.5,
        ScoreAttribute.musics.title: 5,
        ScoreAttribute.end.title: 7
    ]

    // MARK: - Life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        drawingAttributeView.initialize(withDelegate: self)
        drawingAttributeView.setAttribute(newAttribute: .drawings, value: attributesDictionary[ScoreAttribute.drawings.title])
        storyAttributeView.initialize(withDelegate: self)
        storyAttributeView.setAttribute(newAttribute: .story, value: attributesDictionary[ScoreAttribute.story.title])
        charactersAttributeView.initialize(withDelegate: self)
        charactersAttributeView.setAttribute(newAttribute: .characters, value: attributesDictionary[ScoreAttribute.characters.title])
        musicsAttributeView.initialize(withDelegate: self)
        musicsAttributeView.setAttribute(newAttribute: .musics, value: attributesDictionary[ScoreAttribute.musics.title])
        endAttributeView.initialize(withDelegate: self)
        endAttributeView.setAttribute(newAttribute: .end, value: attributesDictionary[ScoreAttribute.end.title])

        totalScoreLabel.font = UIFont.boldSystemFont(ofSize: smallScoreFontSize)
        totalScoreLabel.layer.shadowColor = UIColor.black.cgColor
        totalScoreLabel.layer.shadowRadius = 3
        totalScoreLabel.layer.shadowOpacity = 0.4
        totalScoreLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        totalScoreLabel.layer.masksToBounds = false
    }

    // MARK: - ExpandableCell
    override func expand(in collectionView: UICollectionView) {
        stopRotatingUpdateButton()
        UIView.transition(with: totalScoreLabel, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let aliveSelf = self else { return }
            aliveSelf.totalScoreLabel.font = aliveSelf.totalScoreLabel.font.withSize(aliveSelf.bigScoreFontSize)
            aliveSelf.elementTitleLabel.font = aliveSelf.elementTitleLabel.font.withSize(aliveSelf.bigTitleFontSize)
        }) { isFinished in }
        super.expand(in: collectionView)
    }

    override func collapse() {
        UIView.transition(with: totalScoreLabel, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let aliveSelf = self else { return }
            aliveSelf.totalScoreLabel.font = aliveSelf.totalScoreLabel.font.withSize(aliveSelf.smallScoreFontSize)
            aliveSelf.elementTitleLabel.font = aliveSelf.elementTitleLabel.font.withSize(aliveSelf.smallTitleFontSize)
        }) { [weak self] isFinished in
            self?.stopRotatingUpdateButton()
        }
        super.collapse()
    }
}

// MARK: - Public methods
extension AnimeElementCollectionViewCell {
    /// Configure the cell UI and data.
    ///
    /// - Parameter newDelegate: the responder of this cell.
    func configureCell(withDelegate newDelegate: AnimeElementDelegate?) {
        self.cellDelegate = newDelegate
        totalScoreLabel.text = String(format: "%.2f", calculateTotalScore())
    }
}

// MARK: - IBActions
extension AnimeElementCollectionViewCell {
    /// Advice the delegate that the user wants to close the cell.
    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        cellDelegate?.animeElementCloseButtonDidTap(self)
    }
    /// The user tapped on delete button.
    @IBAction func deleteButtonDidTap(_ sender: UIButton) {
        cellDelegate?.animeElementDeleteButtonDidTap(self)
    }
    /// The user tapped on share button.
    @IBAction func shareButtonDidTap(_ sender: UIButton) {
        cellDelegate?.animeElementShareButtonDidTap(self)
    }
    /// The user tapped on update image preview button.
    @IBAction func updateImageUrlDidTap(_ sender: UIButton) {
        if let urlString = imageUrlTextField.text, let url = URL(string: urlString) {
            // TODO:  LOAD IMAGE
            print("TODO load image")
            startRotatingUpdateButton()
            return
        }
        startRotatingUpdateButton()
    }
}

// MARK: - Private functions
extension AnimeElementCollectionViewCell {
    /// Disable the ```imageUrlReloadButton``` and start rotating it.
    internal func startRotatingUpdateButton() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float.infinity
        imageUrlReloadButton.layer.add(rotateAnimation, forKey: nil)
        imageUrlReloadButton.setImage(#imageLiteral(resourceName: "update_loading"), for: .normal)
        imageUrlReloadButton.isUserInteractionEnabled = false
        imageUrlTextField.isUserInteractionEnabled = false
        imageUrlTextField.alpha = 0.5
    }

    /// Enable the ```imageUrlReloadButton``` and stop animating it.
    internal func stopRotatingUpdateButton() {
        imageUrlReloadButton.layer.removeAllAnimations()
        imageUrlReloadButton.setImage(#imageLiteral(resourceName: "update"), for: .normal)
        imageUrlReloadButton.isUserInteractionEnabled = true
        imageUrlTextField.isUserInteractionEnabled = true
        imageUrlTextField.alpha = 1
    }

    /// Return the calculated score based on the ScoreAttributes.
    internal func calculateTotalScore() -> Float {
        let drawingsScore: Float = attributesDictionary[ScoreAttribute.drawings.title] ?? 0
        let storyScore: Float = attributesDictionary[ScoreAttribute.story.title] ?? 0
        let charactersScore: Float = attributesDictionary[ScoreAttribute.characters.title] ?? 0
        let musicsScore: Float = attributesDictionary[ScoreAttribute.musics.title] ?? 0
        let endScore: Float = attributesDictionary[ScoreAttribute.end.title] ?? 0
        return (drawingsScore + storyScore + charactersScore + musicsScore + endScore) / 5
    }
}

extension AnimeElementCollectionViewCell: AttributeDelegate {
    func attributeSliderDidChange(forAttribute attribute: ScoreAttribute, withNewScore newScore: Float) {
        attributesDictionary[attribute.title] = newScore
        totalScoreLabel.text = String(format: "%.2f", calculateTotalScore())
    }
}
