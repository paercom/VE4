//
//  IRV_ResultsViewController.h
//  ElectoralExperiment3
//
//  Created by Stefan Agapie on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRV_ResultsViewController : UIViewController

@property (nonatomic, retain) NSDictionary *dataDictionary;
@property (retain, nonatomic) IBOutlet UITextView *IRV_ResultsTextView;

@end
