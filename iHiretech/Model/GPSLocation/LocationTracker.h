//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "LocationShareModel.h"

@protocol LocationUpdateProtocol
@required
-(void)updateLocationToServer:(NSString *)latitude  longi:(NSString *)Longitude;

@end


@interface LocationTracker : NSObject <CLLocationManagerDelegate,LocationUpdateProtocol>

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationCoordinate2D myCurrentLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) LocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;
@property (nonatomic, weak) id<LocationUpdateProtocol> delegate;
+ (CLLocationManager *)sharedLocationManager;
+ (id)sharedLocationInstance;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer;


@end
