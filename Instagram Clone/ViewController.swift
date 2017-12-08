//
//  ViewController.swift
//  Instagram Clone
//
//  Created by Rumin on 12/1/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var txtfield_username: UITextField!
    @IBOutlet weak var txtfield_password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if PFUser.current() != nil
        {
            self.performSegue(withIdentifier: "showUsersAfterLogin", sender: nil)
        }
    }

    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if txtfield_username.text == "" || txtfield_password.text == ""
        {
            let alert = UIAlertController(title: "Error", message: "Please enter username and password !!", preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            PFUser.logInWithUsername(inBackground: txtfield_username.text!, password: txtfield_password.text!) { (user, error) in
        
                if error != nil
                {
                    let errorMsg = error! as NSError
                    let alert = UIAlertController(title: "Error", message: errorMsg.userInfo["error"] as? String, preferredStyle: .alert)
                    alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                    
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            
                else
                {
                    //print("logged In")
                    self.performSegue(withIdentifier: "showUsersAfterLogin", sender: nil)
                }
            
            }
        }
        
        
    }
}

