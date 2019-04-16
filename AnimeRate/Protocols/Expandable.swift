//
//  Expandable.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import UIKit

protocol Expandable {
    func collapse()
    func expand(in collectionView: UICollectionView)
}
