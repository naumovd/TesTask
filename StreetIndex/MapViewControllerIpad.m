//
//  MapViewControllerIpad.m
//  StreetIndex
//
//  Created by Dima on 04.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "MapViewControllerIpad.h"

@implementation MapViewControllerIpad

-(void) initControls{
    [super initControls];
    self.scrollView.zoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 0.251;
}

//=================================

#pragma mark - UISplitViewControllerDelegate methods

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

//=================================

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button{
    self.navigationItem.leftBarButtonItem = nil;
}
 
//=================================

@end
