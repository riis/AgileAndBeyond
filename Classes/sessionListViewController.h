//
//  sessionListViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface sessionListViewController : UITableViewController {
  NSArray* filteredSessionList;
}

@property (nonatomic, retain) NSArray* filteredSessionList;

@end
