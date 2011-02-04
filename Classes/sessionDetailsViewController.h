//
//  sessionDetailsViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/3/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface sessionDetailsViewController : UITableViewController {
  NSDictionary* mySession;
  BOOL isUserSession;
}

@property (nonatomic,retain) NSDictionary* mySession;
@property (nonatomic) BOOL isUserSession;
@end
