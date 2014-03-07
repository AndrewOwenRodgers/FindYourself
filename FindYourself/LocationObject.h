//
//  LocationObject.h
//  FindYourself
//
//  Created by Andrew Rodgers on 3/5/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationObject : NSObject
<MKAnnotation>

@property (nonatomic) BOOL important;

-(id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate andImportance:(BOOL)important;
-(MKMapItem *)mapItem;

@end
