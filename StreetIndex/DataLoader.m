//
//  DataLoader.m
//  StreetIndex
//
//  Created by Dima on 02.07.13.
//  Copyright (c) 2013 Dima. All rights reserved.
//

#import "DataLoader.h"
#import "Street.h"
#import "Defs.h"
#import "Logging.h"

#define separator @","
#define coordInterval @"-"
#define commentedLinePrefix @"#"

@implementation DataLoader
@synthesize groupedListOfStreetsDict;
@synthesize groupedListOfPlacesDict;
@synthesize streetsAndPlacesArr;
@synthesize delegate;
@synthesize dataLoaded;


-(void) loadData{
    
    //I'd like to import all data to SQLite and use CoreData
    //but if we have to load info from file every time I used NSScanner
    
    //Also in file not only streets but places too. So I created common list sorted alphabetically (as described in task),
    //but for comfortable view I'll show places in table at the end
    //for this I put streets and places to different dictionaries
	
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        groupedListOfStreetsDict = [NSMutableDictionary dictionary];
        groupedListOfPlacesDict = [NSMutableDictionary dictionary];
        streetsAndPlacesArr = [NSMutableArray array];
        
        NSError *fileOpenError = nil;
        NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:DATA_FILE_NAME];
        NSString *dataStr = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileOpenError];
        if (fileOpenError!=nil){
            DLogError(@"Can't open file: %@ Eror: %@", filePath, fileOpenError.description);
        }
        else {
            DLogTrace(@"File: %@ loaded", filePath);
        }
        dataStr = [self cleanTextFromComments:dataStr];
        
        NSScanner *dataScanner = [NSScanner scannerWithString:dataStr];
        NSCharacterSet *newLineCharacterSet = [NSCharacterSet newlineCharacterSet];
        NSCharacterSet *numbersCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *newLineAndIntervalCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\r\n-"];
        
        NSMutableArray *arrayOfStreetsForCurrentGroup = nil;
        NSString *currentGroupKey = nil;
        while (![dataScanner isAtEnd]) {
            //if line start from separator - this is street. in other case this is group letter (name in case buildings)
            if(![[[dataScanner string] substringWithRange:NSMakeRange(dataScanner.scanLocation, 1)] isEqualToString:separator]){
                arrayOfStreetsForCurrentGroup = [NSMutableArray array];
                currentGroupKey = [[NSString alloc] init];
                [dataScanner scanUpToCharactersFromSet:newLineCharacterSet intoString:&currentGroupKey];
                if (currentGroupKey.length > 1){
                    //this is places group
                    [groupedListOfPlacesDict  setObject:arrayOfStreetsForCurrentGroup forKey:currentGroupKey];
                }
                else {
                    //regular street
                    [groupedListOfStreetsDict setObject:arrayOfStreetsForCurrentGroup forKey:currentGroupKey];
                }
            }
            else {
                NSString *readingStr = [NSString new];
                dataScanner.scanLocation++; //skip separator
                
                //scan street name
                [dataScanner scanUpToString:separator intoString:&readingStr];
                Street *newStreet = [Street new];
                newStreet.streetName = [readingStr copy];
                dataScanner.scanLocation++; //skip separator
                
                StreetCoord *newStartCoord = [StreetCoord new];
                [dataScanner scanUpToCharactersFromSet:numbersCharacterSet intoString:&readingStr];
                newStartCoord.x = [[readingStr uppercaseString] copy];//capitalize coord letter, because we get number from it based on ASCII table in MapViewController
                [dataScanner scanUpToCharactersFromSet:newLineAndIntervalCharacterSet intoString:&readingStr];
                newStartCoord.y = [readingStr copy];
                newStreet.startCoord = newStartCoord;
                
                if ([[[dataScanner string] substringWithRange:NSMakeRange(dataScanner.scanLocation, 1)] isEqualToString:coordInterval]){
                    StreetCoord *newEndCoord = [StreetCoord new];
                    dataScanner.scanLocation++; //skip coord interval
                    [dataScanner scanUpToCharactersFromSet:numbersCharacterSet intoString:&readingStr];
                    newEndCoord.x = [[readingStr uppercaseString] copy];
                    [dataScanner scanUpToCharactersFromSet:newLineCharacterSet intoString:&readingStr];
                    newEndCoord.y = [readingStr copy];
                    newStreet.endCoord = newEndCoord;
                }
                if (arrayOfStreetsForCurrentGroup) [arrayOfStreetsForCurrentGroup addObject:newStreet];
                [streetsAndPlacesArr addObject:newStreet];
            }
            dataScanner.scanLocation+=2; //skip new line symbol
            dataLoaded = YES;
        }
        
        //sort alphabetically ans set id
        [streetsAndPlacesArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[(Street*) obj1 streetName] compare:[(Street*) obj2 streetName]];
        }];
        int streetId = 0; 
        for (Street *street in streetsAndPlacesArr){
            street.streetId = streetId;
            streetId++;
        }
        DLogTrace(@"File: %@ parsed. Data ready", filePath);
        
    });
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if ([self.delegate respondsToSelector:@selector(dataFromFileLoaded)]){
            [self.delegate dataFromFileLoaded];
        }
    });
}

//=================================

-(NSString*) cleanTextFromComments:(NSString*)text{
    //comment - line started from "#" symbol
    NSString *resultStr = text;
    BOOL textHasComments = YES;
    for (;textHasComments;){
        NSRange commentSymbolRange = [resultStr rangeOfString:commentedLinePrefix];
        if (commentSymbolRange.location != NSNotFound) {
            NSRange rangeForEndLineSearch = NSMakeRange(commentSymbolRange.location, resultStr.length - commentSymbolRange.location);
            NSRange rangeOfCommentEndOfLine = [resultStr rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSCaseInsensitiveSearch range:rangeForEndLineSearch];
            NSRange reangeOfStringToDelete = NSMakeRange(commentSymbolRange.location, (rangeOfCommentEndOfLine.location!=NSNotFound) ? rangeOfCommentEndOfLine.location-commentSymbolRange.location+2 /*2 symbols \r\n compensation*/ : resultStr.length-commentSymbolRange.location);
            resultStr = [resultStr stringByReplacingCharactersInRange:reangeOfStringToDelete withString:@""];
        }
        else {
            textHasComments = NO;
        }
    }
    return resultStr;
}


@end
