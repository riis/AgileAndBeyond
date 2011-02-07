//
//  newsListViewController.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/5/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "newsListViewController.h"
#import "session.h"

@implementation newsListViewController


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
  NSLog(@"in %s, AABNews is : ", __func__, AABNews);
    return [AABNews count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...

    NSDictionary *myItem =  [AABNews objectAtIndex:[indexPath indexAtPosition:1]];

    cell.textLabel.text = [myItem objectForKey:@"HeadLine"];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    
    cell.detailTextLabel.lineBreakMode=UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    cell.detailTextLabel.text = [myItem objectForKey:@"Detail"];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  CGFloat height;

  // TOOD not hardcoding font, or anything really, except from a central position

  NSDictionary *myItem =  [AABNews objectAtIndex:[indexPath indexAtPosition:1]];
 
  NSString* cellText = [myItem objectForKey:@"HeadLine"];
  UIFont* cellFont = [UIFont fontWithName:@"Helvetica" size:10.0];
  CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
  CGSize labelSize = [cellText sizeWithFont:cellFont
			       constrainedToSize:constraintSize 
			       lineBreakMode:UILineBreakModeWordWrap];
  height = labelSize.height;
  [cellFont release];

  cellText = [myItem objectForKey:@"Detail"];
  cellFont = [UIFont fontWithName:@"Helvetica" size:10.0];
  constraintSize = CGSizeMake(280.0f, MAXFLOAT);
  labelSize = [cellText sizeWithFont:cellFont
			constrainedToSize:constraintSize 
			lineBreakMode:UILineBreakModeWordWrap];  
  height += labelSize.height;
  [cellFont release];

  height += 20; // for padding
  return height;
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

