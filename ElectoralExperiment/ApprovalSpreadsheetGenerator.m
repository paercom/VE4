//
//  ApprovalSpreadsheetGenerator.m
//  ElectoralExperiment3
//
//  Created by Stefan Agapie on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApprovalSpreadsheetGenerator.h"
#import "FileHandle.h"
#import "ElectoralExperiments.h"


@implementation ApprovalSpreadsheetGenerator

+(void)generateApprovalSpreadsheetDataSets {
    
    // get filepath for Range data set and create a filepath for the spreadsheet data set //
    NSString *filepath = [FileHandle getFilePathForFileWithName:kApprovalDataFileName];
    NSString *newFilepath = [FileHandle getFilePathForFileWithName:kApprovalSpreadsheetDataSetFilename];
    NSString *voterChoiceListFilepath = [FileHandle getFilePathForFileWithName:kCandidateFileName];
    
    // load data from file into a local NSDictionary //
    NSMutableDictionary *approvalModel;
    NSArray *voterChoiceList;
    
    // if file at path exists then load the range data model //
    BOOL IDfileExists = [FileHandle doesFileWithNameExist:[FileHandle getFilePathForFileWithName:kApprovalDataFileName]];
    if (IDfileExists) { approvalModel = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath]; }
    
    IDfileExists = [FileHandle doesFileWithNameExist:[FileHandle getFilePathForFileWithName:kCandidateFileName]];
    if (IDfileExists) { voterChoiceList = [[NSArray alloc] initWithContentsOfFile:voterChoiceListFilepath]; }
    
    if ( !(approvalModel && voterChoiceList) ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Generation Error" message:@"Unable to generate the Approval Spreadsheet Data Sets." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;        
    }
    
    NSString *approvalDataModelString = @"Voter ID,Data Item,Approval Value,Write-In\n";
    
    // load the range data model into a NSString object //
    [approvalModel removeObjectForKey:@"0"]; // remove this key since it's only a place holder //
    NSArray *dataObjectKeys = [approvalModel allKeys];
    for (NSString *dataObjectKey in dataObjectKeys) {
        NSNumber *voterID = [[approvalModel valueForKey:dataObjectKey] objectAtIndex:0];
        NSString *voterDataItem = [[approvalModel valueForKey:dataObjectKey] objectAtIndex:1];
        NSString *voterDataItemValue = [[approvalModel valueForKey:dataObjectKey] objectAtIndex:2];
        NSString *voterWriteIn = @"YES";
        
        // determine if the voter's item choice is a write in candidate //
        BOOL isVoterChoiceItemA_WriteIn = YES;
        for (NSString *choiceItem in voterChoiceList) {
            // voter's choice is assumed to be a write-in unless we find at least one on the predefined choice list //
            if ([voterDataItem isEqualToString:choiceItem]) {
                isVoterChoiceItemA_WriteIn = NO;
                voterWriteIn = @"NO";
                break;
            }
        }
        
        // convert 0, and 1 Boolean values to YES, and NO data strings, respectivley -- note: 0 == YES, 1 == NO (sorry! Bad design...) //
        if ([voterDataItemValue isEqualToString:@"0"]) {
            voterDataItemValue = @"YES";
        } else if ([voterDataItemValue isEqualToString:@"1"]) {
            voterDataItemValue = @"NO";
        }
        
        NSString *data = [NSString stringWithFormat:@"%u,%@,%@,%@\n",[voterID integerValue],voterDataItem,voterDataItemValue,voterWriteIn];
        approvalDataModelString = [approvalDataModelString stringByAppendingString:data];
    }
    
    NSError *err;    
    if ([approvalModel count] > 0) {
        // save plurality spreadsheet data model List to file //
        if ( ![approvalDataModelString writeToFile:newFilepath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&err] ) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Failed to save Approval Spreadsheet Data Set to file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } 
    }    
    
}

@end
