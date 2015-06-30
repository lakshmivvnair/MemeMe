//
//  TableViewController.swift
//  MemeMe
//
//  Created by Lakshmi Vineeth on 6/24/15.
//  Copyright (c) 2015 Lakshmi. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UITableViewController {
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 111.0
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! tableViewCell
        
        let meme = memes[indexPath.item]
        
        
        let width = meme.image.size.width
        let height = meme.image.size.height
        
        if (width > height) {
//            tableCell.cellImageView?.frame.size = CGSize(width: 150, height: 100)
            tableCell.cellImageView.contentMode = UIViewContentMode.ScaleAspectFill
        } else {
//            tableCell.cellImageView?.frame.size = CGSize(width: 100, height: 150)
            tableCell.cellImageView.contentMode = UIViewContentMode.ScaleToFill
        }
        
        tableCell.cellImageView.layer.borderColor = UIColor.blackColor().CGColor
        tableCell.cellImageView.layer.borderWidth = 2.0
        tableCell.cellImageView.image = meme.memeImage
            
        tableCell.topBottomText.text = "\(meme.topText) \(meme.bottomText)"
        
        return tableCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !memes.isEmpty {
            
            let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
            detailViewController.meme = self.memes[indexPath.item]
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(detailViewController, animated: true)
            }
        }
    }

}
