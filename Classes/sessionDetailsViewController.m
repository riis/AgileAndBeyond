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
@synthesize tapRecognizer, swipeLeftRecognizer, segmentedControl;

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
  
  UIGestureRecognizer *recognizer;

  recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
  [self.tableView addGestureRecognizer:recognizer];
  [recognizer release];

  recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
  self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
  swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:swipeLeftRecognizer];
  self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
  [recognizer release];

  // TODO release addRemoveButton? an example online did a release on it in this function.}
}


- (void)viewDidUnload 
{
  [super viewDidUnload];
  self.segmentedControl = nil;
  self.swipeLeftRecognizer = nil;
}


- (void)viewWillAppear:(BOOL)animated 
{
  [super viewWillAppear:animated];
  [self refreshButton];
}

- (void)refreshButton
{
  
  NSString * buttonTitle;  
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
    }  // TODO release addRemoveButton? an example online did a release on it in this function. 
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
  NSArray* people = mySession.people;
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
  cell.textLabel.font = getFontDefault();
  cell.detailTextLabel.lineBreakMode=UILineBreakModeWordWrap;
  cell.detailTextLabel.numberOfLines=0;
  cell.detailTextLabel.font = getFontDefault();
    

    if( i < rowsBeforePeople )
      {
	cell.textLabel.text = @"Title";
	cell.detailTextLabel.text = mySession.title;
      }
    else if ( i >= headcount + rowsBeforePeople )
      {
	switch ( i - (headcount + rowsBeforePeople) )
	  {
	  case 0 : 
	    cell.textLabel.text = @"Schedule";
	    cell.detailTextLabel.text =  [AABDateSectionTitleFormmater 
					   stringFromDate:mySession.timeStart];
	    break;
	  case 1 : 
	    cell.textLabel.text = @"Description";
	    cell.detailTextLabel.text = mySession.description;
	    break;
	  default : 
	    // TODO replace this log output with an unreachable code macro
	    BUGOUT(@"Warning in %s 'unreachable' code reached",__func__);
	    cell.textLabel.text = @"";
	    cell.detailTextLabel.text = @"";
	  }
      }
    else if ( i >= rowsBeforePeople  && i < (headcount + rowsBeforePeople))
      {
	cell.textLabel.text =
	  [[mySession.people objectAtIndex:i-rowsBeforePeople] objectForKey:@"role"];
	cell.detailTextLabel.text = 
	  [[mySession.people objectAtIndex:i-rowsBeforePeople] objectForKey:@"individual"];
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
      NSString* cellText = mySession.description;
      UIFont* cellFont = getFontDefault();
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
      // this is a bit ugly, but, to help prevent too many objects on the navigation view stack
      // lets check and see if this person is already on the stack, 
      // if so, pop to them instead of pushing an new contorller
      UINavigationController* nc = self.navigationController;
      NSString* myPerson = [[mySession.people objectAtIndex:i-rowsBeforePeople] objectForKey:@"individual"];
      NSUInteger i = [[nc viewControllers] indexOfObjectPassingTest:
					     (BOOL (^)(id obj, NSUInteger, BOOL*))
					     ^(id obj, NSUInteger idx, BOOL *stop) {
	  BOOL r = [obj isKindOfClass:[personDetailsViewController class]];
	  r = r && [[obj myPerson] isEqualToString:myPerson];
	  return r;
	}];
      
      if( i != NSNotFound ) 
	{
	  [nc popToViewController:[[nc viewControllers] objectAtIndex:i] animated:YES];
	}
      else	 
	{ 
	  personDetailsViewController *detailViewController = [[personDetailsViewController alloc] initWithNibName:@"personDetailsViewController" bundle:nil];
	  detailViewController.myPerson = myPerson;
	  
	  // Pass the selected object to the new view controller.
	  [self.navigationController pushViewController:detailViewController animated:YES];
	  [detailViewController release];
	}
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
/*
- (void)viewDidUnload 
{
  // TODO memory
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}
*/

- (void)dealloc 
{
  // TODO memory
  self.mySession=nil;

  [super dealloc];
}


//*****************+++++++++++++++++_____________________------------------

#pragma mark -
#pragma mark Responding to gestures


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer 
{
  BUGOUT(@"hello from %s", __func__);
  
  if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) 
    {
      BUGOUT(@"left swipe");
      // this would break if there is <2 sessions 
      int indexOfCurrent = [AABSessions indexOfObject:mySession];
      mySession = (indexOfCurrent==0)?[AABSessions lastObject]:[AABSessions objectAtIndex:indexOfCurrent-1];
      [self.tableView reloadData];
      [self refreshButton];
    }
  else 
    {
      BUGOUT(@"other swipe");
            int indexOfCurrent = 
	      mySession = (mySession==[AABSessions lastObject])?
	      [AABSessions objectAtIndex:0]
	      :[AABSessions objectAtIndex:1+[AABSessions indexOfObject:mySession]];
      [self.tableView reloadData];
      [self refreshButton];
    }
  
}

@end

