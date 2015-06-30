//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Lakshmi Vineeth on 6/24/15.
//  Copyright (c) 2015 Lakshmi. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var memes: [Meme]!
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes

        self.collectionView?.reloadData()

    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! collectioViewCell
        
        let meme = memes[indexPath.item]
    
        
        collectionCell.layer.borderColor = UIColor.blackColor().CGColor
        collectionCell.layer.borderWidth = 2
       
        collectionCell.imageView.image = meme.memeImage

        return collectionCell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
        detailViewController.meme = self.memes[indexPath.item]
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let meme = memes[indexPath.item]
        
        let width = meme.image.size.width
        let height = meme.image.size.height

        if (width > height) {
            return CGSize(width: 150, height: 100)
        }
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
