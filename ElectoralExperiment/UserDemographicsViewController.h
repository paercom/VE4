//
//  UserDemographicsViewController.h
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

#import <UIKit/UIKit.h>

@interface UserDemographicsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    
}

@property (retain, nonatomic) IBOutlet UITextField *otherHispanicTextField;
@property (retain, nonatomic) IBOutlet UITextField *otherTribeTextField;
@property (retain, nonatomic) IBOutlet UITextField *otherAsianTextField;
@property (retain, nonatomic) IBOutlet UITextField *otherRaceTextField;

@property (retain, nonatomic) IBOutlet UITextField *otherGenderTextField;

@property (retain, nonatomic) IBOutlet UITextView *importantIssueTextView;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;

// -------------------- non xib properties ------------------ //
@property (retain, nonatomic) NSMutableArray *partyAffiliationArray;

@end
