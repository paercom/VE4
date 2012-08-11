//
//  RangeSpreadsheetGenerator.m
//  ElectoralExperiment3
//
//  Created by Stefan Agapie on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RangeSpreadsheetGenerator.h"
#import "FileHandle.h"
#import "ElectoralExperiments.h"


@implementation RangeSpreadsheetGenerator

+(void)generateRangeSpreadsheetDataSet {
    
    // get filepath for Range data set and create a filepath for the spreadsheet data set //
    NSString *filepath = [FileHandle getFilePathForFileWithName:kRangeDataFileName];
    NSString *newFilepath = [FileHandle getFilePathForFileWithName:kRangeSpreadsheetDataSetFilename];
    NSString *voterChoiceListFilepath = [FileHandle getFilePathForFileWithName:kCandidateFileName];
    
    // load data from file into a local NSDictionary //
    NSMutableDictionary *rangeModel;
    NSArray *voterChoiceList;
    
    // if file at path exists then load the range data model //
    BOOL IDfileExists = [FileHandle doesFileWithNameExist:[FileHandle getFilePathForFileWithName:kRangeDataFileName]];
    if (IDfileExists) { rangeModel = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath]; }
    
    IDfileExists = [FileHandle doesFileWithNameExist:[FileHandle getFilePathForFileWithName:kCandidateFileName]];
    if (IDfileExists) { voterChoiceList = [[NSArray alloc] initWithContentsOfFile:voterChoiceListFilepath]; }
    
    if ( !(rangeModel && voterChoiceList) ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Generation Error" message:@"Unable to generate the Range Spreadsheet Data Sets." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;        
    }
    
    NSString *rangeDataModelString = @"Voter ID,Data Item,Range Value Selection,Write-In\n";
    
    // load the range data model into a NSString object //
    [rangeModel removeObjectForKey:@"0"]; // remove this key since it's only a place holder //
    NSArray *dataObjectKeys = [rangeModel allKeys];
    for (NSString *dataObjectKey in dataObjectKeys) {
        NSNumber *voterID = [[rangeModel valueForKey:dataObjectKey] objectAtIndex:0];
        NSString *voterItem = [[rangeModel valueForKey:dataObjectKey] objectAtIndex:1];
        NSString *voterItemRangeValue = [[rangeModel valueForKey:dataObjectKey] objectAtIndex:2];
        NSString *voterWriteIn = @"YES";
        
        // determine if the voter's item choice is a write in candidate //
        BOOL isVoterChoiceItemA_WriteIn = YES;
        for (NSString *choiceItem in voterChoiceList) {
            // voter's choice is assumed to be a write-in unless we find at least one on the predefined choice list //
            if ([voterItem isEqualToString:choiceItem]) {
                isVoterChoiceItemA_WriteIn = NO;
                voterWriteIn = @"NO";
                break;
            }
        }
        
        NSString *data = [NSString stringWithFormat:@"%u,%@,%@,%@\n",[voterID integerValue],voterItem,voterItemRangeValue,voterWriteIn];
        rangeDataModelString = [rangeDataModelString stringByAppendingString:data];
    }
    
    NSError *err;    
    if ([rangeModel count] > 0) {
        // save plurality spreadsheet data model List to file //
        if ( ![rangeDataModelString writeToFile:newFilepath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&err] ) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Failed to save Range Spreadsheet Data Set to file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } 
    }
    
}

@end
