//
//  ResultsViewController.swift
//  Clouds
//
//  Created by jhampac on 2/26/16.
//  Copyright © 2016 jhampac. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class ResultsViewController: UITableViewController
{
    var whistle: Whistle!
    var suggestions = [String]()
    
    var whistlePlayer: AVAudioPlayer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Genre: \(whistle.genre)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .Plain, target: self, action: "downloadTapped")
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let reference = CKReference(recordID: whistle.recordID, action: .DeleteSelf)
        let pred = NSPredicate(format: "owningWhistle == %@", argumentArray: [reference])
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: "Suggestions", predicate: pred)
        query.sortDescriptors = [sort]
        
        CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil) { [unowned self] (results, error) -> Void in
            
            guard error == nil else { print(error!.localizedDescription); return }
            
            if let results = results
            {
                self.parseResults(results)
            }
        }
    }
    
    // MARK: - VC Methods
    
    func addSuggestion(suggest: String)
    {
        let suggestionRecord = CKRecord(recordType: "Suggestions")
        let reference = CKReference(recordID: whistle.recordID, action: .DeleteSelf)
        suggestionRecord["text"] = suggest
        suggestionRecord["owningWhistle"] = reference
        
        // send to iCloud
        CKContainer.defaultContainer().publicCloudDatabase.saveRecord(suggestionRecord) { [unowned self] (record, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if error == nil
                {
                    self.suggestions.append(suggest)
                    self.tableView.reloadData()
                }
                else
                {
                    let ac = UIAlertController(title: "Error", message: "There was a problem submitting your suggestion: \(error!.localizedDescription)", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
    func parseResults(records: [CKRecord])
    {
        var newSuggestions = [String]()
        
        for record in records
        {
            newSuggestions.append(record["text"] as! String)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.suggestions = newSuggestions
            self.tableView.reloadData()
        }
    }
    
    func downloadTapped()
    {
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        else
        {
            // add one for the Add Suggestion row
            return max(1, suggestions.count + 1)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.section == 0
        {
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
            
            if whistle.comments.characters.count == 0
            {
                cell.textLabel?.text = "Comments: None"
            }
            else
            {
                cell.textLabel?.text = whistle.comments
            }
        }
        else
        {
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            
            if indexPath.row == suggestions.count
            {
                // That means this is the extra row we added; max(1, suggestions.count + 1)
                cell.textLabel?.text = "Add suggestion"
                cell.selectionStyle = .Gray
            }
            else
            {
                cell.textLabel?.text = suggestions[indexPath.row]
            }
        }
        
        return cell
    }
    
    // MARK: - Table view delegates
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 1
        {
            return "Suggested Songs"
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // Guard to check if its the last row
        guard indexPath.section == 1 && indexPath.row == suggestions.count else { return }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let ac = UIAlertController(title: "Suggest a song…", message: nil, preferredStyle: .Alert)
        var suggestion: UITextField!
        
        ac.addTextFieldWithConfigurationHandler { (textField) -> Void in
            suggestion = textField
            textField.autocorrectionType = .Yes
        }
        
        ac.addAction(UIAlertAction(title: "Submit", style: .Default) { (action) -> Void in
            if suggestion.text?.characters.count > 0
            {
                self.addSuggestion(suggestion.text!)
            }
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
}
