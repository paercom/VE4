//
//  IRVinstructionsViewController.h
//  ElectoralExperiment
//
//  Created by Stefan Agapie on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRVinstructionsViewController;

@protocol IRVPopoverDelegate <NSObject>

- (void)IRVPopoverDidAppear:(IRVinstructionsViewController*)popoverViewController;
- (void)IRVPopoverDidDisappear:(IRVinstructionsViewController*)popoverViewController;

@end

@interface IRVinstructionsViewController : UIViewController {
    id <IRVPopoverDelegate> popoverDelegate;
}
@property (nonatomic, assign) id <IRVPopoverDelegate> popoverDelegate;

@property (retain, nonatomic) IBOutlet UITextView *instructionsBlock;
@end
