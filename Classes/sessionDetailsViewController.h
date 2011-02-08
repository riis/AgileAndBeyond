//
//  sessionDetailsViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/3/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface sessionDetailsViewController : UITableViewController 
{
  NSDictionary* mySession;
}

@property (nonatomic,retain) NSDictionary* mySession;
+ (sessionDetailsViewController*) createWithSession:(NSDictionary*)session;

@end
