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
  
  // ============ code from apple example

    /*

     Create and configure the four recognizers. Add each to the view as a gesture recognizer.

     */

    UIGestureRecognizer *recognizer;

    

    /*

     Create a tap recognizer and add it to the view.

     Keep a reference to the recognizer to test in gestureRecognizer:shouldReceiveTouch:.

     */
    /*
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];

    [self.view addGestureRecognizer:recognizer];

        self.tableView.tapRecognizer = (UITapGestureRecognizer *)recognizer;

    recognizer.delegate = self;

    [recognizer release];
*/
 

    /*

     Create a swipe gesture recognizer to recognize right swipes (the default).

     We're only interested in receiving messages from this recognizer, and the view will take ownership of it, so we don't need to keep a reference to it.

     */

    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];

    [self.tableView addGestureRecognizer:recognizer];

    [recognizer release];

    

    /*

     Create a swipe gesture recognizer to recognize left swipes.

     Keep a reference to the recognizer so that it can be added to and removed from the view in takeLeftSwipeRecognitionEnabledFrom:.

     Add the recognizer to the view if the segmented control shows that left swipe recognition is allowed.

     */

    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];

    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;

    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

    

    if ([segmentedControl selectedSegmentIndex] == 0) {

        [self.view addGestureRecognizer:swipeLeftRecognizer];

    }

    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;

    [recognizer release];

 

    /*

     Create a rotation gesture recognizer.

     We're only interested in receiving messages from this recognizer, and the view will take ownership of it, so we don't need to keep a reference to it.

     */

    recognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationFrom:)];

    [self.view addGestureRecognizer:recognizer];

    [recognizer release];

    

    // For illustrative purposes, set exclusive touch for the segmented control (see the ReadMe).

    [segmentedControl setExclusiveTouch:YES];

    


  // ==================================

  // TODO release addRemoveButton? an example online did a release on it in this function.
}

- (void)viewDidUnload {

    [super viewDidUnload];

    

    self.segmentedControl = nil;

    //    self.tapRecognizer = nil;

    self.swipeLeftRecognizer = nil;

    //    self.imageView = nil;

}


  - (void)viewWillAppear:(BOOL)animated 
{
  [super viewWillAppear:animated];
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
  [mySession release];

  [super dealloc];
}


//*****************+++++++++++++++++_____________________------------------

 

 
/*
- (IBAction)takeLeftSwipeRecognitionEnabledFrom:(UISegmentedControl *)aSegmentedControl {

 

  //     Add or remove the left swipe recogniser to or from the view depending on the selection in the segmented control.

    
    if ([aSegmentedControl selectedSegmentIndex] == 0) {
        [self.view addGestureRecognizer:swipeLeftRecognizer];
    }

    else {
        [self.view removeGestureRecognizer:swipeLeftRecognizer];
    }

}
*/
 

 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

 

    // Disallow recognition of tap gestures in the segmented control.

  if ((touch.view == segmentedControl)/* && (gestureRecognizer == tapRecognizer)*/) {

        return NO;

    }

    return YES;

}

 

 

#pragma mark -

#pragma mark Responding to gestures

 

- (void)showImageWithText:(NSString *)string atPoint:(CGPoint)centerPoint {

    
  NSLog(@"hello from %s", __func__);

    /*

     Set the appropriate image for the image view, move the image view to the given point, then dispay it by setting its alpha to 1.0.

     */

  //    NSString *imageName = [string stringByAppendingString:@".png"];

  //imageView.image = [UIImage imageNamed:imageName];

  //imageView.center = centerPoint;

  //imageView.alpha = 1.0;  

}

 

/*

 In response to a tap gesture, show the image view appropriately then make it fade out in place.

 */

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {


  NSLog(@"hello from %s", __func__);    

  //    CGPoint location = [recognizer locationInView:self.view];
    /*
    [self showImageWithText:@"tap" atPoint:location];

    

    [UIView beginAnimations:nil context:NULL];

    [UIView setAnimationDuration:0.5];

    imageView.alpha = 0.0;

    [UIView commitAnimations];
    */
}

 

/*

 In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.

 */

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {

 
  BUGOUT(@"hello from %s", __func__);
  
  
  
  //    [self showImageWithText:@"swipe" atPoint:location];
  
  
  
  if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) 
    {
      BUGOUT(@"left swipe");
      // this would break if there is <2 sessions 
      int indexOfCurrent = [AABSessions indexOfObject:mySession];
      mySession = (indexOfCurrent==0)?[AABSessions lastObject]:[AABSessions objectAtIndex:indexOfCurrent-1];
      [self.tableView reloadData];
    }
  else 
    {
      BUGOUT(@"other swipe");
            int indexOfCurrent = 
	      mySession = (mySession==[AABSessions lastObject])?
	      [AABSessions objectAtIndex:0]
	      :[AABSessions objectAtIndex:1+[AABSessions indexOfObject:mySession]];
      [self.tableView reloadData];
    }
  
    
    /*
    [UIView beginAnimations:nil context:NULL];

    [UIView setAnimationDuration:0.55];

    imageView.alpha = 0.0;

    imageView.center = location;

    [UIView commitAnimations];
    */
}

 

/*

 In response to a rotation gesture, show the image view at the rotation given by the recognizer, then make it fade out in place while rotating back to horizontal.

 */

- (void)handleRotationFrom:(UIRotationGestureRecognizer *)recognizer {

    
  /*
    CGPoint location = [recognizer locationInView:self.view];

    

    CGAffineTransform transform = CGAffineTransformMakeRotation([recognizer rotation]);

    imageView.transform = transform;

    [self showImageWithText:@"rotation" atPoint:location];

    

    [UIView beginAnimations:nil context:NULL];

    [UIView setAnimationDuration:0.65];

    imageView.alpha = 0.0;

    imageView.transform = CGAffineTransformIdentity;

    [UIView commitAnimations];
  */

  NSLog(@"hello from %s", __func__);
}

 

@end

