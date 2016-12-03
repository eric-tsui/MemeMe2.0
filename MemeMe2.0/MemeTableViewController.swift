//
//  MemeTableViewController.swift
//  MemeMe2.0
//
//  Created by EricTsui on 24/11/16.
//  Copyright © 2016 EricTsui. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme]!
    
    //MARK : Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure Navigation Item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MemeCollectionViewController.startMemeEditor))
        
        // Get memes data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
    }
    
    func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        self.present(memeEditorVC, animated: true, completion: nil)
        memeEditorVC.isFromOtherViewController = true
    }
    
    //MARK : Table View Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!

        let meme = memes[indexPath.row]
        
        
        cell.textLabel?.text = "\(meme.topText)...\(meme.buttomText)"
        
        //Create image Icon in tableViewCell Begin...
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byTruncatingMiddle
        
        let memeTextAttributtes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
            NSStrokeWidthAttributeName: -3.0,
            NSParagraphStyleAttributeName: style
            ] as [String : Any]
        
        let iconLength = min(view.frame.size.width,view.frame.size.height)/3.0
        let newSize = CGSize(width: iconLength, height: iconLength)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        meme.originImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let top = CGRect(x: 0, y: 0, width: iconLength, height: 20)
        let buttom = CGRect(x: 0, y: iconLength-20, width: iconLength, height: 20)
        (meme.topText as NSString).draw(in: top , withAttributes: memeTextAttributtes)
        (meme.buttomText as NSString).draw(in: buttom, withAttributes: memeTextAttributtes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Create image Icon in tableViewCell End.
        
        cell.imageView?.image = newImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Remove data in local meme
            memes.remove(at: indexPath.row)
            
            // Remove data in appDelegate to sync it
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            
            // Update UI
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
