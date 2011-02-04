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
@synthesize filteredSessionLists,allSessions,filter;

+(sessionListViewController*)createUsingArray:(NSArray*)bigListRef
				    groupList:(NSArray*)groups
				     filterBy:(NSPredicate*)filterPredicate
{
  sessionListViewController* me = [[[self alloc] initWithNibName:@"sessionListViewController" bundle:nil] autorelease];

  // for future consideration, retaining the bigListRef if needed to update our sessions list
  // TODO : rename allSessions if it is actually "our filtered list of sections"
  //   - or - do the filtering somewhere else, like in viewWillAppear
  if(filterPredicate!=nil)
    [me setAllSessions:[bigListRef filteredArrayUsingPredicate:filterPredicate]];
  else
    [me setAllSessions:bigListRef];

  // create filterSessionList
  // we won't fill in items yet, lets let that happen in viewWillAppear for now
  if( groups != nil)  
    {
      if ( [me filteredSessionLists] == nil ) 
	[me setFilteredSessionLists:[[NSMutableArray alloc] init]]; 
      for( tableViewSection* section in groups ) 
	{
	  sessionTableGroup* newGroup = [[sessionTableGroup alloc] init];
	  newGroup.predicate = section.predicate;
	  newGroup.title = section.title;	  
	  [[me filteredSessionLists] addObject:newGroup];
	}
    }

  [me setFilter:filterPredicate];
    
  return me;
}

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
  // TODO possibly move this stuff into init functions properly
  //  NSLog(@"hello from %s", __func__);

  if(allSessions == nil || isUserSession == true)
    {
      NSLog(@"hello from %s : in block to set up ussersessions", __func__);
      isUserSession = true;

      [self setFilteredSessionLists:[[NSMutableArray alloc] init]]; 
      
      sessionTableGroup* newSection;
      newSection = [[sessionTableGroup alloc] init];
      newSection.title = [AAB_FIRST_SLOT_DATE descriptionWithCalendarFormat:DATE_FORMAT_STRING timeZone:nil 
					      locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
      newSection.predicate=[NSPredicate predicateWithFormat:@"timeStart == %@", AAB_FIRST_SLOT_DATE];
      newSection.items = [[NSMutableArray alloc] init];
      if ( userSessionFirstSlot != nil ) 
	{
	  NSLog(@"adding %@ for first slot",userSessionFirstSlot );
	  [newSection.items addObject:[AABSessions objectForKey:userSessionFirstSlot]];
	}
      [filteredSessionLists addObject:newSection];
      newSection = [[sessionTableGroup alloc] init];
      newSection.title = [AAB_SECOND_SLOT_DATE descriptionWithCalendarFormat:DATE_FORMAT_STRING timeZone:nil 
					       locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
      newSection.predicate =  [NSPredicate predicateWithFormat:@"timeStart == %@", AAB_SECOND_SLOT_DATE];
      newSection.items = [[NSMutableArray alloc] init];
      if ( userSessionSecondSlot != nil )
	[newSection.items addObject:[AABSessions objectForKey:userSessionSecondSlot]];
      [filteredSessionLists addObject:newSection];
      [self.tableView reloadData]; 
    }
    
  else 
    for( sessionTableGroup* section in filteredSessionLists )
      section.items = [allSessions filteredArrayUsingPredicate:section.predicate];
   

  // TODO : sort filtered arrays
  // TODO : memory management : we want arrays of refrences
  
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
  return [[[filteredSessionLists objectAtIndex:section] items] count] ; // 10:15 sessions
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
  return [[filteredSessionLists objectAtIndex:section] title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{       
  static NSString *CellIdentifier = @"Cell";
  
  // TODO : cell cache/reuse issue
  UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  //    if (cell == nil) {
    
  //thank you stackoverflow contributer Tim Rupe! other useful info at link 
  //http://stackoverflow.com/questions/129502/how-do-i-wrap-text-in-a-uitableviewcell-without-a-custom-cell
  // (and in documentation for UITextField)
  cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
  cell.textLabel.numberOfLines=0;
  cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
  //} 
    
   
  NSArray* myFilteredList = [[filteredSessionLists objectAtIndex:[indexPath indexAtPosition:0]] items];
  NSDictionary* mySession = [myFilteredList objectAtIndex:[indexPath indexAtPosition:1]];
  NSString* mySessionID = getIdOfSession(mySession);
  cell.textLabel.text = [mySession objectForKey:@"title"]; 
  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray* myFilteredList = [[filteredSessionLists objectAtIndex:[indexPath indexAtPosition:0]] items];
  NSDictionary* mySession = [myFilteredList objectAtIndex:[indexPath indexAtPosition:1]];
  NSString* mySessionID = getIdOfSession(mySession);
    
  // can use the setSelected:animated: instead to cause an animated change to selected
  cell.selected=
    [mySessionID isEqualToString:userSessionFirstSlot] ||
    [mySessionID isEqualToString:userSessionSecondSlot];
  //cell.selectionStyle=UITableViewCellSelectionStyleBlue;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
  // Navigation logic, Create and push another view controller.
  NSArray* myFilteredList = [[filteredSessionLists objectAtIndex:[indexPath indexAtPosition:0]] items];  
  NSDictionary* whichSession = [myFilteredList objectAtIndex:[indexPath indexAtPosition:1]];
  sessionDetailsViewController *detailViewController = 
    [sessionDetailsViewController createWithSession:whichSession];
  
  // Pass the selected object to the new view controller.
  [self.navigationController pushViewController:detailViewController animated:YES];
  [detailViewController release];
  
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
  if( allSessions ) [ allSessions release ];
  if( filter ) [ filter release ];

  [super dealloc];
}

@end
