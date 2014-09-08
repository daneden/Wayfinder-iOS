//
//  SearchViewController.swift
//  Wayfinder
//
//  Created by Daniel Eden on 07/09/2014.
//  Copyright (c) 2014 Daniel Eden. All rights reserved.
//

import UIKit

class SearchViewController: ViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var nextMeetingHintView: UIVisualEffectView!
    
    var transition: RoomCardSegue!
    
    var keyboardSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size
        
        if searchTextField.text == nil {
            searchTextField.center.y = 40
        } else {
            searchTextField.center.y = CGFloat(self.view.center.y - CGFloat(keyboardSize.height/2.0))
        }
        
        nextMeetingHintView.frame.origin.y = view.frame.height - (nextMeetingHintView.frame.height + keyboardSize.height)
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        nextMeetingHintView.frame.origin.y = view.frame.height - nextMeetingHintView.frame.height
    }

    
    @IBAction func onSearchEdit(sender: AnyObject) {
        if searchTextField.text == "" {
            UIView.animateWithDuration(0.2, animations: {
                self.searchTextField.center.y = CGFloat(self.view.center.y - CGFloat(self.keyboardSize.height/2.0))
                }, completion: { (finished: Bool) -> Void in
                
            })
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.searchTextField.center.y = 60
                }, completion: { (finished: Bool) -> Void in
                
            })
        }
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
