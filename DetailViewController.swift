//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Lakshmi Vineeth on 6/24/15.
//  Copyright (c) 2015 Lakshmi. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    var meme : Meme!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        imageView.image = meme.memeImage
    }
    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        self.removeMeme()
        self.backToSentMemes()
    }
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        if let navigationController = self.navigationController {
            let rootVC = navigationController.viewControllers[0] as! EditorViewController
            rootVC.meme = meme
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
    
    func backToSentMemes() {
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }
    }
    
    func removeMeme(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var memes = appDelegate.memes

        let index = meme.indexOf(self.meme, memes: memes)
        
        memes.removeAtIndex(index)
        
        appDelegate.memes = memes
        
    }
}
