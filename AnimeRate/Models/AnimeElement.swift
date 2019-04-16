//
//  AnimeElement.swift
//  AnimeRate
//
//  Created by Alessio Boerio on 16/04/2019.
//  Copyright © 2019 zapideas. All rights reserved.
//

import Foundation

class AnimeElement {
    var id: Int
    var name: String
    var scoreAttributesDictionary: [String: Float]
    var imageUrlString: String?
    var streamingUrlString: String?

    init(id: Int, name: String, drawings: Float, story: Float, characters: Float, musics: Float, end: Float,
         imageUrlString: String?, streamingUrlString: String?) {
        self.id = id
        self.name = name
        self.scoreAttributesDictionary = [:]
        self.scoreAttributesDictionary[ScoreAttribute.drawings.title] = drawings
        self.scoreAttributesDictionary[ScoreAttribute.story.title] = story
        self.scoreAttributesDictionary[ScoreAttribute.characters.title] = characters
        self.scoreAttributesDictionary[ScoreAttribute.musics.title] = musics
        self.scoreAttributesDictionary[ScoreAttribute.end.title] = end
        self.imageUrlString = imageUrlString
        self.streamingUrlString = streamingUrlString
    }
}
