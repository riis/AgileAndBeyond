//
//  personListViewController.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/24/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface personListViewController : UITableViewController 
{
  NSArray* peopleArray;
}

@property ( retain, nonatomic ) NSArray* peopleArray;
@end
