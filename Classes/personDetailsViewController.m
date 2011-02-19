//
//  personDetailsViewController.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/4/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "personDetailsViewController.h"
#import "AgileAndBeyondAppGlobals.h"
#import "session.h"

@implementation personDetailsViewController
@synthesize myPerson;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
    
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
    
  NSDictionary* personDict = [AABPeople objectForKey:myPerson];
  // Configure the cell...
  cell.textLabel.font = getFontDefault();
  cell.textLabel.text = myPerson;
  cell.detailTextLabel.lineBreakMode=UILineBreakModeWordWrap;
  cell.detailTextLabel.numberOfLines=0;
  cell.detailTextLabel.font = getFontDefault();
  cell.detailTextLabel.text = [personDict objectForKey:@"Bio"];
    
  return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  CGFloat height = 45;

  // TODO dynamic heights!
  // NSString* text = [mySession objectForKey:@"description"];
  // TODO not hardcoding reletive position of description field , etc
  // TOOD not hardcoding font, or anything really, except from a central position
  
  NSDictionary* personDict = [AABPeople objectForKey:myPerson];
  NSString* cellText = [personDict objectForKey:@"Bio"];
  UIFont* cellFont = getFontDefault();
  CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
  CGSize labelSize = [cellText sizeWithFont:cellFont
			       constrainedToSize:constraintSize 
			       lineBreakMode:UILineBreakModeWordWrap];
  height = labelSize.height + 40;
    
  
  return height;
}


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
  [super dealloc];
}


@end

