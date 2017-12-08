//
//  SignUpViewController.swift
//  Instagram Clone
//
//  Created by Rumin on 12/1/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtfield_email: UITextField!
    @IBOutlet weak var txtfield_password: UITextField!
    @IBOutlet weak var txtfield_username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signupBtnPressed(_ sender: Any) {
        if txtfield_username.text == "" || txtfield_password.text == "" || txtfield_email.text == ""
        {
            let alert = UIAlertController(title: "Error", message: "Please enter your details !!", preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let user = PFUser()
            user.username = txtfield_username.text
            user.email = txtfield_email.text
            user.password = txtfield_password.text
        
            user.signUpInBackground { (success, error) in
                if success
                {
                    self.performSegue(withIdentifier: "showUsersAfterSignUp", sender: nil)
                }
                else
                {
                    let errorMsg = error! as NSError
                
                    let alert = UIAlertController(title: "Error", message: errorMsg.userInfo["error"] as? String, preferredStyle: .alert)
                    alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                    
                        self.dismiss(animated: true, completion: nil)
                    
                    }))
                    self.present(alert, animated: true, completion: nil)
                
                }
            }
        }
    }
}
