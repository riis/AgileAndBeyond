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
@synthesize selector, target;

-(Message*) initWithSelector:(SEL)sel forTarget:(id)dest
{
  [super init];
  self.selector = sel;
  self.target = dest;
  return self;
}

-(void) send
{
  BUGOUT(@"hello from %s", __func__);

  // do some sanity checking, then perform selector if it looks OK
  if(! (target && selector) ) 
    BUGOUT(@"in %s, WARNING target or action was nil", __func__);
  else if(! [target respondsToSelector:selector] )
    BUGOUT(@"in %s, WARNING target %@ does not respond to action %@",__func__,target,selector);
  else 
    [target performSelector:selector]; 
}


-(void) trigger 
{
  [self send];
}
@end


@implementation voidClosure

-(void) trigger
{
  block();
}
@end
