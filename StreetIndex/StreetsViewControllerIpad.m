//
//  StreetsViewControllerIpad.m
//  StreetIndex
//
//  Created by Dima on 04.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "StreetsViewControllerIpad.h"
#import "Defs.h"
#import "AppDelegate.h"
@implementation StreetsViewControllerIpad

-(void) showStreetOnMap:(Street*)street{
    [APP_DELEGATE.mapController zoomToCoordStart:street.startCoord end:street.endCoord];
}
@end
