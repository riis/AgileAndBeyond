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

@interface Message : NSObject {
  SEL action;
  id target;
}
@property () SEL action;
@property (retain) id target;

-(void) send;
-(Message*) initWithSelector:(SEL)selector forTarget:(id)destination;

@end
