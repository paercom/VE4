//
//  ElectoralExperiments.h
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

#define kElectoralExperimentHeader  @"VOTER"
#define kPlurality                  @"Plurality Voting Method"            
#define kPluralityNum               1
#define kRange                      @"Range Voting Method"
#define kRangeNum                   2
#define kIRV                        @"IRV (Ranked Choice) Voting Method"
#define kIRVNum                     3
#define kApproval                   @"Approval Voting Method"
#define kApprovalNum                4
#define kNumberOfVoterExperiments   4
#define kNumberOfRandomlySelectedExperimentsPerSession  4 // this is the number of experiments a single user will perform //

#define kMaxRangeValue              5
#define kMinRangeValue              0
#define kDefaultRangeValue          3

#define kRunExperiment              @"Run Experiment"

#define kAdminHeader                @"ADMINISTRATOR"
#define kAdmin                      @"Administrator Menu"

#define kNewVoterHeader             @"Voter ID"
#define kCreateNewVoterIDtitle      @"Create a New Voter ID"
#define kMainMenuTitle              @"Occupy Wall St. Voting Experiment"

#define kAlerViewCandidateCastConfirmationtitle @"Confirm Ballot"

#define kCandidateFileName                      @"CandidateList.data"

#define kCurrentVoterIDLogFileName              @"CurrentVoterID.data"

#define kPluralityDataFileName                  @"Plurality.data"
#define kPluralityStatsFileName                 @"PluralityStats.data"

#define kRangeDataFileName                      @"Range.data"
#define kRangeStatsFileName                     @"RangeStats.data"

#define kIRVdataFileName                        @"IRV.data"
#define kIRVstatsCat1FileName                   @"IRVstatsCat1.data"
#define kIRVstatsCat2FileName                   @"IRVstatsCat2.data"
#define kIRVstatsCat3FileName                   @"IRVstatsCat3.data"

#define kMaxNumberOfCandidatesInIRVlist         3
#define kMinNumberOfCandidatesInIRVlist         1

#define kApprovalDataFileName                   @"Approval.data"
#define kApprovalYayStatsFileName               @"ApprovalStatsYay.data"
#define kApprovalNayStatsFileName               @"ApprovalStatsNay.data"
#define kApprovalCategoryString                 @"Approve"
#define kDisapprovalCategoryString              @"Disapprove"

#define kDataViewerTitle                        @"Data View"
#define kStatsViewerTitle                       @"Stats View"
#define kIRV_DataResultsViewerTitle             @"IRV Results"

#define kVoidFlagValueForCompletedExperiment    999

#define kIRVMessagesFileName                    @"IRVMessages.data"
#define kRangeMessagesFileName                  @"RangeMessages.data"
#define kApprovalMessagesFileName               @"ApprovalMessages.data"
#define kPluralityMessagesFileName              @"PluralityMessages.data"

#define kPluralitySpreadsheetDataSetFilename    @"PluralitySpreadsheetDataSet.CSV"
#define kRangeSpreadsheetDataSetFilename        @"RangeSpreadsheetDataSet.CSV"
#define kIRVSpreadsheetDataSetFilename          @"IRVSpreadsheetDataSet.CSV"
#define kApprovalSpreadsheetDataSetFilename     @"ApprovalSpreadsheetDataSet.CSV"

#define kDefaultInstructionsMessage             @"@ This is where the instructions go. These instructions are editable from the admin menu. Tap outside this dialog box to dismiss these instructions. @"
#define kDefaultHeaderMessage                   @"@ What is it? @"

#define kSingleElementKey                       @"mySingleKey"

#define kFontSizeInInstructionsInPopOver        30
#define kFontSizeInViewHeader                   23
