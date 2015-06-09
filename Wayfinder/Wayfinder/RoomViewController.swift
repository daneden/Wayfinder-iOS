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
    
    var room: Room!
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomDescriptionLabel: UILabel!
    @IBOutlet weak var roomLocationLabel: UILabel!
    
    @IBOutlet var roomMetaView: UIVisualEffectView!

    @IBOutlet var cardMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use inverted status bar when this view is present
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // Cosmetic changes
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.9
        view.layer.shadowOffset = CGSizeMake(0, 2)
        view.layer.shadowRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 0.2).CGColor
        view.layer.borderWidth = 1
        
        // Show user location on the map
        cardMapView.showsUserLocation = true
        cardMapView.setUserTrackingMode(MKUserTrackingMode.None, animated: false)
        
        // Set the location for the MapView
        let officeLocation = CLLocationCoordinate2DMake(37.776378, -122.391897)
        let annotation = MKPointAnnotation()
        annotation.coordinate = officeLocation
        annotation.title = "Dropbox HQ"
        annotation.subtitle = "San Francisco, CA"
        cardMapView.addAnnotation(annotation)
        cardMapView.selectAnnotation(annotation, animated: true)
        
        var mapRegion = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapRegion.center.latitude += CLLocationDegrees(roomMetaView.frame.height / 400000)
        cardMapView.setRegion(mapRegion, animated: false)
        
        roomNameLabel.text = room.name
        roomDescriptionLabel.text = room.floor
        roomLocationLabel.text = Array(room.landmarks).combine(",")
        
        // Use a slightly taller frame since we're scaling it down
        view.frame = CGRectMake(0, 0, view.frame.width, view.frame.height * 1.2)
        let offset = (view.frame.height - (view.frame.height / 1.2)) / 2
        
        // Scale down the view
        self.view.transform = CGAffineTransformMakeScale(0.9, 0.9)
        self.view.transform = CGAffineTransformConcat(view.transform, CGAffineTransformMakeTranslation(0, -offset))
        
        // Initialise view position for later reference
        transformation = self.view.transform
        cardInitialCenter = self.view.center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCardPan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(view)
        let rotation = translation.x / 10 * CGFloat(M_PI / 180)
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            
        } else if gesture.state == UIGestureRecognizerState.Changed {
            
            self.view.center.y = cardInitialCenter.y + translation.y
            self.view.center.x = cardInitialCenter.x + translation.x
            
            // Fade the card when it's swiped along X to indicate where it needs to travel
            let alpha = (fabs(translation.x) / 300)
            self.view.alpha = 1 - alpha
            
            self.view.transform = CGAffineTransformRotate(transformation, rotation)
            
        } else if gesture.state == UIGestureRecognizerState.Ended {
            
            if translation.x > 60 {
                UIView.animateWithDuration(0.2, animations: {
                    self.view.center.x += self.view.frame.width
                    }, completion: { (finished: Bool) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                
            } else if translation.x < -60 {
                UIView.animateWithDuration(0.2, animations: {
                    self.view.center.x -= self.view.frame.width
                    }, completion: { (finished: Bool) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                })
                
            } else {
                UIView.animateWithDuration(0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 12,
                    options: [],
                    animations: {
                    self.view.center = self.cardInitialCenter
                    self.view.transform = self.transformation
                    self.view.alpha = 1
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
