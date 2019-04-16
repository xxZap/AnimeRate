//
//  ExpandableCell.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import UIKit

class ExpandableCell: AnimatableCell, Expandable {

    @IBOutlet internal weak var collapsedHeightConstraints: NSLayoutConstraint!
    @IBOutlet internal weak var expandedHeightConstraints: NSLayoutConstraint!
    @IBOutlet internal weak var expandableContentView: UIView!
    private var initialFrame: CGRect?
    private var initialCornerRadius: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAll()
    }
    
    // MARK: - Configuration
    
    private func configureAll() {
        configureCell()
        expandedHeightConstraints.priority = UILayoutPriority(rawValue: 99)
        collapsedHeightConstraints.priority = UILayoutPriority(rawValue: 999)
        expandableContentView.setNeedsLayout()
    }
    
    private func configureCell() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 7
        self.contentView.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 7)
        self.layer.shadowRadius = self.contentView.layer.cornerRadius
    }
    
    // MARK: - Showing/Hiding Logic
    
    func hide(in collectionView: UICollectionView, frameOfSelectedCell: CGRect) {
        initialFrame = self.frame
        let currentY = self.frame.origin.y
        let newY: CGFloat
        
        if currentY < frameOfSelectedCell.origin.y {
            let offset = frameOfSelectedCell.origin.y - currentY
            newY = collectionView.contentOffset.y - offset
        } else {
            let offset = currentY - frameOfSelectedCell.maxY
            newY = collectionView.contentOffset.y + collectionView.frame.height + offset
        }
        
        self.frame.origin.y = newY
        layoutIfNeeded()
    }
    
    func show() {
        self.frame = initialFrame ?? self.frame
        initialFrame = nil
        layoutIfNeeded()
    }
    
    // MARK: - Expanding/Collapsing Logic
    
    func expand(in collectionView: UICollectionView) {
        initialFrame = self.frame
        touchAnimationIsActive = false
        initialCornerRadius = self.contentView.layer.cornerRadius
        updateHeight(expanded: true)
        
        self.contentView.layer.cornerRadius = 0
        self.frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
        
        layoutIfNeeded()
    }
    
    func collapse() {
        self.contentView.layer.cornerRadius = initialCornerRadius ?? self.contentView.layer.cornerRadius
        self.frame = initialFrame ?? self.frame
        
        initialFrame = nil
        touchAnimationIsActive = true
        initialCornerRadius = nil
        updateHeight(expanded: false)
        
        layoutIfNeeded()
    }
    
}

extension ExpandableCell {
    internal func updateHeight(expanded: Bool) {
        expandedHeightConstraints.priority  = expanded ? UILayoutPriority(rawValue: 999) : UILayoutPriority(rawValue: 99)
        collapsedHeightConstraints.priority = expanded ? UILayoutPriority(rawValue: 99) : UILayoutPriority(rawValue: 999)
        expandableContentView.setNeedsLayout()
    }
}
