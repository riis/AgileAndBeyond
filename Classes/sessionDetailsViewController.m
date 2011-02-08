//
//  sessionDetailsViewController.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/3/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "sessionListViewController.h"
#import  "sessionDetailsViewController.h"
#import "session.h"
#import "AgileAndBeyondAppGlobals.h"
#import "personDetailsViewController.h"

#define SDVCHEADCOUNT [[mySession objectForKey:@"people"]count]
static const int rowsBeforePeople = 1;
static const int rowsAfterPeople = 2;
@implementation sessionDetailsViewController
@synthesize mySession;

#pragma mark -
#pragma mark View lifecycle

- (void)addToUserSelections 
{
 
  NSString* id = getIdOfSession(mySession);
  NSDate* sessionTime = [mySession objectForKey:@"timeStart"];
  NSString* whichPref;
  NSString** whichSlot;
  
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

  if( [id isEqualToString:*whichSlot] )
    {
      [*whichSlot release];
      *whichSlot=nil;
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:whichPref];
      self.navigationItem.rightBarButtonItem.title = @"Add";
    }
  else 
    {
      if ( *whichSlot != nil ) [*whichSlot release];
      *whichSlot = id;
      [*whichSlot retain];
      [[NSUserDefaults standardUserDefaults] setObject:id forKey:whichPref];
      self.navigationItem.rightBarButtonItem.title = @"Remove";
    }

  // user selected slots has updated, reload mySessionsViewController
  if( mySessionsViewController ) 
    {
      [mySessionsViewController.tableView reloadData];
    }
}

- (void)viewDidLoad 
{
  [super viewDidLoad];
  NSString * mySessionID = getIdOfSession(mySession);
  NSString * buttonTitle = 
    [mySessionID isEqualToString:userSessionFirstSlot] 
    || [mySessionID isEqualToString:userSessionSecondSlot] 
    ?@"Remove":@"Add";

  // build the right add/remove button
  UIBarButtonItem *addRemoveButton = [[UIBarButtonItem alloc] 
				       initWithTitle:buttonTitle

				       style:UIBarButtonItemStylePlain
				       target:self
				       action:@selector(addToUserSelections)];
  self.navigationItem.rightBarButtonItem = addRemoveButton;
  // TODO release addRemoveButton? an example online did a release on it in this function.
}
/*
  - (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  }
*/
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

+ (sessionDetailsViewController*) createWithSession:(NSDictionary*)session
{

  sessionDetailsViewController* me = 
    [[sessionDetailsViewController alloc] 
      initWithNibName:@"sessionDetailsViewController" 
      bundle:nil];

  [me setMySession:session];

  return me;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  // Return the number of rows in the section.  
  return SDVCHEADCOUNT + rowsBeforePeople + rowsAfterPeople;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
  NSArray* people = [mySession objectForKey:@"people"];
  const int headcount = [people count];
  const int i = [indexPath indexAtPosition:1];  // index pos 1, not zero, only 
  static NSString *CellIdentifier = @"Cell";

  // TODO : fix cell recycling
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  else 
    cell.accessoryType=UITableViewCellAccessoryNone;    // reset default

  // Configure the cell...
  cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
  cell.detailTextLabel.lineBreakMode=UILineBreakModeWordWrap;
  cell.detailTextLabel.numberOfLines=0;
  cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    


    if( i < rowsBeforePeople )
      {
	cell.textLabel.text = @"Title";
	cell.detailTextLabel.text = [mySession objectForKey:@"title"];
      }
    else if ( i >= headcount + rowsBeforePeople )
      {
	switch ( i - (headcount + rowsBeforePeople) )
	  {
	  case 0 : 
	    cell.textLabel.text = @"Schedule";
	    cell.detailTextLabel.text =  [AABDateSectionTitleFormmater 
					   stringFromDate:[mySession objectForKey:@"timeStart"]];
	    break;
	  case 1 : 
	    cell.textLabel.text = @"Description";
	    cell.detailTextLabel.text = [mySession objectForKey:@"description"];
	    break;
	  default : 
	    // TODO replace this log output with a macro 
	    BUGOUT(@"Warning in %s 'unreachable' code reached",__func__);
	    cell.textLabel.text = @"x";
	    cell.detailTextLabel.text = @"x";
	  }
      }
    else if ( i >= rowsBeforePeople  && i < (headcount + rowsBeforePeople))
      {
	cell.textLabel.text =
	  [[[mySession objectForKey:@"people"] objectAtIndex:i-rowsBeforePeople] objectForKey:@"role"];
	cell.detailTextLabel.text = 
	  [[[mySession objectForKey:@"people"] objectAtIndex:i-rowsBeforePeople] objectForKey:@"individual"];
	// TODO: conditional disclosure indicator if bio exists..
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;    
      }
    else BUGOUT(@"in %s : warning, 'unreachable' code reached.", __func__);
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  CGFloat height = 45;

  // TODO dynamic heights!
  // NSString* text = [mySession objectForKey:@"description"];
  // TODO not hardcoding reletive position of description field , etc
  // TOOD not hardcoding font, or anything really, except from a central position

  if([indexPath indexAtPosition:1]+1 == SDVCHEADCOUNT + rowsBeforePeople + rowsAfterPeople)
    {
      NSString* cellText = [mySession objectForKey:@"description"];
      UIFont* cellFont = [UIFont fontWithName:@"Helvetica" size:10.0];
      CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
      CGSize labelSize = [cellText sizeWithFont:cellFont
				   constrainedToSize:constraintSize 
				   lineBreakMode:UILineBreakModeWordWrap];
      height = labelSize.height + 20;
    }
  
  return height;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  int i = [indexPath indexAtPosition:1];
  if ( i >= rowsBeforePeople  && i < (SDVCHEADCOUNT + rowsBeforePeople)) 
    {      
      personDetailsViewController *detailViewController = [[personDetailsViewController alloc] initWithNibName:@"personDetailsViewController" bundle:nil];
      detailViewController.myPerson = 
	[[[mySession objectForKey:@"people"] objectAtIndex:i-rowsBeforePeople] objectForKey:@"individual"];
      // Pass the selected object to the new view controller.
      [self.navigationController pushViewController:detailViewController animated:YES];
      [detailViewController release];
    }	 
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
  // TODO memory
  [super dealloc];
}


@end

