//
//  RangeInstructionsViewController.h
//  ElectoralExperiment
//
//  Created by Stefan Agapie on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@class RangeInstructionsViewController;

@protocol RangePopoverDelegate <NSObject>

- (void)rangePopoverDidAppear:(RangeInstructionsViewController*)popoverViewController;
- (void)rangePopoverDidDisappear:(RangeInstructionsViewController*)popoverViewController;

@end

@interface RangeInstructionsViewController : UIViewController {
    id <RangePopoverDelegate> popoverDelegate;
}
@property (nonatomic, assign) id <RangePopoverDelegate> popoverDelegate;

@property (retain, nonatomic) IBOutlet UITextView *instructionsBlock;
@end
