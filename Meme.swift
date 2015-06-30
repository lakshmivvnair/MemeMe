//
//  Meme.swift
//  MemeMe
//
//  Created by Lakshmi Vineeth on 6/23/15.
//  Copyright (c) 2015 Lakshmi. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText : String
    var bottomText : String
    var image : UIImage
    var memeImage : UIImage
    
    init(topText : String, bottomText : String, image : UIImage, memeImage : UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memeImage = memeImage
    }
    
    func indexOf(meme : Meme, memes : [Meme]) -> Int {
        var memeIndex : Int
        memeIndex = -1
        
        for m in memes {
            if (meme.memeImage == m.memeImage && meme.image == m.image) {
                memeIndex += 1
                break
            }
            memeIndex += 1
        }
        return memeIndex
    }
}
