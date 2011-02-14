//
//  Message.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/14/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "Message.h"
#import "AgileAndBeyondAppGlobals.h"

@implementation Message
@synthesize action, target;

-(Message*) initWithSelector:(SEL)selector forTarget:(id)destination
{
  [super init];
  self.action = selector;
  self.target = destination;
  return self;
}

-(void) send
{
  // do some sanity checking, then perform selector if it looks OK
  if(! (target && action) ) 
    BUGOUT(@"in %s, WARNING target or action was nil", __func__);
  else if(! [target respondsToSelector:action] )
    BUGOUT(@"in %s, WARNING target %@ does not respond to action %@",__func__,target,action);
  else 
    [target performSelector:action]; 
}

@end
