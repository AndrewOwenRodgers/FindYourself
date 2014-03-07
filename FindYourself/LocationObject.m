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

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation LocationObject

-(id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate andImportance:(BOOL)important
{
	if (self = [super init])
	{
		self.name = name;
		self.address = address;
		self.coordinate = coordinate;
		self.important = important;
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
