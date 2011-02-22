//
//  personDetailsViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/4/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLFetcher.h"

@interface personDetailsViewController : UITableViewController 
{
  NSString* myPerson;
  URLFetcher* imageFetcher;
  UIImage* image;
  NSArray* sessions;
}

@property (nonatomic, retain) NSString* myPerson;
@property (nonatomic, retain)  URLFetcher* imageFetcher;
@property (nonatomic, retain)  UIImage* image;
@property (nonatomic, retain) NSArray* sessions;
@end
