//
//  RoomViewController.swift
//  Wayfinder
//
//  Created by Daniel Eden on 07/09/2014.
//  Copyright (c) 2014 Daniel Eden. All rights reserved.
//

import UIKit
import MapKit

class RoomViewController: ViewController, MKMapViewDelegate {

    var cardInitialCenter: CGPoint!
    var transformation: CGAffineTransform!
    

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSizeMake(0, 10)
        view.layer.shadowRadius = 10
        view.clipsToBounds = true
        
        cardInitialCenter = view.center
        view.transform = CGAffineTransformMakeScale(0.9, 0.9)
        transformation = view.transform
        
        mapView.showsUserLocation = true
        
        // This will eventually add a nice inner shadow to the whole card, but for some reason it's not working.
//        var layerWidth = view.frame.width - 2 as CGFloat
//        var layerHeight = view.frame.height - 2 as CGFloat
//        var shadowLayer = UIView(frame: CGRect(x: 100, y: 100, width: layerWidth, height: layerHeight))
//        shadowLayer.layer.cornerRadius = 5
//        shadowLayer.layer.shadowColor = UIColor.redColor().CGColor
//        shadowLayer.layer.shadowOpacity = 0.9
//        shadowLayer.layer.shadowOffset = CGSizeMake(0, 10)
//        shadowLayer.layer.shadowRadius = 1
//        shadowLayer.userInteractionEnabled = false
//        
//        view.addSubview(shadowLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCardPan(gesture: UIPanGestureRecognizer) {
        var translation = gesture.translationInView(view)
        var location = gesture.locationInView(view)
        
        var rotation = translation.x / 10 * CGFloat(M_PI / 180)
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            if location.y > cardInitialCenter.y {
                rotation = -rotation
            }
            
        } else if gesture.state == UIGestureRecognizerState.Changed {
            
            self.view.center.y = cardInitialCenter.y + translation.y
            self.view.center.x = cardInitialCenter.x + translation.x
            
            self.view.transform = CGAffineTransformRotate(transformation, rotation)
            
        } else if gesture.state == UIGestureRecognizerState.Ended {
            
            if translation.x > 50 {
                UIView.animateWithDuration(0.2, animations: {
                    self.view.center.x += self.view.frame.width
                    }, completion: { (finished: Bool) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                
            } else if translation.x < -50 {
                UIView.animateWithDuration(0.2, animations: {
                    self.view.center.x -= self.view.frame.width
                    }, completion: { (finished: Bool) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                })
                
            } else {
                UIView.animateWithDuration(0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 4,
                    options: nil,
                    animations: {
                    self.view.center = self.cardInitialCenter
                    self.view.transform = self.transformation
                }, completion: nil)
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
