//
//  MemeCollectionViewController.swift
//  MemeMe2.0
//
//  Created by EricTsui on 24/11/16.
//  Copyright © 2016 EricTsui. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    //MARK : Properties
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme]!
    
    //MARK : Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure Navigation Item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self,
            action: #selector(MemeCollectionViewController.startMemeEditor))
        
        // Set up a collection View Flow Layout
        // and, min(frame.width, frame.height) to adapte in both landscape and portrait
        let space:CGFloat = 3.0
        let dimension = (min(view.frame.size.width,view.frame.size.height) - (2*space))/3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Get memes data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        //Update Model
        //To make sure the Meme is synced to latest data model in appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        //Update View
        //Reload Collection View with updated data model
        //Thus, the UICollectionViewCell will always be re-populated by calling
        //override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell 
        //Otherwise, the UICollectionViewCell will only display the cached view ? (not always re-populated)
        self.collectionView?.reloadData()
        
    }
    
    func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        self.present(memeEditorVC, animated: true, completion: nil)
        memeEditorVC.isFromOtherViewController = true
    }
    
    //MARK : Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
