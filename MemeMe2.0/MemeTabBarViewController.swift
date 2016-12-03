//
//  MemeTabBarViewController.swift
//  MemeMe2.0
//
//  Created by EricTsui on 25/11/16.
//  Copyright © 2016 EricTsui. All rights reserved.
//

import UIKit

class MemeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("AAA")
        // Do any additional setup after loading the view.
        
        // configure Navigation Item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MemeCollectionViewController.startMemeEditor))
        print("BBBB")
    }
    
    func startMemeEditor() {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
}
