//
//  DataLoader.h
//  StreetIndex
//
//  Created by Dima on 02.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataLoaderDelegate <NSObject>

-(void) dataFromFileLoaded;

@end

@interface DataLoader : NSObject {
    NSMutableDictionary *groupedListOfStreetsDict;
    NSMutableDictionary *groupedListOfPlacesDict;
    NSMutableArray *streetsAndPlacesArr;
    __weak id <DataLoaderDelegate> delegate;
    BOOL dataLoaded;
}

@property (nonatomic,strong) NSMutableDictionary *groupedListOfStreetsDict;
@property (nonatomic,strong) NSMutableDictionary *groupedListOfPlacesDict;
@property (nonatomic,strong) NSMutableArray *streetsAndPlacesArr;
@property (nonatomic, weak) id <DataLoaderDelegate> delegate;
@property (nonatomic,assign) BOOL dataLoaded;

-(void)loadData;

@end
