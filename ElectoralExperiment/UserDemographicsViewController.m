//
//  UserDemographicsViewController.m
//  ElectoralExperiment
//
//  Created by Stefan Agapie on 8/5/12.
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

#import "UserDemographicsViewController.h"

@interface UserDemographicsViewController () {
    CGPoint svos;
}

@end

@implementation UserDemographicsViewController
@synthesize otherHispanicTextField;
@synthesize otherTribeTextField;
@synthesize otherAsianTextField;
@synthesize otherRaceTextField;
@synthesize otherGenderTextField;
@synthesize importantIssueTextView;
@synthesize myScrollView;

// -------------------- non xib properties ------------------ //
@synthesize partyAffiliationArray = _partyAffiliationArray;

#pragma mark
#pragma mark Lazy Instantiation
- (NSMutableArray*)partyAffiliationArray
{
    if (_partyAffiliationArray == nil) {
        _partyAffiliationArray = [[NSMutableArray alloc] initWithObjects:@"@ Default Party (1) @", @"@ Default Party (2) @", @"@ Default Party (3) @", @"@ Default Party (4) @", @"@ Default Party (5) @", nil];
    }
    return _partyAffiliationArray;
}


#pragma mark
#pragma mark UIPickerView Delegate & Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{ return 1; }

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{ return [self.partyAffiliationArray count]; }

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{ return ((component == 0) ? ( [self.partyAffiliationArray objectAtIndex:row]): NULL); }


#pragma mark
#pragma mark TextField Delegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text Field Did Begin Editing");  
    
    svos = self.myScrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [self.otherHispanicTextField bounds];
    rc = [self.otherHispanicTextField convertRect:rc toView:self.myScrollView];
    pt = rc.origin;
    
    switch (textField.tag) {
        case 0:
            pt.x = 0;
            pt.y -= 225;
            break;
        case 1:
            pt.x = 0;
            pt.y -= 100;
            break;
        case 2:
            pt.x = 0;
            pt.y -= -75;
            break;
        case 3:
            pt.x = 0;
            pt.y -= -120;
            break;
        case 4:
            pt.x = 0;
            pt.y -= 45;
            break;            
        default:
            break;
    }
    
    [self.myScrollView setContentOffset:pt animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:svos animated:YES];
    [textField resignFirstResponder];
}

#pragma mark
#pragma mark Text View delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"Text View Did Begin Editing");
    
    
    svos = self.myScrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [self.otherHispanicTextField bounds];
    rc = [self.otherHispanicTextField convertRect:rc toView:self.myScrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= -120;
    
    [self.myScrollView setContentOffset:pt animated:YES];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.myScrollView setContentOffset:svos animated:YES];
    [textView resignFirstResponder];
}

#pragma mark
#pragma mark View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.otherHispanicTextField.delegate = self;
    self.otherTribeTextField.delegate = self;
    self.otherAsianTextField.delegate = self;
    self.otherRaceTextField.delegate = self;
    
    self.otherGenderTextField.delegate = self;
    
    self.importantIssueTextView.delegate = self;
}

- (void)viewDidUnload
{
    [self setOtherHispanicTextField:nil];
    [self setMyScrollView:nil];
    [self setOtherTribeTextField:nil];
    [self setOtherAsianTextField:nil];
    [self setOtherRaceTextField:nil];
    [self setOtherGenderTextField:nil];
    [self setImportantIssueTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [otherHispanicTextField release];
    [myScrollView release];
    [otherTribeTextField release];
    [otherAsianTextField release];
    [otherRaceTextField release];
    [otherGenderTextField release];
    [importantIssueTextView release];
    [super dealloc];
}
@end
