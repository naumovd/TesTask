//
//  AppDelegate.h
//  StreetIndex
//
//  Created by Dima on 02.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewControllerIpad.h"
#import "Defs.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UISplitViewController *splitViewController;
    MapViewControllerIpad *mapController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MapViewControllerIpad *mapController;
@end
