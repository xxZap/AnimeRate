//
//  AnimatableCell.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import Foundation
import UIKit

/// This UICollectionViewCell change its scale during the touch to give a bouncing animation.
/// By default it animate all the UICollectionViewCell content but if you want you can set the `animatableView` and only that view will be animated.
class AnimatableCell: UICollectionViewCell {

    /// If you want to animate only a particular view and not all the content of the tableview, you can assign that view to this variable
    var animatableView: UIView?
    var targetScaleX: CGFloat = 0.96
    var targetScaleY: CGFloat = 0.96

    /// Called when the user taps this cell
    var cellDidTap: ((UICollectionViewCell) -> ())?
    var touchAnimationIsActive: Bool = true

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard touchAnimationIsActive else { return }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let aliveSelf = self else { return }
            let view = aliveSelf.animatableView ?? aliveSelf
            view.transform = CGAffineTransform(scaleX: aliveSelf.targetScaleX, y: aliveSelf.targetScaleY)
            }, completion: nil)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard touchAnimationIsActive else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let aliveSelf = self else { return }
            let view = aliveSelf.animatableView ?? aliveSelf
            view.transform = CGAffineTransform.identity
            }, completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard touchAnimationIsActive else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            guard let aliveSelf = self else { return }
            let view = aliveSelf.animatableView ?? aliveSelf
            view.transform = CGAffineTransform.identity
            }, completion: { [weak self] completed in
                guard let aliveSelf = self else { return }
                aliveSelf.cellDidTap?(aliveSelf)
        })
    }
}
