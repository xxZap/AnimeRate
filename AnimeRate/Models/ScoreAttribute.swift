//
//  ScoreAttribute.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import Foundation
import UIKit

enum ScoreAttribute {
    case drawings
    case story
    case characters
    case musics
    case end

    func getColor(forScore score: Float) -> UIColor {
        switch score {
        case 0..<6:
            return #colorLiteral(red: 0.9882352941, green: 0.2196078431, blue: 0.1725490196, alpha: 1)
        case 6..<6.5:
            return #colorLiteral(red: 0.9411764706, green: 0.5019607843, blue: 0.03529411765, alpha: 1)
        case 6.5..<7:
            return #colorLiteral(red: 0.8470588235, green: 0.7882352941, blue: 0.03921568627, alpha: 1)
        case 7..<8:
            return #colorLiteral(red: 0.5529411765, green: 0.9254901961, blue: 0.007843137255, alpha: 1)
        case 8..<9:
            return #colorLiteral(red: 0.3058823529, green: 0.662745098, blue: 0.003921568627, alpha: 1)
        case 9...10:
            return #colorLiteral(red: 0.1411764706, green: 0.5568627451, blue: 0.5450980392, alpha: 1)
        default:
            return #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        }
    }

    var title: String {
        switch self {
        case .drawings:     return "Drawings"
        case .story:        return "Story"
        case .characters:   return "Characters"
        case .musics:       return "Musics"
        case .end:          return "End"
        }
    }
}
