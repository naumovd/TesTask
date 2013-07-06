//
//  StreetsViewController.m
//  StreetIndex
//
//  Created by Dima on 03.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "StreetsViewController.h"
#import "Logging.h"
#import "Defs.h"
#import "StreetCell.h"
#import "Street.h"
#import "MapViewController.h"

@implementation StreetsViewController


-(void) viewDidLoad {
    [super viewDidLoad];
    [self initControls];
}

//=================================

-(void) initControls {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dataLoader = [[DataLoader alloc] init];
        dataLoader.delegate = self;
        [dataLoader loadData];
    });
}

//=================================


#pragma mark - Table view data source and delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;
}

//=================================

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    int result = 1;
    
    if (tableView == self.mainTableView && dataLoader.dataLoaded){
        result = dataLoader.groupedListOfPlacesDict.allKeys.count + dataLoader.groupedListOfStreetsDict.allKeys.count;
    }
    return result;
}

//=================================

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int result = 0;
    
    if (dataLoader.dataLoaded){
        if (tableView == self.mainTableView){
            
            if (section > keysOfStreets.count-1) {
                section -=  keysOfStreets.count;
                NSArray *placesForSection = [dataLoader.groupedListOfPlacesDict objectForKey: keysOfPlaces[section]];
                result = [placesForSection count];
            }
            else {
                NSArray *streetsForSection = [dataLoader.groupedListOfStreetsDict objectForKey: keysOfStreets[section]];
                result = [streetsForSection count];
            }
        }
        else if (tableView == self.searchTableView){
            result = arrayForSearchTable.count;
        }
    }
    
    return result;
}

//=================================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
    
	StreetCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(nil == cell) {
		cell = [[StreetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
    if (dataLoader.dataLoaded){
        Street *dataForCell = nil;
        if (tableView == self.mainTableView){
            
            if (indexPath.section > keysOfStreets.count-1) {
                int section = indexPath.section - keysOfStreets.count;
                NSArray *placesForSection = [dataLoader.groupedListOfPlacesDict objectForKey: keysOfPlaces[section]];
                dataForCell = placesForSection[indexPath.row];
            }
            else {
                NSArray *streetsForSection = [dataLoader.groupedListOfStreetsDict objectForKey: keysOfStreets[indexPath.section]];
                dataForCell = streetsForSection[indexPath.row];
            }
        }
        else if (tableView == self.searchTableView){
            dataForCell = arrayForSearchTable[indexPath.row];
        }
        cell.streetNameLabel.text = dataForCell.streetName;
        cell.streetIdLabel.text = [NSString stringWithFormat:@"%d",dataForCell.streetId];
        cell.streetCoordLabel.text = [NSString stringWithFormat:@"%@%@%@",dataForCell.startCoord.x, dataForCell.startCoord.y, dataForCell.endCoord?[NSString stringWithFormat:@"-%@%@",dataForCell.endCoord.x, dataForCell.endCoord.y]:@""];
    }
	return cell;
}

//=================================

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.searchTableView) return nil;
    NSArray *resultArr = nil;
    if (dataLoader.dataLoaded){
        resultArr = keysOfStreets;
    }
    return resultArr;
}

//=================================

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *resultStr = nil;
    
    if (dataLoader.dataLoaded && tableView == self.mainTableView){
        
        if (section > keysOfStreets.count-1) {
            section -=  keysOfStreets.count;
            resultStr = keysOfPlaces[section];
        }
        else {
            resultStr = keysOfStreets[section];
        }
    }
    
    return resultStr;
}

//=================================

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Street *selectedStreet = nil;
    
    if (tableView == self.searchTableView){
        selectedStreet = arrayForSearchTable[indexPath.row];
    }
    else {
        if (indexPath.section > keysOfStreets.count-1) {
            NSString *keyForPlaces = keysOfPlaces[indexPath.section-keysOfStreets.count];
            NSArray *placesForSection = [dataLoader.groupedListOfPlacesDict objectForKey:keyForPlaces];
            selectedStreet = placesForSection[indexPath.row];
        }
        else {
            NSString *keyForStreets = keysOfStreets[indexPath.section];
            NSArray *streetsForSection = [dataLoader.groupedListOfStreetsDict objectForKey:keyForStreets];
            selectedStreet = streetsForSection[indexPath.row];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showStreetOnMap:selectedStreet];
}

//=================================


-(void) showStreetOnMap:(Street*)street{
    for (UIViewController* controller in self.tabBarController.viewControllers) {
        if ([controller isKindOfClass:[MapViewController class]]){
            MapViewController *mapController = (MapViewController*)controller;
            [self.tabBarController setSelectedIndex: [self.tabBarController.viewControllers indexOfObject:controller]];
            [mapController zoomToCoordStart:street.startCoord end:street.endCoord];
            break;
        }
    }
}

#pragma mark - Data loader delegate 

-(void) dataFromFileLoaded{
    arrayForSearchTable = [NSMutableArray arrayWithArray:dataLoader.streetsAndPlacesArr];
    keysOfPlaces = [NSMutableArray arrayWithArray:dataLoader.groupedListOfPlacesDict.allKeys];
    keysOfStreets = [NSMutableArray arrayWithArray:dataLoader.groupedListOfStreetsDict.allKeys];
    
    [keysOfStreets sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*) obj1 compare:(NSString*)obj2];
    }];
    [keysOfPlaces sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*) obj1 compare:(NSString*)obj2];
    }];
    DLogTrace(@"Update tables");
    [self.mainTableView reloadData];
    [self.searchTableView reloadData];
}


#pragma mark - Search bar delegate methods

//=================================

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self updateTableForSearchText:searchBar.text];
}

//=================================

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.mainTableView.hidden = YES;
    self.searchTableView.hidden = NO;
    searchBar.showsCancelButton = YES;
}

//=================================

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self updateTableForSearchText:@""];
    [searchBar setText:@""];
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    self.mainTableView.hidden = NO;
    self.searchTableView.hidden = YES;
}

//=================================

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self updateTableForSearchText:searchBar.text];

    //ugly trick to activate cancel button when search bar is inactive
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)subview;
            cancelButton.enabled = YES;
            break;
        }
    }
}

//=================================

-(void) updateTableForSearchText:(NSString*)searchText{
    NSArray *dataForSearch = nil;
    if (lastSearchPhrase && [searchText hasPrefix:lastSearchPhrase]){
        dataForSearch = [NSArray arrayWithArray:arrayForSearchTable];
    }
    else {
        dataForSearch = [NSArray arrayWithArray:dataLoader.streetsAndPlacesArr];
    }
    
    [arrayForSearchTable removeAllObjects];
    if (searchText.length){
        searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        DLogTrace(@"Updating table with search string: %@", searchText);
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(SELF BEGINSWITH[cd] %@)",searchText];

        for (Street* street in dataForSearch){
            if ([predicate evaluateWithObject:street.streetName]){
                [arrayForSearchTable addObject:street];
            }
        }
    }
    else {
        [arrayForSearchTable addObjectsFromArray:dataLoader.streetsAndPlacesArr];
    }
    [self.searchTableView reloadData];
    lastSearchPhrase = searchText;
}

//=================================

- (void)dealloc
{
    dataLoader.delegate = nil;
    
}

@end
