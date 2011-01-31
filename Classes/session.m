//
//  session.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "session.h"



//this one dumps a nested dictionary structure to log
void dumpNestedDictToLog(NSDictionary* dict)
{
	NSEnumerator *enumerator;
	id	key = nil,
	obj = nil;
	
	if([dict isKindOfClass:[NSDictionary class]])
	{
		enumerator = [dict keyEnumerator];
		NSLog(@"size of dict is %d", [dict count]); 
	    while (key = [enumerator nextObject]) {
			obj = [dict objectForKey:key];
			NSLog(@"%@ : %@", key, obj);
			dumpNestedDictToLog(obj); // then recurse
		}
	}
	else if([dict isKindOfClass:[NSArray class]])
	{
		enumerator = [dict objectEnumerator]; 
		NSLog(@"size of array is %d", [dict count]); 
		while (obj = [enumerator nextObject]) {
			NSLog(@"array element is %@", obj);
			dumpNestedDictToLog(obj);
		}
	}
	else if([dict isKindOfClass:[NSString class]]) {
		NSLog(@"string is %@",dict);
		return;
	}
	else {
		NSLog(@"Null or something unrecognized");
	}
}

void populateInitialData()
{
  AABSessions = nil;
  NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"AAB2011-initial" ofType:@"plist"];

  AABSessions = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  // TODO memory
  [AABSessions retain];

  if(AABSessions)
    {
      NSLog(@"I loaded in a plist as AABSessions from %@", plistPath);
      //dumpNestedDictToLog(AABSessions);
    }
  else 
    {
      NSLog(@"Tried to load dictionary but ended up with nil, using path %@",plistPath);
    }

}
