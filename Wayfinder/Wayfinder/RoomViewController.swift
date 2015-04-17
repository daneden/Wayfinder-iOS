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

        // Do any additional setup after loading the view.
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.9
        view.layer.shadowOffset = CGSizeMake(0, 2)
        view.layer.shadowRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 0.2).CGColor
        view.layer.borderWidth = 1
        
        cardInitialCenter = view.center
        view.transform = CGAffineTransformMakeScale(0.9, 0.9)
        transformation = view.transform
        
        cardMapView.showsUserLocation = true
        cardMapView.setUserTrackingMode(MKUserTrackingMode.None, animated: false)
        
        var officeLocation = CLLocationCoordinate2DMake(37.776378, -122.391897)
        var annotation = MKPointAnnotation()
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
        
        
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        // This zooms the map into the user location, but it makes more sense to center in on the room
//        var mapRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//        mapView.setRegion(mapRegion, animated: false)
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
            
            
            
        } else if gesture.state == UIGestureRecognizerState.Changed {
            
            self.view.center.y = cardInitialCenter.y + translation.y
            self.view.center.x = cardInitialCenter.x + translation.x
            
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
                    usingSpringWithDamping: 0.4,
                    initialSpringVelocity: 15,
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
