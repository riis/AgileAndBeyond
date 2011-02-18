//
//  sessionListViewController.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/27/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "sessionListViewController.h"
#import "AgileAndBeyondAppGlobals.h"
#import "sessionDetailsViewController.h"
#import "session.h"

@implementation tableViewSection
@synthesize title, predicate;
@end

@implementation sessionTableGroup
@synthesize items, title, predicate;
@end

@implementation sessionListViewController
@synthesize filteredSessionLists,filter;

+(sessionListViewController*)createUsingGroupList:(NSArray*)groups
				     filterBy:(NSPredicate*)filterPredicate
{
  sessionListViewController* me = [[sessionListViewController alloc] init ];
  // for future consideration, retaining the bigListRef if needed to update our sessions list
  // TODO : rename allSessions if it is actually "our filtered list of sections"
  //   - or - do the filtering somewhere else, like in viewWillAppear
  
  /* don't think I'm using this (remove later)
  if(filterPredicate!=nil)
    [me setAllSessions:[bigListRef filteredArrayUsingPredicate:filterPredicate]];
  else
    [me setAllSessions:bigListRef];
  */

  // create filterSessionList
  // we won't fill in items yet, lets let that happen in viewWillAppear for now

  if( groups != nil)  
    {
      for( tableViewSection* section in groups ) 
	{
	  sessionTableGroup* newGroup = [[sessionTableGroup alloc] init];
	  newGroup.predicate = section.predicate;
	  newGroup.title = section.title; 
	  [[me filteredSessionLists] addObject:newGroup];
	  [newGroup release];
	}
    }

  [me setFilter:filterPredicate];
  return me;
}

- (id)init
{
  BUGOUT(@"!!!!!!hello from %s",__func__);
  [self setFilteredSessionLists:[[NSMutableArray alloc] init]]; 
  return [super initWithNibName:@"sessionListViewController" bundle:nil];
}

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
  //  just igore nibname and bundle, since there is only one we'd want 
  // to use, and we put it in via -(id)init
  return [self init];
}

/*
- (id)initWithCoder:(NSCoder *)decoder
{
  [self init];
  return [super initWithCoder:decoder];
}
*/

#pragma mark -
#pragma mark View lifecycle

/*
  - (void)viewDidLoad {
  [super viewDidLoad];
  // put a button on the navigaation bar, eg
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  }
*/

- (void)viewWillAppear:(BOOL)animated 
{
  // populate an array with refrences to the sessions we will display, in the order we want
  // if we were not created using createWithArray, then function as the "My Sessions" list
  
  if(![filteredSessionLists count])
     BUGOUT(@"WARNING in %s: filteredSessionLists empty, (probably not what we wanted).", __func__);

   for( sessionTableGroup* section in filteredSessionLists )
      section.items = [NSMutableArray 
			arrayWithArray:
			  [AABSessions filteredArrayUsingPredicate:section.predicate]];
   
  // TODO : sort filtered arrays
  // TODO : memory management : check this: we want arrays of refrences
  
  // TODO : don't do a reload data each time it displays, only when userSEssions has been updated
  [self.tableView reloadData];
  [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  return [filteredSessionLists count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  return [[[filteredSessionLists objectAtIndex:section] items] count] ;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
  return [[filteredSessionLists objectAtIndex:section] title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
  NSArray* myFilteredList = [[filteredSessionLists objectAtIndex:[indexPath indexAtPosition:0]] items];
  Session* mySession = [myFilteredList objectAtIndex:[indexPath indexAtPosition:1]];

  return [mySession sessionListViewCell];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray* myFilteredList = [[filteredSessionLists objectAtIndex:[indexPath indexAtPosition:0]] items];
  Session* mySession = [myFilteredList objectAtIndex:[indexPath indexAtPosition:1]];
    
  // can use the setSelected:animated: instead to cause an animated change to selected
  // TODO : don't want this to be hardcoded ~ maybe pull filteredsessions lists from mySessionsView
  //  if(
  cell.selected = 
    mySession.isUserAttending;
    // )
    // {
      //cell.accessoryType=UITableViewCellAccessoryCheckmark;
    //    }
    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
  // Navigation logic, Create and push another view controller.
  NSArray* myFilteredList = [[filteredSessionLists objectAtIndex:[indexPath indexAtPosition:0]] items];  
  Session* whichSession = [myFilteredList objectAtIndex:[indexPath indexAtPosition:1]];
  sessionDetailsViewController *detailViewController = 
    [whichSession detailViewController];
  
  // Pass the selected object to the new view controller.
  [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{ 
  // TODO memory
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
  // TODO memory
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}

- (void)dealloc 
{
  if( filteredSessionLists ) 
    [filteredSessionLists release]; // will release on each of contents if dealloced
  //  if( allSessions ) [ allSessions release ];
  if( filter ) [ filter release ];

  [super dealloc];
}

@end



subscribedSessionsListViewController* userSessionsView;

sessionListViewController* getUserSessionsView()
{
  return userSessionsView;
}

@implementation subscribedSessionsListViewController : sessionListViewController 
- (id)init
{
  BUGOUT(@"!!!!!!hello from %s",__func__);

  [super init];

  // populate an array with refrences to the sessions we will display, in the order we want
  // ** ** set up My Session view here 

  userSessionsView = self;
  [self retain];
      
  sessionTableGroup* newSection;
  NSMutableArray* sectionDates = [[NSMutableArray alloc] 
				   initWithObjects:
				     AAB_OPENINGKEYNOTE_DATE, 
				   AAB_FIRST_SLOT_DATE, AAB_LUNCH_DATE, AAB_SECOND_SLOT_DATE,
				   AAB_CLOSINGKEYNOTE_DATE,AAB_CLOSINGSUMMARY_DATE,nil];
  for(NSDate* thisDate in sectionDates )
    {
      newSection = [[sessionTableGroup alloc] init];
      newSection.title = [AABDateSectionTitleFormmater stringFromDate:thisDate];
	  
      if( [thisDate isEqualToDate:AAB_FIRST_SLOT_DATE] )
	{
	  if ( userSessionFirstSlot != nil ) 
	    {
	      BUGOUT(@"adding %@ for first slot",userSessionFirstSlot );
	      //		      [
	      (newSection.items = [NSArray arrayWithObject:[AABSessions objectForKey:userSessionFirstSlot]]);
	      //	release];
	    }   
	}
      else if( [thisDate isEqualToDate:AAB_SECOND_SLOT_DATE] )
	{
	  if ( userSessionSecondSlot != nil )
	    {
	      BUGOUT(@"adding %@ for second slot",userSessionSecondSlot );
	      //	 	      [
	      (newSection.items =  [NSArray arrayWithObject:[AABSessions objectForKey:userSessionSecondSlot]]);
	      // release];
	    }
	}
      else
	{
	  newSection.predicate=[NSPredicate predicateWithFormat:@"timeStart == %@", thisDate];
	  newSection.items = [NSMutableArray 
			       arrayWithArray:
				 [[AABSessions allValues] filteredArrayUsingPredicate:newSection.predicate]];
	}
      BUGOUT(@"adding section %@", newSection.title );
      [filteredSessionLists addObject:newSection];

      [newSection release];  
    }

  BUGOUT(@"in %s, fisteredSessionLists is %d long,",__func__ ,[filteredSessionLists count] );
  BUGOUT(@"in %s, sectionDates is %d long,",__func__ ,[sectionDates count] );

  [sectionDates release];

  return self;
  //  return [super initWithNibName:@"sessionListViewController" bundle:nil];
}

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
  //  just igore nibname and bundle, since there is only one we'd want 
  // to use, and we put it in via -(id)init
  return [self init];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  [self init];
  return [super initWithCoder:decoder];
}

- (void)viewWillAppear:(BOOL)animated 
{
  // reload the data
  // TODO this belongs somewhere else, like in a refreshme function
  // TODO a less fragile implementation
  sessionTableGroup* thisSection = [filteredSessionLists objectAtIndex:1];
  
  // TODO reuse old array if nothing changed(?)
  [(thisSection.items = [[NSMutableArray alloc] init]) release];
      
  if ( userSessionFirstSlot != nil ) 
    {
      BUGOUT(@"adding %@ for first slot",userSessionFirstSlot );
      [thisSection.items addObject:[AABSessions objectForKey:userSessionFirstSlot]];
    }

  thisSection = [filteredSessionLists objectAtIndex:3];
  [(thisSection.items = [[NSMutableArray alloc] init]) release];
  if ( userSessionSecondSlot != nil )
    {
      BUGOUT(@"adding %@ for second slot",userSessionSecondSlot );
      [thisSection.items addObject:[AABSessions objectForKey:userSessionSecondSlot]];
    }
  
  [self.tableView reloadData]; 
}

@end 
