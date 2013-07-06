//
//  Street.m
//  readDataTEst
//
//  Created by Dmytro Naumov on 7/3/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "Street.h"

@implementation Street
@synthesize streetId;
@synthesize streetName;
@synthesize startCoord;
@synthesize endCoord;

-(NSString*) description{
    NSString *coord = [NSString stringWithFormat:@"%@%@%@", self.startCoord, self.endCoord?@"-":@"",self.endCoord?self.endCoord:@""];
    return [NSString stringWithFormat:@"Street: %@, id: %d coord: %@", self.streetName, self.streetId,coord];
}


@end
