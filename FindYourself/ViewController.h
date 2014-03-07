//
//  ViewController.h
//  FindYourself
//
//  Created by Andrew Rodgers on 3/5/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController
<MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(IBAction)zoomButton:(id)sender;

@end
