//
//  AnimeListViewController.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import UIKit

class AnimeListViewController : UIViewController {

    @IBOutlet internal weak var collectionView: UICollectionView!
    
    internal var hiddenCells: [ExpandableCell] = []
    internal var expandedCell: ExpandableCell?
    internal var lastCollectionViewOffset: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "\(AnimeElementCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(AnimeElementCollectionViewCell.self)")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumLineSpacing = 10
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - UICollectionViewDataSource
extension AnimeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AnimeElementCollectionViewCell.self)", for: indexPath) as? AnimeElementCollectionViewCell {
            cell.configureCell(withDelegate: self)
            cell.cellDidTap = { [weak self] cell in
                guard let aliveSelf = self,
                    let expandableCell = cell as? ExpandableCell else { return }
                aliveSelf.expand(selectedCell: expandableCell)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AnimeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let availableSpace: CGFloat = collectionView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
            let height: CGFloat = 50
            return CGSize(width: availableSpace, height: height)
        }
        return CGSize.zero
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let _ = expandedCell {
            lastCollectionViewOffset = scrollView.contentOffset
        } else {
            lastCollectionViewOffset = nil
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // lock the scrolling behaviour if there's an expanded cell
        if let _ = expandedCell, let offset = lastCollectionViewOffset {
            scrollView.setContentOffset(offset, animated: false)
        }
    }
}

extension AnimeListViewController: AnimeElementDelegate {
    func animeElementCloseButtonDidTap(_ cell: AnimeElementCollectionViewCell) {
        collapseCurrentCell()
    }

    func animeElementDeleteButtonDidTap(_ cell: AnimeElementCollectionViewCell) {
        print("delete")
    }

    func animeElementShareButtonDidTap(_ cell: AnimeElementCollectionViewCell) {
        print("share")
    }
}

// MARK: - Private functions
extension AnimeListViewController {
    /// Collapse the current active ```expandedCell``` if exists.
    internal func collapseCurrentCell() {
        let animator = getAnimator()
        view.isUserInteractionEnabled = false

        if let selectedCell = expandedCell {
            animator.addAnimations { [weak self] in
                guard let aliveSelf = self else { return }
                selectedCell.collapse()
                for cell in aliveSelf.hiddenCells {
                    cell.show()
                }
                if let frame = aliveSelf.tabBarController?.tabBar.frame {
                    let y = frame.origin.y + (-frame.size.height)
                    aliveSelf.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                }
            }

            animator.addCompletion { [weak self] _ in
                self?.expandedCell = nil
                self?.hiddenCells.removeAll()
            }
        }

        animator.addCompletion { [weak self] _ in
            self?.view.isUserInteractionEnabled = true
        }

        animator.startAnimation()
    }

    /// Expand the desired cell and move out all the other ones.
    /// Also set the passed **selectedCell*** as current ```expandedCell```.
    internal func expand(selectedCell: ExpandableCell) {
        let animator = getAnimator()
        view.isUserInteractionEnabled = false

        let frameOfSelectedCell = selectedCell.frame

        expandedCell = selectedCell
        hiddenCells = collectionView.visibleCells.map { $0 as! ExpandableCell }.filter { $0 != selectedCell }

        animator.addAnimations { [weak self] in
            guard let aliveSelf = self else { return }
            selectedCell.expand(in: aliveSelf.collectionView)
            for cell in aliveSelf.hiddenCells {
                cell.hide(in: aliveSelf.collectionView, frameOfSelectedCell: frameOfSelectedCell)
            }
            if let frame = aliveSelf.tabBarController?.tabBar.frame {
                let y = frame.origin.y + (frame.size.height)
                aliveSelf.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
            }
        }

        animator.addCompletion { [weak self] _ in
            self?.view.isUserInteractionEnabled = true
        }

        animator.startAnimation()
    }

    /// Return an animator with correct configuration for expanding/collapsing animations.
    internal func getAnimator() -> UIViewPropertyAnimator {
        let dampingRatio: CGFloat = 0.8
        let initialVelocity: CGVector = CGVector.zero
        let springParameters: UISpringTimingParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
        let animator = UIViewPropertyAnimator(duration: 0.8, timingParameters: springParameters)
        return animator
    }
}
