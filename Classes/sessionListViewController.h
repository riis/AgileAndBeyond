//
//  sessionListViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/27/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tableViewSection : NSObject 
{ 
  NSString* title;
  NSPredicate* predicate;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSPredicate* predicate;
@end

@interface sessionTableGroup : NSObject 
{
  NSMutableArray* items;
  NSString* title;
  NSPredicate* predicate;
}
@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSPredicate* predicate;
@end

@interface sessionListViewController : UITableViewController 
{
  NSMutableArray* filteredSessionLists;
  NSPredicate* filter;
}
//@property (nonatomic, retain) NSArray* allSessions;
@property (nonatomic, retain) NSMutableArray* filteredSessionLists;
@property (nonatomic, retain) NSPredicate* filter;

+(sessionListViewController*)createUsingGroupList:(NSArray*)groups filterBy:(NSPredicate*)filterPerdicate;

@end

@interface subscribedSessionsListViewController : sessionListViewController 
{
}

-(id) init;
-(id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle;
- (id)initWithCoder:(NSCoder *)decoder;
@end 

// this function only gets used once in the implementation of sessionDetailViewController1
sessionListViewController* getUserSessionsView();

// ? 
//sessionListViewController* mySessionsViewController;
