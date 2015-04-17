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

    @IBOutlet var searchContainerView: UIVisualEffectView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var nextMeetingHintView: UIVisualEffectView!
    @IBOutlet var resultTableView: UITableView!
    
    var bytes: NSMutableData?
    
    var tableData = []
    var rooms: Array<Room> = []
    var filteredRooms: Array<Room> = []
    var selectedRoom: Room!
    
    var transition: RoomCardSegue!
    
    var keyboardSize: CGSize! = CGSize(width: 320.0, height: 253.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        var roomData = NSData(contentsOfURL: NSURL(string: "https://wayfinder.daneden.me/rooms.json")!)
        
        var roomJSON = NSJSONSerialization.JSONObjectWithData(roomData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSMutableArray
        
        
        for (object) in roomJSON {
            var roomDict = object as! Dictionary<String, AnyObject>
            
            var room = Room(json: roomDict)
            
            rooms.append(room)
            
        }
        
        resultTableView.contentInset.top = searchContainerView.frame.height
        resultTableView.scrollIndicatorInsets.top = searchContainerView.frame.height
        
        resultTableView.contentInset.bottom = nextMeetingHintView.frame.height
        resultTableView.scrollIndicatorInsets.bottom = nextMeetingHintView.frame.height
        
        
        self.resultTableView.registerClass(RoomTableViewCell.self, forCellReuseIdentifier: "roomCell")
        self.resultTableView.rowHeight = UITableViewAutomaticDimension;
        self.resultTableView.estimatedRowHeight = 74.0
        
        // Sort the array by name
        rooms.sort({ $0.name.uppercaseString < $1.name.uppercaseString })
        
        // Load the table data
        resultTableView.reloadData()

    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredRooms = self.rooms.filter({( room: Room) -> Bool in
            let stringAsArray = room.name.componentsSeparatedByString(" ")
            let stringMatch = room.name.rangeOfString("\\b" + searchText, options: NSStringCompareOptions.CaseInsensitiveSearch | NSStringCompareOptions.RegularExpressionSearch)
            return (stringMatch != nil)
        })
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    
    override func viewWillAppear(animated: Bool) {
        resultTableView.alpha = 0
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        if searchTextField.text == "" {
            resultTableView.alpha = 0
        } else {
            self.searchTextField.center.y = 60
            resultTableView.alpha = 1
        }
        
        nextMeetingHintView.frame.origin.y = view.frame.height - (nextMeetingHintView.frame.height + keyboardSize.height)
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        nextMeetingHintView.frame.origin.y = view.frame.height - nextMeetingHintView.frame.height
    }

    
    @IBAction func onSearchEdit(sender: AnyObject) {
        if searchTextField.text == "" {
            
            UIView.animateWithDuration(0.2, animations: {
                self.resultTableView.alpha = 0
            })
            
        } else {
            
            self.filterContentForSearchText(searchTextField.text)
            self.resultTableView.reloadData()
            
            UIView.animateWithDuration(0.2, animations: {
                self.resultTableView.alpha = 1
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTextField.text != "" {
            return self.filteredRooms.count
        } else {
            return rooms.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.resultTableView.dequeueReusableCellWithIdentifier("TheRoomCell") as! RoomTableViewCell
        var i: NSNumber = indexPath.row
        var theRoom: Room
        
        if searchTextField.text != "" {
            theRoom = filteredRooms[Int(i)] as Room
        } else {
            theRoom = rooms[Int(i)] as Room
        }
        
        cell.titleLabel.text = theRoom.name
        cell.descriptionLabel.text = Array(theRoom.landmarks).combine(",")
        cell.locationLabel.text = theRoom.floor
        cell.roomObject = theRoom
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! RoomTableViewCell
        
        selectedRoom = cell.roomObject
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("resultCellToCardSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var destinationVC = segue.destinationViewController as! RoomViewController
        
        destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationVC.room = selectedRoom
        
        transition = RoomCardSegue()
        transition.duration = 0.4
        
        destinationVC.transitioningDelegate = transition
    }

}
