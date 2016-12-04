//
//  memeTextFieldDelegate.swift
//  MemeMe2.0
//
//  Created by EricTsui on 7/11/16.
//  Copyright © 2016 EricTsui. All rights reserved.
//

import Foundation
import UIKit

class memeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clear out the text fileds only in case of default text,
        //Not for any of the user's input
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
