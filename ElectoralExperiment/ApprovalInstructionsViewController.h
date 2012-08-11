//
//  ApprovalInstructionsViewController.h
//  ElectoralExperiment
//
//  Created by Stefan Agapie on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApprovalInstructionsViewController;

@protocol ApprovalPopoverDelegate <NSObject>

- (void)approvalPopoverDidAppear:(ApprovalInstructionsViewController*)popoverViewController;
- (void)approvalPopoverDidDisappear:(ApprovalInstructionsViewController*)popoverViewController;

@end

@interface ApprovalInstructionsViewController : UIViewController {
    id <ApprovalPopoverDelegate> popoverDelegate;
}
@property (nonatomic, assign) id <ApprovalPopoverDelegate> popoverDelegate;

@property (retain, nonatomic) IBOutlet UITextView *instructionsBlock;
@end
