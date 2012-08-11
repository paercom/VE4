//
//  EmailComposerViewController.h
//  ElectoralExperiment
//
//  Created by Stefan Agapie on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FileHandle.h"
#import "ElectoralExperiments.h"

@interface EmailComposerViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITextField *toTextField;
@property (retain, nonatomic) IBOutlet UITextField *ccTextField;
@property (retain, nonatomic) IBOutlet UITextField *bccTextField;

- (IBAction)composeEmailButton:(id)sender;
@end
