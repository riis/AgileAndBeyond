//
//  sessionListViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tableViewSection : NSObject { 
  NSString* title;
  NSPredicate* predicate;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSPredicate* predicate;
@end

@interface sessionTableGroup : NSObject {
  NSArray* items;
  NSString* title;
  NSPredicate* predicate;
}


@property (nonatomic, retain) NSArray* items;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSPredicate* predicate;
@end

@interface sessionListViewController : UITableViewController {
  NSArray* allSessions;
  NSMutableArray* filteredSessionLists;
  NSPredicate* filter;
  BOOL isUserSession;
}

@property (nonatomic, retain) NSArray* allSessions;
@property (nonatomic, retain) NSMutableArray* filteredSessionLists;
@property (nonatomic, retain) NSPredicate* filter;
@property (nonatomic) BOOL isUserSession;

//+ (void)initialize; 

@end
