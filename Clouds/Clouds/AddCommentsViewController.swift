//
//  AddCommentsViewController.swift
//  Clouds
//
//  Created by jhampac on 2/25/16.
//  Copyright © 2016 jhampac. All rights reserved.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextViewDelegate
{
    var genre: String!
    var comments: UITextView!
    let placeHolder = "Place additional helping hints here"
    
    override func loadView()
    {
        comments = UITextView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.delegate = self
        comments.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        view.addSubview(comments)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[comments]|", options: .AlignAllCenterX, metrics: nil, views: ["comments": comments]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[comments]|", options: .AlignAllCenterX, metrics: nil, views: ["comments": comments]))
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submitTapped")
        comments.text = placeHolder
    }
    
    func submitTapped()
    {
        let vc = SubmitViewController()
        vc.genre = genre
        
        if comments.text == placeHolder
        {
            vc.comments = ""
        }
        else
        {
            vc.comments = comments.text
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITextView Callbacks
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.text == placeHolder
        {
            textView.text = ""
        }
    }
}
