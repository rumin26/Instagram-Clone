//
//  UsersViewController.swift
//  Instagram Clone
//
//  Created by Rumin on 12/5/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse
class UsersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tbl_users: UITableView!

    var arr_users = [""]
    var arr_userIds = [""]
    var arr_following = [""]
    
    var refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let user = PFUser()
        
        refresh()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh Users")
        refresher.addTarget(self, action: #selector(UsersViewController.refresh), for: .valueChanged)
        tbl_users.addSubview(refresher)
        
        let alert = UIAlertController(title: "", message: "Checkmark indicates 'following' users!", preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func refresh()
    {
        let query = PFQuery(className: "_User")
        if let username = PFUser.current()?.username
        {
            query.whereKey("username", notEqualTo:username)
            
            query.findObjectsInBackground { (objects, error) in
                
                if objects != nil
                {
                    self.arr_users.removeAll()
                    self.arr_userIds.removeAll()
                    self.arr_following.removeAll()
                    
                    for users in objects!
                    {
                        self.arr_users.append(users.object(forKey: "username") as! String)
                        self.arr_userIds.append(users.objectId!)
                    }
                    
                    //self.tbl_users.reloadData()
                }
                
                let followingQuery = PFQuery(className: "Followers")
                followingQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
                followingQuery.findObjectsInBackground { (followingObjects, error) in
                    
                    if followingObjects != nil
                    {
                        for followingUsers in followingObjects!
                        {
                            self.arr_following.append(followingUsers["following"] as! String)
                            
                        }
                        self.refresher.endRefreshing()
                        self.tbl_users.reloadData()
                    }
                    
                }
                
                
            }
        }
        
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return arr_users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = arr_users[indexPath.row]
        
            for followingUser in arr_following
            {
                if arr_userIds[indexPath.row] == followingUser
                {
                    cell.accessoryType = .checkmark
                }
            }

        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark
        {
            cell?.accessoryType = .none
            let query = PFQuery(className: "Followers")
            query.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
            query.whereKey("following", equalTo: arr_userIds[indexPath.row])
            
            query.getFirstObjectInBackground(block: { (object, error) in
                
                if let following = object
                {
                    following.deleteInBackground()
                }
            })
        }
        else
        {
            cell?.accessoryType = .checkmark
            let object = PFObject(className: "Followers")
            object["follower"] = PFUser.current()?.objectId
            object["following"] = arr_userIds[indexPath.row]
            
            object.saveInBackground()
            
        }
        
    }
    @IBAction func logoutBtnPressed(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if error != nil
            {
                let usererror = error! as NSError
                let alert = UIAlertController(title: "Error", message: usererror.userInfo["error"] as? String, preferredStyle: .alert)
                alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                
             self.present(alert, animated: true, completion: nil)
                
            }
            
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
}
