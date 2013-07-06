//
//  MapViewController.h
//  StreetIndex
//
//  Created by Dima on 03.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreetCoord.h"
@interface MapViewController : UIViewController {
    float mapCellSize;
    UIView *markView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(void)zoomToCoordStart:(StreetCoord*)startCoord end:(StreetCoord*)endCoord;
-(void)initControls;
@end
