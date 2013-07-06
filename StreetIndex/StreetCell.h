//
//  StreetCell.h
//  StreetIndex
//
//  Created by Dima on 03.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *streetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetCoordLabel;

@end
