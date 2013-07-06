//
//  StreetsViewController.h
//  StreetIndex
//
//  Created by Dima on 03.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLoader.h"
#import "Street.h"
@interface StreetsViewController : UIViewController <DataLoaderDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    DataLoader *dataLoader;
    NSMutableArray *arrayForSearchTable;
    NSMutableArray *keysOfStreets;
    NSMutableArray *keysOfPlaces;
    
    NSString *lastSearchPhrase;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

-(void) showStreetOnMap:(Street*)street;

@end
