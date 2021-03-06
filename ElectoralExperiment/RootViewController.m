//
//  RootViewController.m
//  ElectoralExperiment
//
//  Created by Stefan Agapie on 10/19/11.
//  Copyright 2011 Stefan Agapie. All rights reserved.
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "RootViewController.h"
#import "ElectoralExperiments.h"
#import "AdminViewController.h"
#import "PluralityViewController.h"
#import "RangeViewController.h"
#import "IRVviewController.h"
#import "ApprovalViewController.h"
#import "FileHandle.h"
#import "SizeConstants.h"
#import "UserDemographicsViewController.h"

#import "MySingelton.h"

@implementation RootViewController

@synthesize electoralExperimentList;

//*************************************************************
-(void) launchTheNexExperiment{ 
    
    experimentAdministrator = [MySingelton sharedObject];
    
    // randomly select the next experiment //
    NSUInteger experimentsLeft = [experimentAdministrator->experimentsNotCompletedList count];
    NSUInteger randomExperimentIndex = arc4random() % experimentsLeft; // integer between [ 0, experimentsLeft ) //
    NSString *nextExperiment = [experimentAdministrator->experimentsNotCompletedList objectAtIndex:randomExperimentIndex];
    [experimentAdministrator->experimentsNotCompletedList removeObjectAtIndex:randomExperimentIndex];
    
    if ([nextExperiment isEqualToString:kPlurality]) {
        
        // Plurality Experiment //
        PluralityViewController *pluralityViewController = [[PluralityViewController alloc] initWithNibName:@"PluralityViewController" bundle:nil];
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController pushViewController:pluralityViewController animated:YES];
        [pluralityViewController release];
        
    } else if ([nextExperiment isEqualToString:kRange]) {
        
        // Range Experiment //
        RangeViewController *rangeViewController = [[RangeViewController alloc] initWithNibName:@"RangeViewController" bundle:nil];
        [self.navigationController pushViewController:rangeViewController animated:YES];
        [rangeViewController release];
        
    } else if ([nextExperiment isEqualToString:kIRV]) {
        
        // IRV Experiment //
        IRVviewController *irvViewController = [[IRVviewController alloc] initWithNibName:@"IRVviewController" bundle:nil];
        [self.navigationController pushViewController:irvViewController animated:YES];
        [irvViewController release];
        
    } else if ([nextExperiment isEqualToString:kApproval]) {        
        
        // Approval Experiment //
        ApprovalViewController *approvalViewController = [[ApprovalViewController alloc] initWithNibName:@"ApprovalViewController" bundle:nil];
        [self.navigationController pushViewController:approvalViewController animated:YES];
        [approvalViewController release];
    }
    
}
//*************************************************************

#pragma mark - View Life Cycle

- (void)viewDidLoad
{ 
    
    [super viewDidLoad];
    
    // Check to see if voter ID used log file was created //
    BOOL IDfileExists = [FileHandle doesFileWithNameExist:[FileHandle getFilePathForFileWithName:kCurrentVoterIDLogFileName]];
    
    // if file does not exist then create //
    if (IDfileExists == NO) {
       
        // create file with a voter ID starting at 1 //
        NSInteger voterID = 1;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[NSNumber numberWithUnsignedInt:voterID]];
        
        // also create binary slots indicating which voting experiment the current voter has completed //
        for (integer_t i = 0; i < kNumberOfVoterExperiments; i++) {
            [array addObject:[NSNumber numberWithUnsignedInt:0]];
        }
        
        [array writeToFile:[FileHandle getFilePathForFileWithName:kCurrentVoterIDLogFileName] atomically:YES];
        [array release];
        
        if ([FileHandle doesFileWithNameExist:[FileHandle getFilePathForFileWithName:kCurrentVoterIDLogFileName]] == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not create Current Voter ID log file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
    }
    self.electoralExperimentList = [NSArray arrayWithObjects:kPlurality, kRange, kIRV, kApproval, kRunExperiment, kAdmin, kCreateNewVoterIDtitle, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.electoralExperimentList = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //self.title = kMainMenuTitle;
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    
    self.title = kMainMenuTitle;
    
    //*************************************************************
    experimentAdministrator = [MySingelton sharedObject];
    
    if ([experimentAdministrator getIsExperimentActive]) {
        
        // if number of experiments left on the uncompleted list is greater than one, then continue with the experiment //
        NSUInteger numberOfExperimentsLeftBeforeStoping = kNumberOfVoterExperiments - kNumberOfRandomlySelectedExperimentsPerSession;
        if ([experimentAdministrator->experimentsNotCompletedList count] > numberOfExperimentsLeftBeforeStoping) {
            
            // TEST //
            //NSLog(@"Continue With Experiment");
            
            [self launchTheNexExperiment];
            
        } else {
            // end experiment //
            [experimentAdministrator setIsExperimentActive:NO];
            [experimentAdministrator populateExperimentsNotCompletedList];
            
            // TEST //
            //NSLog(@"End Experiment");
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
            
            // Create a New Voter ID //
            // read in current voter data from file, but first get the file path //
            NSString *filepath = [FileHandle getFilePathForFileWithName:kCurrentVoterIDLogFileName];
            NSArray *voterData = [[NSArray alloc] initWithContentsOfFile:filepath];
            NSInteger voterID = [((NSNumber*)[voterData objectAtIndex:0]) integerValue];
            [voterData release];
            voterID += 1;
            
            NSNumber *zeroValue = [NSNumber numberWithInteger:0];
            
            NSMutableArray *updatedVoterData = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:voterID], nil];
            for (NSInteger j = 0; j < kNumberOfVoterExperiments; j++) {
                [updatedVoterData addObject:zeroValue];
            }
            
            BOOL didFileSaveStatus = [updatedVoterData writeToFile:filepath atomically:YES];
            [updatedVoterData release];
            
            if (didFileSaveStatus == NO) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not save new voter ID to file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            
            // inform the user that the experiment is over //
            UIAlertView *experimentCompletedAlert = [[UIAlertView alloc] initWithTitle:@"Thank You! :-)" message:@"Thank you for taking part in the Occupy Wall Street voting experiment. Once this experiment is completed and the data is analyzed, we will publish our findings on the nycga.net website and many other websites and/or publications.\n\nPlease hand over this device to the administrator." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles: nil];
            [experimentCompletedAlert show];
            [experimentCompletedAlert release];
            
            self.title = kMainMenuTitle;            
        }        
    }    
    //*************************************************************
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    /*
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }
	return YES;
     */
}

#pragma mark - Table View Data Source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    /*
    if (section == 0) {
        return [electoralExperimentList count] -2;
    } else if (section == 1){
        return 1;
    }
    return 1;
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kTableViewCellRowHeight;   
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:[FileHandle getFilePathForFileWithName:kCurrentVoterIDLogFileName]];
        
        NSString *voterID = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:0]];
        NSString *voterSectionHeader = [kElectoralExperimentHeader stringByAppendingFormat:@" ID: %@",voterID];
        return voterSectionHeader;
        //return kElectoralExperimentHeader;
    }
    if (section == 1) {
        return kAdminHeader;
    }
    if (section == 2) {
        return @"Prototype";
    }
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    const NSInteger runExperimentIndex = [electoralExperimentList indexOfObject:kRunExperiment];
    const NSInteger adminIndex = [electoralExperimentList indexOfObject:kAdmin];
    
    UITableViewCell *cell = nil;
    //cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:kTableViewCellFontSize];
    
    if (indexPath.section == 0) {
        // display run experiment button //
        cell.textLabel.text = [electoralExperimentList objectAtIndex:runExperimentIndex];
    } 
    else if (indexPath.section == 1) {
        cell.textLabel.text = [electoralExperimentList objectAtIndex:adminIndex];
    }
    else if (indexPath.section == 2) {
        cell.textLabel.text = @"Demographics Prototype";
    }

    // Configure the cell.
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL IDfileExists = [FileHandle doesFileWithNameExist:[FileHandle getFilePathForFileWithName:kCandidateFileName]];
    if (!IDfileExists && indexPath.section == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Admin Action Required" message:@"A candidate/item list must first be created in order to gain access to the voting methods experiments."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        [tableView reloadData];
    }
    if (IDfileExists && indexPath.section == 0) {
        [experimentAdministrator runExperiment];
        
/*
        // TEST -- FOR TESTING ONLY, REMOVE AFTER TEST //
        ApprovalViewController *approvalViewControllerTest = [[ApprovalViewController alloc] initWithNibName:@"ApprovalViewController" bundle:nil];
        [self.navigationController pushViewController:approvalViewControllerTest animated:YES];
        [approvalViewControllerTest release];
        // TEST -- END
*/

/*
        // TEST -- FOR TESTING ONLY, REMOVE AFTER TEST //
        RangeViewController *rangeViewControllerTest = [[RangeViewController alloc] initWithNibName:@"RangeViewController" bundle:nil];
        [self.navigationController pushViewController:rangeViewControllerTest animated:YES];
        [rangeViewControllerTest release];
        // TEST -- END
*/        
    
        // Load the First Experiment //
        PluralityViewController *pluralityViewController = [[PluralityViewController alloc] initWithNibName:@"PluralityViewController" bundle:nil];
        
        [self.navigationController pushViewController:pluralityViewController animated:YES];
        [pluralityViewController release];
        //##########################################################################//
        
        
    }
    
    /*
    if (IDfileExists) {
        // if true Run Experiment 
        //##########################################################################//
        if (indexPath.section == 0 && indexPath.row == 4) {
            
            // before running experiment check to see if current voter already finished one of the experiments, if so then Create a New Voter ID //
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            // Go the the Completed Flag List and Determine if any of the Experiments were Completed //
            BOOL isAtLeastOneExperimentCompleted = NO;
            for (NSInteger i = 1; i <= kNumberOfVoterExperiments; i++) {
                
                if ([FileHandle getFlagStateForCompletedElectoralExperiment:i ] == 1) {
                    
                    // At Voting Experiment was Completed //
                    isAtLeastOneExperimentCompleted = YES;
                    
                    // Set Condition to Exit the for loop //
                    i = kNumberOfVoterExperiments +1;
                }
            }// end for loop
            
            // If at least on voting experiment was completed, then allow for the creation of anoter voter ID, else inform user of the other case //
            if (isAtLeastOneExperimentCompleted) {
                
                // Create a New Voter ID //
                // read in current voter data from file, but first get the file path //
                NSString *filepath = [FileHandle getFilePathForFileWithName:kCurrentVoterIDLogFileName];
                NSArray *voterData = [[NSArray alloc] initWithContentsOfFile:filepath];
                NSInteger voterID = [((NSNumber*)[voterData objectAtIndex:0]) integerValue];
                [voterData release];
                voterID++;
                
                NSNumber *zeroValue = [NSNumber numberWithInteger:0];
                
                NSMutableArray *updatedVoterData = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:voterID], nil];
                for (NSInteger j = 0; j < kNumberOfVoterExperiments; j++) {
                    [updatedVoterData addObject:zeroValue];
                }
                
                BOOL didFileSaveStatus = [updatedVoterData writeToFile:filepath atomically:YES];
                [updatedVoterData release];
                
                if (didFileSaveStatus == NO) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not save new voter ID to file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                
                [self.tableView reloadData];
            } 
            
            [experimentAdministrator runExperiment];
            
            // Load the First Experiment //
            PluralityViewController *pluralityViewController = [[PluralityViewController alloc] initWithNibName:@"PluralityViewController" bundle:nil];
            
            [self.navigationController pushViewController:pluralityViewController animated:YES];
            [pluralityViewController release];
            //##########################################################################//
            
            
        } else {
            
            // Voter Menu Selection //
            NSInteger voterCompletedFlag = [FileHandle getFlagStateForCompletedElectoralExperiment:(indexPath.row + 1)];
            
            if (voterCompletedFlag == 0) {
                
                if (indexPath.section == 0 && [((NSString*)[electoralExperimentList objectAtIndex:indexPath.row]) isEqualToString:kPlurality] ) {
                    
                    // Plurality Experiment //
                    PluralityViewController *pluralityViewController = [[PluralityViewController alloc] initWithNibName:@"PluralityViewController" bundle:nil];
                    [self.navigationController pushViewController:pluralityViewController animated:YES];
                    [pluralityViewController release];
                    
                } else if ( indexPath.section == 0 && [((NSString*)[electoralExperimentList objectAtIndex:indexPath.row]) isEqualToString:kRange] ){
                    
                    // Range Experiment //
                    RangeViewController *rangeViewController = [[RangeViewController alloc] initWithNibName:@"RangeViewController" bundle:nil];
                    [self.navigationController pushViewController:rangeViewController animated:YES];
                    [rangeViewController release];
                    
                } else if ( indexPath.section == 0 && [((NSString*)[electoralExperimentList objectAtIndex:indexPath.row]) isEqualToString:kIRV] ){
                    
                    // IRV Experiment //
                    IRVviewController *irvViewController = [[IRVviewController alloc] initWithNibName:@"IRVviewController" bundle:nil];
                    [self.navigationController pushViewController:irvViewController animated:YES];
                    [irvViewController release];
                    
                } else if ( indexPath.section == 0 && [((NSString*)[electoralExperimentList objectAtIndex:indexPath.row]) isEqualToString:kApproval] ){
                    
                    // Approval Experiment //
                    ApprovalViewController *approvalViewController = [[ApprovalViewController alloc] initWithNibName:@"ApprovalViewController" bundle:nil];
                    [self.navigationController pushViewController:approvalViewController animated:YES];
                    [approvalViewController release];
                    
                } 
                
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                
            } else if (indexPath.section == 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Denied" message:@"Ballot has already been cast by this voter for this experiment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            
        }// end else //

    }
     */  
        
    // Admin Menu Selection //
    if (indexPath.section == 1) {
        AdminViewController *adminViewController = [[AdminViewController alloc] initWithNibName:@"AdminViewController" bundle:nil];
        [self.navigationController pushViewController:adminViewController animated:YES];
        [adminViewController release];
    }
    
    if (indexPath.section == 2) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UserDemographicsViewController *userDemographicsController = [[UserDemographicsViewController alloc] initWithNibName:@"UserDemographicsViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:userDemographicsController animated:YES];
    }
    
    /*
    // Create New Voter ID Selection //
    if (indexPath.section == 2) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // Go the the Completed Flag List and Determine if any of the Experiments were Completed //
        BOOL isAtLeastOneExperimentCompleted = NO;
        for (NSInteger i = 1; i <= kNumberOfVoterExperiments; i++) {
            
            if ([FileHandle getFlagStateForCompletedElectoralExperiment:i ] == 1) {
                
                // At Voting Experiment was Completed //
                isAtLeastOneExperimentCompleted = YES;
                
                // Set Condition to Exit the for loop //
                i = kNumberOfVoterExperiments +1;
            }
        }
        
        // If at least on voting experiment was completed, then allow for the creation of anoter voter ID, else inform user of the other case //
        if (isAtLeastOneExperimentCompleted) {
            
            // Create a New Voter ID //
            // read in current voter data from file, but first get the file path //
            NSString *filepath = [FileHandle getFilePathForFileWithName:kCurrentVoterIDLogFileName];
            NSArray *voterData = [[NSArray alloc] initWithContentsOfFile:filepath];
            NSInteger voterID = [((NSNumber*)[voterData objectAtIndex:0]) integerValue];
            [voterData release];
            voterID++;
            
            NSNumber *zeroValue = [NSNumber numberWithInteger:0];
            
            NSMutableArray *updatedVoterData = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:voterID], nil];
            for (NSInteger j = 0; j < kNumberOfVoterExperiments; j++) {
                [updatedVoterData addObject:zeroValue];
            }
            
            BOOL didFileSaveStatus = [updatedVoterData writeToFile:filepath atomically:YES];
            [updatedVoterData release];
            
            if (didFileSaveStatus == NO) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not save new voter ID to file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            
            [self.tableView reloadData];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Voter Action Required" message:@"This Voter Must Complete at Least One Voting Experiment Before Creating a New Voter ID." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
     */
}

#pragma mark - Memory stuff

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)dealloc
{
    [electoralExperimentList release];
    [super dealloc];
}

@end
