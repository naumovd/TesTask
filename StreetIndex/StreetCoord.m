//
//  StreetCoord.m
//  readDataTEst
//
//  Created by Dmytro Naumov on 7/3/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "StreetCoord.h"

@implementation StreetCoord
@synthesize x;
@synthesize y;

-(NSString*) description{
    return [NSString stringWithFormat:@"%@:%@", self.x, self.y];
}

@end
