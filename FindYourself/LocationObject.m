//
//  LocationObject.m
//  FindYourself
//
//  Created by Andrew Rodgers on 3/5/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "LocationObject.h"
#import <AddressBook/AddressBook.h>

@interface LocationObject()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation LocationObject

-(id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
	if (self = [super init])
	{
		self.name = name;
		self.address = address;
		self.coordinate = coordinate;
	}
	return self;
}

- (MKMapItem *)mapItem
{
    NSDictionary *addressDict = @{(NSString *)kABPersonAddressStreetKey : _address};
	
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
	
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
	
    return mapItem;
}

@end
