//
//  personDetailsViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/4/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface personDetailsViewController : UITableViewController 
{
  NSString* myPerson;
}

@property (nonatomic, retain) NSString* myPerson;
@end
