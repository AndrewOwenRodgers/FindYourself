//
//  ViewController.m
//  FindYourself
//
//  Created by Andrew Rodgers on 3/5/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "ViewController.h"
#import "LocationObject.h"

@interface ViewController ()
{
	CGFloat slideheight;
}


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *currentSearchLocations;
@property (weak, nonatomic) IBOutlet UITextField *searhField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = 47.6475;
	coordinate.longitude = -122.34967;
	LocationObject *giantTardisBridge = [[LocationObject alloc] initWithName:@"Giant TARDIS Bridge"
																	 address:@"Bridge St. and Troll Ave"
																  coordinate:coordinate];
	[self plotNewPosition:giantTardisBridge];
	
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = kCLDistanceFilterNone;
	
	[self.locationManager startUpdatingLocation];
	UILongPressGestureRecognizer *longPressAddTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
	
	longPressAddTap.minimumPressDuration = 1.1;
	
    [self.mapView addGestureRecognizer:longPressAddTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)plotNewPosition:(LocationObject *)mapItem
{
	[_mapView addAnnotation:mapItem];
}

-(IBAction)zoomButton:(id)sender
{
	if ([CLLocationManager authorizationStatus] != 3)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"So, imma need your location status authorization"
														message:@""
													   delegate:nil
											  cancelButtonTitle:@"My bad, I'll go fix that"
											  otherButtonTitles:nil];
		[alert show];
	}
	else
	{
		[self zoom];
	}
}

-(void)zoom
{
	CLLocationCoordinate2D zoomLocation= self.locationManager.location.coordinate;

	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 800.f, 800.f);

	[_mapView setRegion:viewRegion animated:YES];
}

-(IBAction)searchButtonPressed:(id)sender
{
	if ([CLLocationManager authorizationStatus] != 3)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"So, imma need your location status authorization"
														message:@""
													   delegate:nil
											  cancelButtonTitle:@"My bad, I'll go fix that"
											  otherButtonTitles:nil];
		[alert show];
	}
	else
	{
		[self search];
	}
}

-(void)search
{
	MKCoordinateRegion newRegion;
	newRegion.center.latitude = self.locationManager.location.coordinate.latitude;
	newRegion.center.longitude = self.locationManager.location.coordinate.latitude;
	newRegion.span.latitudeDelta = 0.2;
	newRegion.span.longitudeDelta = 0.2;
	
	MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
	
	request.naturalLanguageQuery = self.searhField.text;
	request.region = newRegion;
	
	MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
	{
		if (error != nil)
		{
			NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have failed me for the last time, admiral"
															message:errorStr
														   delegate:nil
												  cancelButtonTitle:@"*agk*"
												  otherButtonTitles:nil];
			[alert show];
		}
		else
		{
			self.currentSearchLocations = [response mapItems];
			for (MKMapItem *mapItem in self.currentSearchLocations)
			{
				NSArray *addressArray = [mapItem.placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
				NSString *address = [[addressArray[0] stringByAppendingString:@", "] stringByAppendingString:addressArray[1]];
				LocationObject *object = [[LocationObject alloc] initWithName:mapItem.name
																	  address:address
																   coordinate:mapItem.placemark.coordinate];
				[self.mapView addAnnotation:object];
			}
		}
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	};
	
	MKLocalSearch *findNemo = [[MKLocalSearch alloc] initWithRequest:request];
	
	[findNemo startWithCompletionHandler:completionHandler];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField //Slides the view up when the keyboard appears
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + (CGFloat)0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - (CGFloat)0.2 * viewRect.size.height;
    CGFloat denominator = (CGFloat)0.6 * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        slideheight = floor((CGFloat)216 * heightFraction) + 44;
    }
    else
    {
        slideheight = floor((CGFloat)168 * heightFraction) + 44;
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= slideheight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGFloat)0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
	
	UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
	[keyboardDoneButtonView sizeToFit];
	UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
																   style:UIBarButtonItemStyleBordered target:self
																  action:@selector(beDone)];
	[keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
	textField.inputAccessoryView = keyboardDoneButtonView;
}

-(void)beDone
{
	[self.searhField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += slideheight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGFloat)0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.myMapView];
	
    CLLocationCoordinate2D tapPoint = [self.myMapView convertPoint:point toCoordinateFromView:self.view];
	
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
	
    point1.coordinate = tapPoint;
	
    [self.myMapView addAnnotation:point1];
}

@end
