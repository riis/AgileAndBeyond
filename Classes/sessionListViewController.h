//
//  sessionListViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sessionTableGroup : NSObject {
  NSArray* items;
  NSString* sectionTitle;
}

@property (nonatomic, retain) NSArray* items;
@property (nonatomic, retain) NSString* title;

@end

@interface sessionListViewController : UITableViewController {
  NSArray* filteredSessionLists;
}

@property (nonatomic, retain) NSArray* filteredSessionList;

@end
