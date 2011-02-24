//
//  sessionDetailsViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/3/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "session.h"

@interface sessionDetailsViewController : UITableViewController  <UIGestureRecognizerDelegate>
{
  Session* mySession;
 

    UITapGestureRecognizer *tapRecognizer;

    UISwipeGestureRecognizer *swipeLeftRecognizer;

 
    UISegmentedControl *segmentedControl;
}

@property (nonatomic,retain) Session* mySession;
 

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;

 

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
+ (sessionDetailsViewController*) createWithSession:(Session*)session;

- (IBAction)takeLeftSwipeRecognitionEnabledFrom:(UISegmentedControl *)aSegmentedControl;


@end
