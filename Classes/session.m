//
//  session.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/28/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "session.h"
#import "sessionListViewController.h"
#import "sessionDetailsViewController.h"
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

Session* userSessionFirstSlot;
Session* userSessionSecondSlot;

/* going away after refactoring
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
*/
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
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString* idUserSelectedFirstSlot = [defaults objectForKey:@"userSessionFirstSlot"];
  NSString* idUserSelecteSecondSlot = [defaults objectForKey:@"userSessionSecondSlot"];

  plistPath = [[NSBundle mainBundle] pathForResource:@"AAB2011-initial" ofType:@"plist"];
  AABSessionInfo = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  if(AABSessionInfo)
    {
      BUGOUT(@"I loaded in a plist as AABSessions from %@, and its got %d elements",  
	     plistPath,
	     [AABSessionInfo count]);

      AABSessions = [[NSMutableArray alloc] init];

      // There might be a more elegant method for doing this 
      NSArray* sessionIDs = [AABSessionInfo allKeys];
      for(NSString* id in sessionIDs)
	{
	  Session* s;
	  s = [Session createSessionWithIdentity:id
		       andDictionary:[AABSessionInfo objectForKey:id]];
	  [AABSessions addObject:s];
			
	  if([id isEqualToString:idUserSelectedFirstSlot])
	    userSessionFirstSlot = s;
	  else if([id isEqualToString:idUserSelecteSecondSlot])
	    userSessionSecondSlot = s;
	}
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
  [AABSessionInfo retain];
  [AABSessions retain];
  [AABPeople retain];
}


//////////////////////////////////////////////////////////////////////// 
///                                            START Session implementation
//////////////////////////////////////////////////////////////////////// 


@implementation Session : NSObject
@synthesize identity, info;
	 
+(Session*) createSessionWithIdentity:(NSString*)sessionId andDictionary:(NSDictionary*)sessionInfo
{
  Session* me = [[Session alloc] init];
  me.identity = sessionId;
  me.info = sessionInfo;
  return me;
}

+(Session*) userSelectedFirstSlot
{
  return userSessionFirstSlot;
}


+(Session*) userSelectedSecondSlot
{
  return userSessionSecondSlot;
}


-(BOOL) isUserSelected
{
  return self == userSessionFirstSlot || self == userSessionSecondSlot;
}

-(BOOL) isUserAttending
{
  return self.isUserSelected || 
    [identity isEqualToString:@"welcome"] ||
    [identity isEqualToString:@"opening-keynote"] ||
    [identity isEqualToString:@"closing-keynote"] ||
    [identity isEqualToString:@"closing-roundtable"] ||
    [identity isEqualToString:@"open-lunch"];
}

-(BOOL) isUserSelectedFirstSlot
{
  return self == userSessionFirstSlot;
}

-(BOOL) isUserSelectedSecondSlot
{
  return self == userSessionSecondSlot;
}

-(void) toggleSelection
{
  NSDate* sessionTime = [self timeStart];
  NSString* whichPref;
  Session** whichSlot;
  
  if ( [sessionTime isEqualToDate:AAB_FIRST_SLOT_DATE] )
    {
      whichSlot = &userSessionFirstSlot;
      whichPref = @"userSessionFirstSlot";
    }
  else if ( [sessionTime isEqualToDate:AAB_SECOND_SLOT_DATE] )
    {
      whichSlot = &userSessionSecondSlot;
      whichPref = @"userSessionSecondSlot";
    }
  else return; 

  if( self == *whichSlot )
    {
      [*whichSlot release]; // TODO review memory ownership logic here
      *whichSlot=nil;
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:whichPref];
    }
  else 
    {
      if ( *whichSlot != nil ) [*whichSlot release];
      *whichSlot = self;
      [*whichSlot retain]; // TODO review memory ownership logic here
      [[NSUserDefaults standardUserDefaults] setObject:identity forKey:whichPref];
    }

  // user selected slots has updated, reload mySessionsViewController
  
  if( getUserSessionsView() ) 
    {
      [getUserSessionsView().tableView reloadData];
    }
}


-(BOOL) isSelectable
{
  return 
    [self.timeStart isEqualToDate:AAB_FIRST_SLOT_DATE]
    || [self.timeStart isEqualToDate:AAB_SECOND_SLOT_DATE];
}
		    
-(NSDate*) timeStart
{
  return [info objectForKey:@"timeStart"];
}

-(NSString*) title
{
  return [info objectForKey:@"title"];
}

-(NSString*) description
{
  return [info objectForKey:@"detail"];
}

-(NSArray*) people
{
  return [info objectForKey:@"people"];
}

-(NSString*) track
{
  return [info objectForKey:@"track"];
}

-(NSString*) type
{
  return [info objectForKey:@"type"];
}

-(NSString*) subtype
{
  return [info objectForKey:@"subtype"];
}

-(BOOL) isAdvanced
{
  return [[info objectForKey:@"isAdvanced"] boolValue];
}

-(BOOL) isBeginner
{
  return [[info objectForKey:@"isBeginner"] boolValue];
}

-(BOOL) isIntermediate
{
  return [[info objectForKey:@"isIntermediate"] boolValue];
}

-(sessionDetailsViewController*) detailViewController
{
  if(detailViewController)
    return detailViewController;
  else
    {
      // TODO refactor sessionDetailsViewController as well
      return detailViewController = [sessionDetailsViewController createWithSession:self];
    }
}

-(UITableViewCell*) sessionListViewCell
{
  if(sessionListViewCell)
    return sessionListViewCell;
  else
    {
     
      static NSString *CellIdentifier = @"Cell";
        
      //thank you stackoverflow contributer Tim Rupe! other useful info at link 
      //http://stackoverflow.com/questions/129502/how-do-i-wrap-text-in-a-uitableviewcell-without-a-custom-cell
      // (and in documentation for UITextField)
      
      sessionListViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] retain];
      sessionListViewCell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
      sessionListViewCell.textLabel.numberOfLines=0;
      sessionListViewCell.textLabel.font = getFontDefault();

      sessionListViewCell.textLabel.text = [self title]; 
      sessionListViewCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
      return sessionListViewCell;
    }
}

-(void) memoryWarning
{
  // resourses :
  // isViewLoaded (on UIViewControllers)
  // 

  // note: We could do something more elaborate to avoid the case that new views are requested
  // and generated by the session class despite the old one still existing, eg having been retained
  // by a parent view... but I think this will occure infrequently and I don't think it is a problem.

  // TODO test this code ...
  if(detailViewController)
    {
      [detailViewController release];
      detailViewController = nil; 

    }
  if(sessionListViewCell)
    {
      [sessionListViewCell release];
      sessionListViewCell = nil;
    }
}
@end 
