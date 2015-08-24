//
//  SignInViewController.swift
//  CapitalOne
//
//  Created by Chase McCarty on 2015-08-23.
//  Copyright (c) 2015 Chase McCarty. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = getSavedPlayer() as? User {
            usernameView.text = user.username
            passwordView.text = user.password
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Dispatched when "save user" is clicked
    //Should send the creds back to the first view. and optionally save them for reuse
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveUser"{
            if rememberMeSwitch.on == true {
                savePlayer(usernameView.text, passwordView.text)
            } else {
                deletePlayers()
            }
        }
        
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("Text Field thing called")
        if textField == usernameView && usernameView.text != "" {
            passwordView.becomeFirstResponder()
        } else if textField == passwordView && usernameView.text != "" && passwordView.text != "" {
            self.performSegueWithIdentifier("SaveUser", sender: self)
        }
        
        return true
    }
    
    //Close the keyboard nomatter who has it.
    @IBAction func resignKeyboard(sender: AnyObject) {
        println("Resign Keyboard")
        //A little cooler and more maintainable than the bruteforce method
        for view in self.view.subviews as! [UIView] {
            if let textField = view as? UITextField {
                textField.resignFirstResponder()
            }
        }
    }
    
}
