//
//  PostImageViewController.swift
//  Instagram Clone
//
//  Created by Rumin on 12/6/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var txtfield_imageDescription: UITextField!
    @IBOutlet weak var imgView: UIImageView!

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
    @IBAction func chooseImageBtnPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage]
        imgView.image = image as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func logoutBtnPressed(_ sender: Any) {
        
        PFUser.logOutInBackground { (error) in
            
            if error == nil
            {
                self.navigationController?.popToRootViewController(animated: true)
            }
            else
            {
                let error = error! as NSError
                let alert = UIAlertController(title: "Error", message: error.userInfo["error"] as? String, preferredStyle: .alert)
                alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func postImageBtnPressed(_ sender: Any) {
        
        let defaultImage = UIImage(named: "person.png")
        let data = UIImageJPEGRepresentation(defaultImage!, 1.0)
        let imageViewData = UIImageJPEGRepresentation(imgView.image!, 1.0)
        
        if imageViewData != data
        {
            let object = PFObject(className: "Posts")
            object["imageDescription"] = txtfield_imageDescription.text
            object["userId"] = PFUser.current()?.objectId
            object["username"] = PFUser.current()?.username
            
            let imageData = UIImageJPEGRepresentation(imgView.image!, 1.0)
            let file = PFFile(name: "image.png", data: imageData!)
            
            object["imageFile"] = file
        
            object.saveInBackground(block: { (success, error) in
                
                if success
                {
                    self.imgView.image = UIImage(named: "person.png")
                    self.txtfield_imageDescription.text = ""
                    
                    let alert = UIAlertController(title: "Successful", message: "Image Posted Successfully", preferredStyle: .alert)
                    alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                        
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let error = error! as NSError
                    let alert = UIAlertController(title: "Error", message: error.userInfo["error"] as? String, preferredStyle: .alert)
                    alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
            
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please Choose an image to post!!", preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
}
