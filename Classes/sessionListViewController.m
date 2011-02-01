//
//  sessionListViewController.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "sessionListViewController.h"
#import "session.h"

NSArray* foo;

@implementation sessionTableGroup
@synthesize items, title;
@end

@implementation sessionListViewController
@synthesize filteredSessionList;

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {

  // populate an array with refrences to the sessions we will display, in the order we want

  // for now, just always pull in all the sessions
  // later, add filtering

  // if(!filteredSessionList)
  
  NSLog(@"hello from %s", __func__);

  NSMutableArray* allSessions  =  [[NSMutableArray alloc] initWithArray:[AABSessions allValues]]; // will be unsorted 

  NSPredicate* sessionFirstSlotPredicate = [NSPredicate 
					     //  predicateWithFormat:@"timeStart < '2011-03-12 12:00:00 +0500'"];
					     predicateWithFormat:@"subtype==%@",@"Usability"];
  //sessionTableGroup* firstSlot = [[sessionTableGroup alloc] init];
  //firstSlot.items = [allSessions filterUsingPredicate:sessionFirstSlotPredicate];
  foo =[allSessions filteredArrayUsingPredicate:sessionFirstSlotPredicate];
  [foo retain];

  //  [filteredSessionLists addObject:firstSlot];
			   
  
    

  // TODO : memory management : we want arrays of refrences
  //NSLog(@"in %s: filteredSessionList has count %d", __func__, [filteredSessionList count]);
  //NSLog(@"in %s: AABSessions has count %d", __func__, [AABSessions count]);
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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  
  // Return the number of rows in the section.
  switch (section) 
    {
    case 0 : return [foo count] ; // 10:15 sessions
    case 1 : return 0 ; // 12:30 sessions 
    default: return 0 ; 
      // TODO error/assert andor do something consistant for "code should not be reached
    }	
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0 : return @"Saturday, March 12 at 10:15"; 
		case 1 : return @"Saturday, March 12 at 12:30"; 
		default: return @"";	
			// TODO error/assert andor do something consistant for "code should not be reached
	}
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //    if (filteredSessionList == nil)
    // filteredSessionList = [[NSArray alloc] init];//  [[NSArray alloc] initWithArray:[AABSessions allValues]]; // will be unsorted

    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      switch ( [indexPath indexAtPosition:0] )
	{
	case 0 : 


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
	  cell.textLabel.text = [[foo objectAtIndex:[indexPath indexAtPosition:1]] objectForKey:@"title"];
	  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;


	  break;
	default : 
	  // TODO a better default. 
	  break; 
	}
	
	
	
	// we could reuse existing cells, changing their contents, but putting some code here...
	
    return cell;
    }
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
    [super dealloc];
}


@end
