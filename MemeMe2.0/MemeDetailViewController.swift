//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by EricTsui on 25/11/16.
//  Copyright © 2016 EricTsui. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties

    var meme: Meme!
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure Navigation Item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(MemeDetailViewController.startMemeEditor))

        self.tabBarController?.tabBar.isHidden = true
        
        imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        self.present(memeEditorVC, animated: true, completion: nil)
        
        memeEditorVC.topTextField.text         = meme.topText
        memeEditorVC.buttomTextField.text      = meme.buttomText
        memeEditorVC.imagePickerView.image     = meme.originImage
        memeEditorVC.isFromOtherViewController = true
    }
    
}
