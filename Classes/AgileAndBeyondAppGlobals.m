//
//  AgileAndBeyondAppGlobals.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/10/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "AgileAndBeyondAppGlobals.h"

/*
NSDictionary* AABSessions;
NSDictionary* AABPeople;
NSArray* AABNews;
*/


// fonts
// TODO use static variables defined once (?)


UIFont* getFontDefault()
{
  return [UIFont fontWithName:@"Helvetica" size:15.0];
};


UIFont* getFontSessionListCell()
{
  return getFontDefault();
}


UIFont* getFontSessionListCellSubtitle()
{
  return getFontDefault();
}

UIFont* getFontSessionDetailCell()
{
  return getFontDefault();
}

UIFont* getFontSessionDetailCellSubtitle()
{
  return getFontDefault();
}

UIFont* getFontPersonDetailCell()
{
  return getFontDefault();
}

UIFont* getFontPersonDetailCellSubtitle()
{
  return getFontDefault();
}
