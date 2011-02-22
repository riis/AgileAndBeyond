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
@synthesize myPerson, imageFetcher, image, sessions;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
  [super viewDidLoad];
  
  NSString* urlstring;
  
  // TODO use local bundle resource for default image 
  if(!myPerson || !(urlstring = [[AABPeople objectForKey:myPerson] objectForKey:@"Icon"]))
    urlstring = @"http://agileandbeyond.org/images/logo.square.jpg";
  
  BUGOUT(@"in %s, urlstring is %@", __func__, urlstring);
  
  if(!imageFetcher)  // TODO improved lifecycle of URLFetcher 
    {
      imageFetcher = [[URLFetcher alloc] 
		       initWithURL:
			 [NSURL URLWithString:urlstring]];
      
      imageFetcher.didLoadData = ^(NSData*incoming)
	{
	  self.image = [UIImage imageWithData:incoming];
	  [self.tableView reloadData];
	  // TODO error checking
	};
      
      // go ahead and start a refresh now
      [imageFetcher refresh];
    }
  
  // populate sessions
  if(!sessions)
    {
      NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY people.individual LIKE %@", myPerson];
      self.sessions = [AABSessions filteredArrayUsingPredicate:predicate] ;
      BUGOUT(@"In %s with %@, %d sessions found.", __func__, myPerson, [sessions count]);
    }
}


- (void)viewWillAppear:(BOOL)animated 
{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  switch( section )
    {
    case 0 : //nobreak
    case 1 : return 1;
    case 2 : return [sessions count];
    }
  BUGOUT(@"WARNDING in %s unreachable code reached",__func__);  return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
  int section = [indexPath indexAtPosition:0 ];
  int row = [indexPath indexAtPosition:1 ];

  UITableViewCell *cell;
  NSDictionary* personDict;

  if( section < 2 ) 
    {
      cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) 
	{
	  cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
      personDict = [AABPeople objectForKey:myPerson];
      cell.detailTextLabel.font = getFontDefault();
      cell.textLabel.font = getFontDefault();
    }
  
  switch( section  )
    {
    case 0:
      cell.textLabel.text = myPerson;
      [cell.imageView setImage:image];
      //       [cell setNeedsLayout];  // nessisary? 
      break;
    case 1:
      cell.textLabel.text = @"Bio";
      cell.detailTextLabel.lineBreakMode=UILineBreakModeWordWrap;
      cell.detailTextLabel.numberOfLines=0;
      // workaround for bios starting with "is" or "an"
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", myPerson, [personDict objectForKey:@"Bio"]];
      break;
    case 2:
      cell = [[sessions objectAtIndex:row] sessionListViewCell];
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
      height += 74; // TODO dynamically get height of image
      break;
    case 1:
      cellText = @"Bio";
      height += [cellText sizeWithFont:cellFont
			  constrainedToSize:constraintSize 
			  lineBreakMode:UILineBreakModeWordWrap].height;
      // workaround for bios starting with "is" or "an"
      cellText = [NSString stringWithFormat:@"%@ %@", myPerson, [personDict objectForKey:@"Bio"]];
      height += [cellText sizeWithFont:cellFont
			  constrainedToSize:constraintSize 
			  lineBreakMode:UILineBreakModeWordWrap].height;
      break;
    case 2:
      height = 40; // TODO dynamic height ? 
      break;
    default:
      BUGOUT(@"Warning: in %s 'unreachable' code reached", __func__);
      height = 40; 
    }
      
  return height + padding;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
  int section = [indexPath indexAtPosition:0 ];
  int row = [indexPath indexAtPosition:1 ];
  if ( section == 2 ) 
    {
      [self.navigationController
	   pushViewController:
	     [[sessions objectAtIndex:row] detailViewController]
	   animated:YES];
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

  [super dealloc];
}


@end

