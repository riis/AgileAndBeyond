//
//  session.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/28/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "session.h"
#import "AgileAndBeyondAppGlobals.h"

NSDate* AABDateOfFirstSlot;
NSDate* AABDateOfSecondSlot;
NSDate* AABDateOfWelcome;
NSDate* AABDateOfOpeningKeynote;
NSDate* AABDateOfLunch;
NSDate* AABDateOfClosingKeynote;
NSDate* AABDateOfClosingSummary;

NSDateFormatter* AABDateConstFormatter;
NSDateFormatter* AABDateSectionTitleFormmater;

NSString* getIdOfSession(NSDictionary*session)
{
  NSString* id = nil;
  NSArray* all_ids =  [AABSessions allKeysForObject:session];
  BUGOUT(@"Hello from %s", __func__);
  BUGOUT(@"Number of ids found is : %d", [all_ids count]);
  if([all_ids count] == 1)
    {
      id = [all_ids objectAtIndex:0];
      BUGOUT(@"Session id found is %@",id);
      if(id) [id retain];
    }		
  return id;
}

//this one dumps a nested dictionary structure to log
void dumpNestedDictToLog(NSDictionary* dict)
{
#ifdef CONFIGURATION_Debug
  NSEnumerator *enumerator;
  id	key = nil,
    obj = nil;
	
  if([dict isKindOfClass:[NSDictionary class]])
    {
      enumerator = [dict keyEnumerator];
      BUGOUT(@"size of dict is %d", [dict count]); 
      while (key = [enumerator nextObject]) {
	obj = [dict objectForKey:key];
	BUGOUT(@"%@ : %@", key, obj);
	dumpNestedDictToLog(obj); // then recurse
      }
    }
  else if([dict isKindOfClass:[NSArray class]])
    {
      enumerator = [dict objectEnumerator]; 
      BUGOUT(@"size of array is %d", [dict count]); 
      while (obj = [enumerator nextObject]) {
	BUGOUT(@"array element is %@", obj);
	dumpNestedDictToLog(obj);
      }
    }
  else if([dict isKindOfClass:[NSString class]]) {
    BUGOUT(@"string is %@",dict);
    return;
  }
  else {
    BUGOUT(@"Null or something unrecognized");
  }
#endif
}

void populateInitialData()
{
  AABSessions = nil;
  NSString* plistPath;
  
  AABDateConstFormatter = [[NSDateFormatter alloc] init];
  [AABDateConstFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  [(AABDateOfFirstSlot = [AABDateConstFormatter dateFromString:@"2011-03-12 10:15"])
    retain];
  [(AABDateOfSecondSlot = [AABDateConstFormatter dateFromString:@"2011-03-12 12:30"])
    retain];
  [(AABDateOfWelcome = [AABDateConstFormatter dateFromString:@"2011-03-12 8:30"])
    retain];
  [(AABDateOfOpeningKeynote = [AABDateConstFormatter dateFromString:@"2011-03-12 8:45"])
    retain];
  [(AABDateOfLunch = [AABDateConstFormatter dateFromString:@"2011-03-12 11:30"])
    retain];
  [(AABDateOfClosingKeynote = [AABDateConstFormatter dateFromString:@"2011-03-12 15:15"])
    retain];
  [(AABDateOfClosingSummary = [AABDateConstFormatter dateFromString:@"2011-03-12 16:15"])
    retain];

  
  AABDateSectionTitleFormmater = [[NSDateFormatter alloc] init];
  [AABDateSectionTitleFormmater setDateFormat:@"EEE, MMMM d h:mm a"];
  
  BUGOUT(@"AABDateOfFirstSlot is %@",  AABDateOfFirstSlot);
  
  plistPath = [[NSBundle mainBundle] pathForResource:@"AAB2011-initial" ofType:@"plist"];
  AABSessions = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  if(AABSessions)
    {
      BUGOUT(@"I loaded in a plist as AABSessions from %@, and its got %d elements",  
	     plistPath,
	     [AABPeople count]);
    }
  else 
    {
      BUGOUT(@"Tried to load dictionary but ended up with nil, using path %@",plistPath);
    }

  plistPath = [[NSBundle mainBundle] pathForResource:@"AAB2011-people" ofType:@"plist"];
  AABPeople = [NSDictionary dictionaryWithContentsOfFile:plistPath];

  if(AABPeople)
    {
      BUGOUT(@"I loaded in a plist as AABPeople from %@, and its got %d elements", 
	     plistPath,
	     [AABPeople count]);
    }
  else 
    {
      BUGOUT(@"Tried to load dictionary but ended up with nil, using path %@",plistPath);
    }
  
 
  // TODO memory
  [AABSessionsArray retain];
  [AABSessions retain];
  [AABPeople retain];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  // Next, check and see if we have the user's selected sessions saved, and if so, load
  //  NSString* fromPrefs = nil;
  userSessionFirstSlot = [defaults objectForKey:@"userSessionFirstSlot"];
  userSessionSecondSlot = [defaults objectForKey:@"userSessionSecondSlot"];
  
}


//////////////////////////////////////////////////////////////////////// 
///                                            START Session implementation
//////////////////////////////////////////////////////////////////////// 

@implementation Session : NSObject
@synthesize identity, info;
			    
-(NSDate*) getStartTime
{
  return [info objectForKey:@"startTime"];
}

-(NSString*) getTitle
{
  return [info objectForKey:@"title"];
}

-(NSString*) getDescription
{
  return [info objectForKey:@"detail"];
}

-(NSArray*) getPeople
{
  return [info objectForKey:@"people"];
}

-(NSString*) getTrack
{
  return [info objectForKey:@"track"];
}

-(NSString*) getType
{
  return [info objectForKey:@"type"];
}

-(NSString*) getSubtype
{
  return [info objectForKey:@"subtype"];
}

-(BOOL) isAdvanced
{
  return [info objectForKey:@"isAdvanced"];
}

-(BOOL) isBeginner
{
  return [info objectForKey:@"isBeginner"];
}

-(BOOL) isIntermediate
{
  return [info objectForKey:@"startTime"];
}

-(sessionDetailsViewController*) getDetailViewController
{
  if(detailViewController)
    return detailViewController;
  else
    {
      // TODO refactor sessionDetailsViewController as well
      detailViewController = [sessionDetailsViewController createWithSession:info];
    }
  
}

-(UITableViewCell*) getSessionListViewCell
{
  if(sessionListViewCell)
    return sessionListViewCell;
  else
    return nil; // TODO create cell
}

-(void) memoryWarning
{
    
    
}
@end 
