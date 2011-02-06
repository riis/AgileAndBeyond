//
//  session.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/28/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//
// This file has to do with more than just sessions.


#import <Foundation/Foundation.h>

/* Because we will want tag sessions in the app and have this persist even if E.G.
 * the session title changes, we will use a unique ID for refering to sessions 
 * internally and when pulling updates, any data stored remotely
 * will use the same unique IDs.
 * Everything else will be identified by a unique string (a person by their name, eg), 
 * since the entire rest of the graph can be rebuilt as a whole, unless more features 
 * come up.
 * 
 * To start the data will be stored in a sort of nested dictionary tree with 
 * "expected" patterns, and addressed in the code with dot syntax.
 * Think of each "table" dictionary as a table in a DB, the key being the primary key,
 * and the value being the columns by name of column
 */

/* Note to self: 
 *    what you are doing wrong is passing around NSDictionary* as sessions, instead of 
 * the NSString that identifies the session.
 * The clean way out is an actualy session class, with getter functions or valueForKey 
 * key/value compliance 
*/ 



NSDictionary* AABSessions;
NSDictionary* AABPeople;
NSDictionary* AABOrg;
NSArray* AABNews;

void populateInitialData();


NSString* userSessionFirstSlot;
NSString* userSessionSecondSlot;

// this is here because in the not distant future, I might have a chance to refactor
// how I refer to sessions from the main list, and having a function like this might
// make that easier
NSString* getIdOfSession(NSDictionary*);


@interface URLFetcher : NSObject 
{
  id destinationData; // should actually be NSData*? 
  NSURL* sourceURL;
@protected
  NSMutableData *connectionData;
  NSURLConnection *urlConnection;
  NSURLResponse *connectionResponse;
  SEL didUpdateAction;
  id didUpdateTarget;
  BOOL connectionInProgress; //TODO revisit this whole approach
}

@property (nonatomic, retain) NSMutableData *connectionData; 
@property (nonatomic, retain) NSURLResponse *connectionResponse;
@property () BOOL connectionInProgress;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) id didUpdateTarget;
@property (nonatomic, retain) id destinationData;
@property (nonatomic, retain) NSURL* sourceURL;

@end
