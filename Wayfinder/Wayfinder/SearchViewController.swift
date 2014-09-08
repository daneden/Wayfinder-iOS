//
//  SearchViewController.swift
//  Wayfinder
//
//  Created by Daniel Eden on 07/09/2014.
//  Copyright (c) 2014 Daniel Eden. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: ViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var nextMeetingHintView: UIVisualEffectView!
    @IBOutlet var resultTableView: UITableView!
    
    var bytes: NSMutableData?
    
    var tableData = []
    
    var transition: RoomCardSegue!
    
    var keyboardSize: CGSize!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        var roomData = NSData(contentsOfURL: NSURL(string: "https://wayfinder.daneden.me/rooms.json"))
        
        println(roomData.length)
        
//        var roomJSON = NSJSONSerialization.JSONObjectWithData(roomData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
        
//        println(roomJSON.count)
        
        
        self.resultTableView.registerClass(RoomTableViewCell.self, forCellReuseIdentifier: "roomCell")
        resultTableView.reloadData()

    }

    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size
        
        onSearchEdit(searchTextField)
        
        nextMeetingHintView.frame.origin.y = view.frame.height - (nextMeetingHintView.frame.height + keyboardSize.height)
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        nextMeetingHintView.frame.origin.y = view.frame.height - nextMeetingHintView.frame.height
    }

    
    @IBAction func onSearchEdit(sender: AnyObject) {
        if searchTextField.text == "" {
            UIView.animateWithDuration(0.2, animations: {
                self.searchTextField.center.y = CGFloat(self.view.center.y - CGFloat(self.keyboardSize.height/2.0))
                self.resultTableView.frame.origin.y = self.view.frame.height
                self.resultTableView.alpha = 0
                }, completion: { (finished: Bool) -> Void in
                
            })
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.searchTextField.center.y = 60
                self.resultTableView.frame.origin.y = 86
                self.resultTableView.alpha = 1
                }, completion: { (finished: Bool) -> Void in
                
            })
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
//        return myObject.count
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = self.resultTableView.dequeueReusableCellWithIdentifier("TheRoomCell") as RoomTableViewCell
        
//        var tmpDict: NSDictionary = myObject[indexPath.row] as NSDictionary
//        let text = tmpDict.objectForKeyedSubscript(roomName) as String
//        let detail = tmpDict.objectForKeyedSubscript(roomLandmarks) as String

//        cell.titleLabel.text = text
////        cell.detailTextLabel.text = detail
//        cell.descriptionLabel.text = detail
        cell.locationLabel.text = "Some string"
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var destinationVC = segue.destinationViewController as UIViewController
        
        destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        transition = RoomCardSegue()
        transition.duration = 0.4
        
        destinationVC.transitioningDelegate = transition
    }

}
