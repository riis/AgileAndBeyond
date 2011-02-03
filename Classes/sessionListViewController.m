//
//  sessionListViewController.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "sessionListViewController.h"
#import "AgileAndBeyondAppGlobals.h"
#import "session.h"

// Class static variables


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

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated 
{

  // populate an array with refrences to the sessions we will display, in the order we want
  // TODO move this stuff into init functions properly
  // right now, its setting defaults
  if(allSessions == nil)
      [self setAllSessions:[[NSMutableArray alloc] initWithArray:[AABSessions allValues]]];
     
  if(filteredSessionLists == nil)
    {

      [self setFilteredSessionLists:[[NSMutableArray alloc] init]]; 
      
      sessionTableGroup* newSection;
      newSection = [[sessionTableGroup alloc] init];
      newSection.title = [AAB_FIRST_SLOT_DATE descriptionWithCalendarFormat:DATE_FORMAT_STRING timeZone:nil 
					      locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
      newSection.predicate=[NSPredicate predicateWithFormat:@"timeStart == %@", AAB_FIRST_SLOT_DATE];
      [filteredSessionLists addObject:newSection];
      newSection = [[sessionTableGroup alloc] init];
      newSection.title = [AAB_SECOND_SLOT_DATE descriptionWithCalendarFormat:DATE_FORMAT_STRING timeZone:nil 
					       locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
      newSection.predicate =  [NSPredicate predicateWithFormat:@"timeStart == %@", AAB_SECOND_SLOT_DATE];
      [filteredSessionLists addObject:newSection];
    }
    
  //NSLog(@"hello from %s", __func__);
  //NSMutableArray* allSessions  =  [[NSMutableArray alloc] initWithArray:[AABSessions allValues]]; // will be unsorted 
  //NSLog(@"here's an entry : %@", [allSessions objectAtIndex:0] );
  //if(!filteredSessionLists) NSLog(@"filteredSessionLists is null");
  /*
  filteredSessionLists = [[NSMutableArray alloc] init];
    
  slotGroup = [[sessionTableGroup alloc] init];
  slotGroup.items = [allSessions filteredArrayUsingPredicate:sessionFirstSlotPredicate];
  [slotGroup.items retain];  //TODO
  slotGroup.title = [firstSlotDate descriptionWithCalendarFormat:oldStyleDateFormatString timeZone:nil 
				   locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
  [filteredSessionLists addObject:slotGroup];
  slotGroup = [[sessionTableGroup alloc] init];
  slotGroup.items = [allSessions filteredArrayUsingPredicate:sessionSecondSlotPredicate];
  [slotGroup.items retain];  //TODO
  slotGroup.title = [firstSlotDate descriptionWithCalendarFormat:oldStyleDateFormatString timeZone:nil 
				   locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
  
  [filteredSessionLists addObject:slotGroup];
  */
  
  NSLog(@"in %s filteredSessionLists is : %d", __func__, [filteredSessionLists count] );

  for( sessionTableGroup* section in filteredSessionLists )
    {
      section.items = [allSessions filteredArrayUsingPredicate:section.predicate];
      //  int i =0; 
      // NSLog(@"in %s, section %d has has %d after filtering", __func__, i++, [section.items count] );
    }


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [filteredSessionLists count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  
  // Return the number of rows in the section.
  //switch (section) 
  // {
    return [[[filteredSessionLists objectAtIndex:section] items] count] ; // 10:15 sessions
    //case 1 : return [[[filteredSessionLists objectAtIndex:1] items] count]; // 12:30 sessions 
    // default: return 0 ; 
      // TODO error/assert andor do something consistant for "code should not be reached
    //}	
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  /*
  switch (section) 
    {
    case 0 : return @"Saturday, March 12 at 10:15"; 
    case 1 : return @"Saturday, March 12 at 12:30"; 
    default: return @"";	
      // TODO error/assert andor do something consistant for "code should not be reached
    }
  */

  return [[filteredSessionLists objectAtIndex:section] title];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //    if (filteredSessionList == nil)
    // filteredSessionList = [[NSArray alloc] init];//  [[NSArray alloc] initWithArray:[AABSessions allValues]]; // will be unsorted

    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      //switch ( [indexPath indexAtPosition:0] )
      //	{
      //	case 0 : 

      

	  // found the following snipit online :
	  cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
	  cell.textLabel.numberOfLines=0;
	  cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
	  // thank you stackoverflow contributer Tim Rupe!
	  // ohter useful info at link 
	  //http://stackoverflow.com/questions/129502/how-do-i-wrap-text-in-a-uitableviewcell-without-a-custom-cell
	  // (and in documentation for UITextField)
	  /* cell.textLabel.text = [[
				  [[filteredSessionLists objectAtIndex:0] items]
				   objectAtIndex:[indexPath indexAtPosition:1]]
								   
				  objectForKey:@"title"];
	  */

	  NSArray* myFilteredList = [[filteredSessionLists objectAtIndex:[indexPath indexAtPosition:0]] items];
	  cell.textLabel.text = [[myFilteredList objectAtIndex:[indexPath indexAtPosition:1]]
				   objectForKey:@"title"]; 
	  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;


	  //	  break;
	  //default : 
	  // TODO a better default. 
	  // break; 
    
	
    }	
	
	// we could reuse existing cells, changing their contents, but putting some code here...
	
    return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {

  if( filteredSessionLists ) 
    [filteredSessionLists release]; // will release on each of contents if dealloced
  if( allSessions ) [ allSessions release ];
  if( filter ) [ filter release ];

  [super dealloc];
}


@end
