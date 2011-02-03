//
//  sessionDetailsViewController.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/3/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import  "sessionDetailsViewController.h"
#import "AgileAndBeyondAppGlobals.h"

static const int rowsBeforePeople = 1;
static const int rowsAfterPeople = 2;
@implementation sessionDetailsViewController
@synthesize mySession;

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
   return  [[mySession objectForKey:@"people"]count] + rowsBeforePeople + rowsAfterPeople;
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
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    

    // Configure the cell...
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
	    cell.detailTextLabel.text = 
	      [[mySession objectForKey:@"timeStart"]
		descriptionWithCalendarFormat:DATE_FORMAT_STRING timeZone:nil 
		locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	    break;
	  case 1 : 
	    cell.textLabel.text = @"Description";
	    cell.detailTextLabel.text = [mySession objectForKey:@"description"];
	    break;
	  default : 
	    // error? 
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
	    //	    break;cell.textLabel.text = @"Placeholder";
	    //cell.detailTextLabel.text = [mySession objectForKey:@"placeholder"];
      }
    else NSLog(@"in %s : warning, unreachable code reached.", __func__);

    /*
      }
      case 1 : 
	if( people && [people count] > 0)
	  {
	
	  } 
    */
      
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
    [super dealloc];
}


@end

