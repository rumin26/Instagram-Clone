//
//  FeedsTableViewController.swift
//  Instagram Clone
//
//  Created by Rumin on 12/6/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse

class FeedsTableViewController: UITableViewController {

    @IBOutlet var tbl_feeds: UITableView!
    var arr_username = [""]
    var arr_imageDescription = [""]
    var arr_images = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className: "Followers")
        query.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
        
        query.findObjectsInBackground (block: { (objects, error) in
            self.arr_username.removeAll()
            self.arr_images.removeAll()
            self.arr_imageDescription.removeAll()
            
            if objects != nil
            {
                for following in objects!
                {
                    //print(following)
                    let query = PFQuery(className: "Posts")
                    query.whereKey("userId", equalTo: following.object(forKey: "following")!)
                    query.findObjectsInBackground(block: { (posts, error) in
                        
                        if posts != nil
                        {
                            for userPost in posts!
                            {
                                self.arr_imageDescription.append(userPost["imageDescription"] as! String)
                                self.arr_images.append(userPost["imageFile"] as! PFFile)
                                self.arr_username.append(userPost["username"] as! String)
                                
                            }
                            self.tbl_feeds.reloadData()
                        }
                        
                    })
                }
                
            }
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr_username.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedsTableViewCell

        
        if arr_images.count > 0
        {
            print(arr_images[indexPath.row])
            arr_images[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data
            {
                if let image = UIImage(data: imageData)
                {
                    cell.imgView_uploadedImage.image = image
                }
            }
            
            }
        }
        
        cell.lbl_imageDescription.text = arr_imageDescription[indexPath.row]
        cell.lbl_username.text = arr_username[indexPath.row]
        // Configure the cell...

        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
