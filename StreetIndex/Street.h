//
//  Street.h
//  readDataTEst
//
//  Created by Dmytro Naumov on 7/3/13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreetCoord.h"



@interface Street : NSObject {
    
}

@property (nonatomic, assign) int streetId;
@property (nonatomic, strong) NSString *streetName;
@property (nonatomic, strong) StreetCoord *startCoord;
@property (nonatomic, strong) StreetCoord *endCoord;

@end
