//
//  SignInViewController.swift
//  CapitalOne
//
//  Created by Chase McCarty on 2015-08-23.
//  Copyright (c) 2015 Chase McCarty. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = getSavedPlayer() as? User {
            usernameView.text = user.username
            passwordView.text = user.password
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveUser"{
            if rememberMeSwitch.on == true {
                savePlayer(usernameView.text, passwordView.text)
            } else {
                deletePlayers()
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
