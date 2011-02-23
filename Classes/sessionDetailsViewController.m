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

#define SDVCHEADCOUNT [mySession.people count]
static const int rowsBeforePeople = 1;
static const int rowsAfterPeople = 2;
@implementation sessionDetailsViewController
@synthesize mySession;

#pragma mark -
#pragma mark View lifecycle

- (void)addToUserSelections 
{
  [mySession toggleSelection];
  
  if( mySession.isUserSelected )
    self.navigationItem.rightBarButtonItem.title = @"Remove";
  else 
    self.navigationItem.rightBarButtonItem.title = @"Add";
}

- (void)viewDidLoad 
{
  [super viewDidLoad];
  NSString * buttonTitle;

  // TODO make a session method isSelectable
  if( mySession.isSelectable )
    {
      buttonTitle = mySession.isUserSelected?@"Remove":@"Add";
      
      // build the right add/remove button
      UIBarButtonItem *addRemoveButton = [[UIBarButtonItem alloc] 
					   initWithTitle:buttonTitle
					   style:UIBarButtonItemStylePlain
					   target:self
					   action:@selector(addToUserSelections)];
      self.navigationItem.rightBarButtonItem = addRemoveButton;
    }

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

+ (sessionDetailsViewController*) createWithSession:(Session*)session
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
  return 3;
}

-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
  switch(section)
    {
    case 0 : return @"Information";
    case 1 : return @"Individuals";
    case 2 : return @"Immersion";
    default : return @""; // unreachable
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  // Return the number of rows in the section.  
  switch(section)
    {
    case 0 : return 3;
    case 1 : return SDVCHEADCOUNT;
    case 2 : return [[mySession actions] count];
    default : return 0; // unreachable
    }

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
  NSArray* people = mySession.people;
  const int section = [indexPath indexAtPosition:0]; 
  const int row = [indexPath indexAtPosition:1]; 
  static NSString *CellIdentifier = @"SessionCell";

  // TODO : fix cell recycling
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  
  cell.accessoryType=UITableViewCellAccessoryNone;    // reset defaults
  cell.textLabel.font = getFontDefault();
  cell.detailTextLabel.lineBreakMode=UILineBreakModeWordWrap;
  cell.detailTextLabel.numberOfLines=0;
  cell.detailTextLabel.font = getFontDefault();
    
  switch ( section )
    {
    case 0 :
      switch( row ) 
	{
	case 0:
	  cell.textLabel.text = @"Title";
	  cell.detailTextLabel.text = mySession.title;
	  break;
	case 1:
	  cell.textLabel.text = @"Schedule";
	  cell.detailTextLabel.text =  [AABDateSectionTitleFormmater 
					 stringFromDate:mySession.timeStart];
	  break;
	case 2:
	  cell.textLabel.text = @"Description";
	  cell.detailTextLabel.text = mySession.description;
	  break;
	}
      break;
    case 1 :
      cell.textLabel.text =
	[[mySession.people objectAtIndex:row] objectForKey:@"role"];
      cell.detailTextLabel.text = 
	[[mySession.people objectAtIndex:row] objectForKey:@"individual"];
      // TODO: conditional disclosure indicator if bio exists..
      cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
      break;
    case 2 :
      cell.textLabel.text = 
	[[mySession.actions objectAtIndex:row] objectForKey:@"title"];
      cell.detailTextLabel.text =
	[[mySession.actions objectAtIndex:row] objectForKey:@"detail"];
      cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator; // TODO a different accessory
      break;
    }
 
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  const int section = [indexPath indexAtPosition:0]; 
  const int row = [indexPath indexAtPosition:1]; 
  const CGFloat defaultHeight = 44; // 44 is default for vertical orientation
  CGFloat height = 15.0; // change this to add a "pad" 
  UIFont* cellFont;
  NSString* cellText; 
  CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
  CGSize labelSize;
  
  // TODO dynamic heights!
  // TODO no hardcoding 

  switch ( section )
    {
    case 0 :
      switch( row ) 
	{
	case 0: // title
	  cellFont = getFontDefault();
	  cellText = mySession.title;
	  height += [cellText sizeWithFont:cellFont
			      constrainedToSize:constraintSize 
			      lineBreakMode:UILineBreakModeWordWrap].height;
	  cellText = @"Title";
	  height += [cellText sizeWithFont:cellFont
			      constrainedToSize:constraintSize 
			      lineBreakMode:UILineBreakModeWordWrap].height;
	  break;
	case 1: // sechedule	 
	  break;
	case 2: // description	  
	  cellFont = getFontDefault();
	  cellText = mySession.description;
	  height += [cellText sizeWithFont:cellFont
			     constrainedToSize:constraintSize 
			     lineBreakMode:UILineBreakModeWordWrap].height;
	  cellText = @"Description";
	  height += [cellText sizeWithFont:cellFont
			      constrainedToSize:constraintSize 
			      lineBreakMode:UILineBreakModeWordWrap].height;
	  break;
	}
      break;
    case 1 : // people list
      cellFont = getFontDefault();
      cellText =
	[[mySession.people objectAtIndex:row] objectForKey:@"role"];
      height += [cellText sizeWithFont:cellFont
			 constrainedToSize:constraintSize 
			 lineBreakMode:UILineBreakModeWordWrap].height;
      cellText = 
	[[mySession.people objectAtIndex:row] objectForKey:@"individual"];
      height += [cellText sizeWithFont:cellFont
			 constrainedToSize:constraintSize 
			 lineBreakMode:UILineBreakModeWordWrap].height;
      break;
    case 2 : // actions list 
      cellFont = getFontDefault();
      cellText =
	[[mySession.actions objectAtIndex:row] objectForKey:@"title"];
      height += [cellText sizeWithFont:cellFont
			 constrainedToSize:constraintSize 
			 lineBreakMode:UILineBreakModeWordWrap].height;
      cellText = 
	[[mySession.actions objectAtIndex:row] objectForKey:@"detail"];
      height += [cellText sizeWithFont:cellFont
			 constrainedToSize:constraintSize 
			 lineBreakMode:UILineBreakModeWordWrap].height;
      break;
    }
  
  return fmax(height,defaultHeight);
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  const int section = [indexPath indexAtPosition:0]; 
  const int row = [indexPath indexAtPosition:1];
  UINavigationController* nc = self.navigationController;
  NSString* myPerson; 
  NSUInteger viewFound;

  switch ( section )
    {
    case 0 :
      switch( row ) 
	{
	case 0: // title
	  break;
	case 1: // sechedule	 
	  break;
	case 2: // description	  
	  break;
	}
      break;
    case 1 : // people list
      // this is a bit ugly, but, to help prevent too many objects on the navigation view stack
      // lets check and see if this person is already on the stack, 
      // if so, pop to them instead of pushing an new contorller

      nc = self.navigationController;
      myPerson = [[mySession.people objectAtIndex:row] objectForKey:@"individual"];
      viewFound = [[nc viewControllers] indexOfObjectPassingTest:
					  (BOOL (^)(id obj, NSUInteger, BOOL*))
					^(id obj, NSUInteger idx, BOOL *stop) 
					{
					  BOOL r = [obj isKindOfClass:[personDetailsViewController class]];
					  r = r && [[obj myPerson] isEqualToString:myPerson];
					  return r;
					}];
      if( viewFound != NSNotFound ) 
	{
	  [nc popToViewController:[[nc viewControllers] objectAtIndex:row] animated:YES];
	}
      else	 
	{ 
	  personDetailsViewController *detailViewController = [[personDetailsViewController alloc] initWithNibName:@"personDetailsViewController" bundle:nil];
	  detailViewController.myPerson = myPerson;	  
	  // Pass the selected object to the new view controller.
	  [self.navigationController pushViewController:detailViewController animated:YES];
	  [detailViewController release];
	}
      break;
    case 2 : // actions list 
      [[UIApplication sharedApplication] 
	openURL:[NSURL URLWithString:
			 [[mySession.actions objectAtIndex:row] objectForKey:@"URL"]]];
      break;
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
  [mySession release];
  [super dealloc];
}


@end

