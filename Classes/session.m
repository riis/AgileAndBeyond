//
//  session.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "session.h"


NSString* getIdOfSession(NSDictionary*session)
{
  NSString* id = nil;
  NSArray* all_ids =  [AABSessions allKeysForObject:session];
  NSLog(@"Hello from %s", __func__);
  NSLog(@"Number of ids found is : %d", [all_ids count]);
  if([all_ids count] == 1)
    {
      id = [all_ids objectAtIndex:0];
      NSLog(@"Session id found is %@",id);
      if(id) [id retain];
    }
		
  return id;
}

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

  plistPath = [[NSBundle mainBundle] pathForResource:@"AAB2011-people" ofType:@"plist"];
  AABPeople = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  // TODO memory
  [AABSessions retain];
  [AABPeople retain];

  if(AABSessions)
    {
      NSLog(@"I loaded in a plist as AABSessions from %@, and its got %d elements",  
	    plistPath,
	    [AABPeople count]);
      //dumpNestedDictToLog(AABSessions);
    }
  else 
    {
      NSLog(@"Tried to load dictionary but ended up with nil, using path %@",plistPath);
    }
  if(AABPeople)
    {
      NSLog(@"I loaded in a plist as AABSessions from %@, and its got %d elements", 
	    plistPath,
	    [AABPeople count]);
      //dumpNestedDictToLog(AABSessions);
    }
  else 
    {
      NSLog(@"Tried to load dictionary but ended up with nil, using path %@",plistPath);
    }

}
