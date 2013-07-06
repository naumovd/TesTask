//
//  MapViewController.m
//  StreetIndex
//
//  Created by Dima on 03.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "MapViewController.h"
#import "Defs.h"
#import "Logging.h"

#define asciiLettersShift 65
#define horizontalCount 28
#define verticalCount 27
#define alphabetOffset 26


@implementation MapViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    [self initControls];
}

//=================================

-(void) initControls{
    UIImage *mapImage = [UIImage imageNamed:MAP_IMAGE_NAME];
    self.scrollView.contentSize = mapImage.size;
    CGRect imageFrame = CGRectMake(0, 0, mapImage.size.width, mapImage.size.height);
    mapCellSize = imageFrame.size.height/verticalCount;
    self.imageView.frame = imageFrame;
    [self.imageView setImage:mapImage];
    self.scrollView.zoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 0.14;
}

//=================================
     
-(void)zoomToCoordStart:(StreetCoord*)startCoord end:(StreetCoord*)endCoord{

    //we zoom to start cood and mark those cell
    //if required can be added zone mark
    
    [markView removeFromSuperview];
    if ([startCoord.x isEqualToString:@"AC"]){
        [self showNoMapInfoWarning];
        return;
    }
    
    UniChar coordChar = [startCoord.x characterAtIndex:startCoord.x.length-1];
    if (startCoord.x.length>1){
        //in case coord is AA or AB 
        coordChar+=alphabetOffset;
    }
    int startCellX = coordChar-asciiLettersShift;
    int startCellY = [startCoord.y intValue]-1;
    //0.5 and 0.9 are miltipliers to correct cell rect coordinates on iPhone because image not ideal
    
    CGRect rectToZoom = CGRectMake(startCellX*(mapCellSize+0.5), startCellY*(mapCellSize+0.9), mapCellSize, mapCellSize);
    [self.scrollView zoomToRect: rectToZoom animated:YES];
    markView = [[UIView alloc] initWithFrame:rectToZoom];
    [markView setBackgroundColor:[UIColor redColor]];
    [markView setAlpha:0.3];
    [self.imageView addSubview:markView];
    
}

//=================================
 
-(void) showNoMapInfoWarning{
    NSString *errorMessage = @"This version of map support only limited amount of coordinates. If you want to check coordinates more than AB - please contact to developer";
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                 message:errorMessage
                                                delegate:nil
                                       cancelButtonTitle:@"Close"
                                       otherButtonTitles:nil];
    [al show];
}

//=================================

#pragma mark - Scroll view delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//=================================
     
@end
