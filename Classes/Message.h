//
//  Message.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/14/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//
// This is a sort of simple encapsalation of a selector +
//   an object to call it.
//  simpler than some elaborate and flexable schemes built into the apple SDK

#import <Foundation/Foundation.h>

@protocol Action
-(void) trigger;
@end


@interface Message : NSObject < Action > 
{
  SEL selector;
  id target;
}
@property () SEL selector;
@property (retain) id target;

-(void) trigger;
-(void) send;
-(Message*) initWithSelector:(SEL)sel forTarget:(id)dest;

@end

@interface voidClosure : NSObject < Action > 
{
  void (^block)();
}

-(void) trigger;

@end
