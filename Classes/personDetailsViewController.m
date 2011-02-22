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
#import "URLFetcher.h"

// Temporary: 
UIImageView* imageView;
UIImage* image;
URLFetcher* imageFetcher;

@implementation personDetailsViewController
@synthesize myPerson;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
  [super viewDidLoad];

  if(!imageFetcher)
    {
      imageFetcher = [[URLFetcher alloc] 
		       initWithURL:
			 [NSURL URLWithString:@"http://agileandbeyond.org/images/marvin.toll.jpg"]];
    }


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  return 2;
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


  // temporary.. this would probably be pretty buggy
  void (^imageLoaded)(NSData* ) = ^(NSData*incoming)
    {
      image = [UIImage imageWithData:incoming];
      //      imageView = [[UIImageView alloc] initWithImage:image];
      [cell.imageView setImage:image];
      //[imageView setNeedsLayout];
      [cell setNeedsLayout];
    };

  cell.detailTextLabel.font = getFontDefault();
  cell.textLabel.font = getFontDefault();

  switch( [indexPath indexAtPosition:0 ]  )
    {
    case 0:
      cell.textLabel.text = myPerson;
      imageFetcher.didLoadData = imageLoaded;
      [imageFetcher refresh];
      break;
    case 1:
      cell.textLabel.text = @"Bio";
      cell.detailTextLabel.lineBreakMode=UILineBreakModeWordWrap;
      cell.detailTextLabel.numberOfLines=0;
      cell.detailTextLabel.text = [personDict objectForKey:@"Bio"];
      break;
    default: 
      BUGOUT(@"Warning, reached 'unreachable' code in %s", __func__);
    }
  

  return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  const CGFloat padding = 20;  // TODO don't hardcode this

  // NSString* text = [mySession objectForKey:@"description"];
  // TOOD not hardcoding font, or anything really
  
  NSDictionary* personDict = [AABPeople objectForKey:myPerson];
  UIFont* cellFont = getFontDefault();
  CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
  NSString* cellText = [personDict objectForKey:@"Bio"];
  CGFloat height;

  switch( [indexPath indexAtPosition:0 ]  )
    {
    case 0: 
      cellText = myPerson;
      height += [cellText sizeWithFont:cellFont
			  constrainedToSize:constraintSize 
			  lineBreakMode:UILineBreakModeWordWrap].height;
      height +=74;
      
      break;
    case 1:
      cellText = @"Bio";
      height += [cellText sizeWithFont:cellFont
			  constrainedToSize:constraintSize 
			  lineBreakMode:UILineBreakModeWordWrap].height;
      cellText = [personDict objectForKey:@"Bio"];
      height += [cellText sizeWithFont:cellFont
			  constrainedToSize:constraintSize 
			  lineBreakMode:UILineBreakModeWordWrap].height;
      break;
    default:
      BUGOUT(@"Warning: in %s 'unreachable' code reached", __func__);
      height = 40; 

    }
    
  
  return height + padding;
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

