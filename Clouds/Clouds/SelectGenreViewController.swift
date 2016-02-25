//
//  SelectGenreViewController.swift
//  Clouds
//
//  Created by jhampac on 2/25/16.
//  Copyright © 2016 jhampac. All rights reserved.
//

import UIKit

class SelectGenreViewController: UITableViewController
{
    static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz", "Metal", "Pop", "Reggae", "RnB", "Rock", "Soul"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Select Genre"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Genre", style: .Plain, target: nil, action: nil)
        
        // Register a generic UITableViewCell and tag the identifier to Cell; no particular class xib
        tableView.registerClass(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return SelectGenreViewController.genres.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Use this when you register a Cell; if in storyboard it does this for you
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = SelectGenreViewController.genres[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    // MARK: - TableView Delegate Callbacks
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath)
        {
            let genre = cell.textLabel?.text ?? SelectGenreViewController.genres[0]
            let vc = AddCommentsViewController()
            vc.genre = genre
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
