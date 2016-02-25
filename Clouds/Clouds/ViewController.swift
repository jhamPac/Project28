//
//  ViewController.swift
//  Clouds
//
//  Created by jhampac on 2/24/16.
//  Copyright © 2016 jhampac. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var tableView: UITableView!
    var whistles = [Whistle]()
    static var dirty = false
    
    // MARK: - VC LifeCyle
    
    override func loadView()
    {
        super.loadView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllCenterX, metrics: nil, views: ["tableView": tableView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[guide][tableView]|", options: .AlignAllCenterX, metrics: nil, views: ["guide": topLayoutGuide, "tableView": tableView]))
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "What is that hummm"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addWhistle")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .Plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if ViewController.dirty
        {
            loadWhistles()
        }
    }
    
    // MARK: - VC Methods
    
    func addWhistle()
    {
        let vc = RecordWhistleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadWhistles()
    {
        
    }
    
    func makeAttributedString(title title: String, subtitle: String) -> NSAttributedString
    {
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), NSForegroundColorAttributeName: UIColor.purpleColor()]
        let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        
        if subtitle.characters.count > 0 {
            let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
            titleString.appendAttributedString(subtitleString)
        }
        
        return titleString
    }
}

