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
        
        self.tableView.separatorColor = .none
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
        ///let cell = MemeTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tableviewcell2")
        
        let meme = memes[indexPath.row]
        
        
        cell.textLabel?.text = "\(meme.topText)...\(meme.buttomText)"
        
        ///
//        func saveImage() {
//            let bottomImage = UIImage(named: "bottom")!
//            let topImage = UIImage(named: "top")!
//            
//            let newSize = CGSizeMake(100, 100) // set this to what you need
//            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//            
//            bottomImage.drawInRect(CGRect(origin: CGPointZero, size: newSize))
//            topImage.drawInRect(CGRect(origin: CGPointZero, size: newSize))
//            
//            let newImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//        }
        ///
        
        
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
        
        print(view.frame.width)
        print(view.frame.height)
        
        let iconLength = min(view.frame.size.width,view.frame.size.height)/3.0
        
        let newSize = CGSize(width: iconLength, height: iconLength)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        meme.originImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let top = CGRect(x: 0, y: 0, width: iconLength, height: 20)
        let buttom = CGRect(x: 0, y: iconLength-20, width: iconLength, height: 20)
        (meme.topText as NSString).draw(in: top , withAttributes: memeTextAttributtes)
        (meme.buttomText as NSString).draw(in: buttom, withAttributes: memeTextAttributtes)
        
        //(in: CGPoint.zero, withAttributes: MemeEditorViewController.memeTextAttributtes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        cell.imageView?.image = newImage
        
//        ///cell.imageView?.image = meme.memedImage
//        ///cell.imageView?.contentMode = .scaleAspectFit
//        ///textField.defaultTextAttributes = memeTextAttributtes
//        
//        func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
//            
//            ///let textColor = UIColor.white
//            ///let textFont = UIFont(name: "Helvetica Bold", size: 12)!
//            
//            let scale = UIScreen.main.scale
//            UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
//            
//            ///let textFontAttributes = [
//            ///    NSFontAttributeName: textFont,
//            ///    NSForegroundColorAttributeName: textColor,
//            ///    ] as [String : Any]
//            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
//            
//            let rect = CGRect(origin: point, size: image.size)
//            ///text.draw(in: rect, withAttributes: textFontAttributes)
//            text.draw(in: rect, withAttributes: MemeEditorViewController.memeTextAttributtes)
//            
//            let newImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            return newImage!
//        }
//        
//        let img1 = textToImage(drawText: "000", inImage: meme.originImage, atPoint: CGPoint(x: 200, y: 50))
//        //let img2 = textToImage(drawText: "111", inImage: img1, atPoint: CGPoint(x: 20, y: 60))
//        
//        cell.imageView?.image = img1
        
//        //
//        // Set up a collection View Flow Layout
//        
//        let space:CGFloat = 3.0
//        let dimension = (view.frame.size.width - (2*space))/3.0
//        
//        let itemSize = CGSize(width: dimension, height: dimension)
//        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
//        let imageRect = CGRect(x: 0.0, y: 0.0, width: dimension, height: dimension)
//        cell.imageView?.image!.draw(in: imageRect)
//        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        //flowLayout.itemSize = CGSize(width: dimension, height: dimension)
//        //
//        let space:CGFloat = 3.0
//        let dimension = (view.frame.size.width - (2*space))/3.0
//        cell.imageView?.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
