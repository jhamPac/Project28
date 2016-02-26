//
//  SubmitViewController.swift
//  Clouds
//
//  Created by jhampac on 2/25/16.
//  Copyright © 2016 jhampac. All rights reserved.
//

import UIKit
import CloudKit

class SubmitViewController: UIViewController
{
    var genre: String!
    var comments: String!
    
    var stackView: UIStackView!
    var status: UILabel!
    var spinner: UIActivityIndicatorView!
    
    override func loadView()
    {
        view.backgroundColor = UIColor.grayColor()
        
        // Stack View Config
        stackView = UIStackView()
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .FillEqually
        stackView.alignment = .Center
        stackView.axis = .Vertical
        view.addSubview(stackView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant:0))
        
        // Status Label Config
        status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Submitting..."
        status.textColor = UIColor.whiteColor()
        status.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        status.numberOfLines = 0
        status.textAlignment = .Center
        
        // Spinner Config
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        stackView.addArrangedSubview(status)
        stackView.addArrangedSubview(spinner)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Sending to the Cloud"
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        doSubmission()
    }
    
    func doSubmission()
    {
        
        // RecordType is like table in a database
        let whistleRecord = CKRecord(recordType: "Whistles")
        whistleRecord["genre"] = genre
        whistleRecord["comments"] = comments
        
        let audioURL = RecordWhistleViewController.getPathToAudioFile()
        let whistleAsset = CKAsset(fileURL: audioURL)
        whistleRecord["audio"] = whistleAsset
        
        CKContainer.defaultContainer().publicCloudDatabase.saveRecord(whistleRecord) { [unowned self] (record, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if error == nil
                {
                    self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
                    self.status.text = "All Done"
                    self.spinner.stopAnimating()
                    
                    ViewController.needsRefresh = true
                }
                else
                {
                    self.status.text = "Error: \(error!.localizedDescription)"
                    self.spinner.stopAnimating()
                }
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneTapped")
            }
        }
    }
    
    func doneTapped()
    {
        // If you are deep into the Nav Stack and want to pop back to the first one
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
