//
//  RecordWhistleViewController.swift
//  Clouds
//
//  Created by jhampac on 2/25/16.
//  Copyright © 2016 jhampac. All rights reserved.
//

import UIKit
import AVFoundation

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate
{
    var stackView: UIStackView!
    var recordButton: UIButton!
    var playButton: UIButton!
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    var whistlePlayer: AVAudioPlayer!
    
    // MARK: - VC LifeCyle
    
    override func loadView()
    {
        super.loadView()
        
        view.backgroundColor = UIColor.grayColor()
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .FillEqually
        stackView.alignment = .Center
        stackView.axis = .Vertical
        view.addSubview(stackView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant:0))
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Start Recording"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .Plain, target: nil, action: nil)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do
        {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed
                    {
                        self.loadRecordingUI()
                    }
                    else
                    {
                        self.loadFailUI()
                    }
                }
            }
        }
        catch
        {
            self.loadFailUI()
        }
    }
    
    // MARK: - Class Methods
    
    class func getPathToAudioFile() -> NSURL
    {
        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let path = documentsUrl.URLByAppendingPathComponent("whistle.m4a")
        return path
    }
    
    // MARK: - VC Methods
    
    func loadRecordingUI()
    {
        recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("Tap to Record", forState: .Normal)
        recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        recordButton.addTarget(self, action: "recordTapped", forControlEvents: .TouchUpInside)
        stackView.addArrangedSubview(recordButton)
        
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Tap to Play", forState: .Normal)
        playButton.hidden = true
        playButton.alpha = 0
        playButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        playButton.addTarget(self, action: "playTapped", forControlEvents: .TouchUpInside)
        stackView.addArrangedSubview(playButton)
    }
    
    func loadFailUI()
    {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        failLabel.text = "Recording failed: Permissions"
        failLabel.numberOfLines = 0
        stackView.addArrangedSubview(failLabel)
    }
    
    func recordTapped()
    {
        if whistleRecorder == nil
        {
            startRecording()
            
            // if playbutton hidden is false; then hide it
            if !playButton.hidden
            {
                UIView.animateWithDuration(0.35) { [unowned self] in
                    self.playButton.hidden = true
                    self.playButton.alpha = 0
                }
            }
        }
        else
        {
            finishRecording(success: true)
        }
    }
    
    func playTapped()
    {
        let audioURL = RecordWhistleViewController.getPathToAudioFile()
        
        do
        {
            whistlePlayer = try AVAudioPlayer(contentsOfURL: audioURL)
            whistlePlayer.play()
        }
        catch
        {
            let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func nextTapped()
    {
        let vc = SelectGenreViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func startRecording()
    {
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        
        recordButton.setTitle("Tap to Stop", forState: .Normal)
        
        let audioURL = RecordWhistleViewController.getPathToAudioFile()
        print(audioURL.absoluteString)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do
        {
            whistleRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        }
        catch
        {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success success: Bool)
    {
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        whistleRecorder.stop()
        whistleRecorder = nil
        
        if success
        {
            recordButton.setTitle("Tap to Re-record", forState: .Normal)
            
            if playButton.hidden
            {
                UIView.animateWithDuration(0.35) { [unowned self] in
                    self.playButton.hidden = false
                    self.playButton.alpha = 1
                }
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextTapped")
        }
        else
        {
            recordButton.setTitle("Tap to Record", forState: .Normal)
            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    // MARK: - AVRecorder Callbacks
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishRecording(success: false)
        }
    }
}
