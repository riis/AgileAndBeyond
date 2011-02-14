//
//  URLFetcher.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/14/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Message.h"

@interface URLFetcher : NSObject 
{
  id* destinationData; // should actually be NSData*? 
  NSURL* sourceURL;
  Message* didUpdateMessage;
  //@protected
  NSMutableData *connectionData;
  NSURLConnection *urlConnection;
  NSURLResponse *connectionResponse;
  BOOL connectionInProgress; //TODO revisit this whole approach
  Reachability* reachabilityNotifier;
}

-(URLFetcher*) initForObject:(id*)dataPoint fromURL:(NSURL*)url;
-(void) refresh;

@property (nonatomic, retain) NSMutableData *connectionData; 
@property (nonatomic, retain) NSURLResponse *connectionResponse;
@property (nonatomic, retain) Message* didUpdateMessage;
@property () BOOL connectionInProgress;
@property (nonatomic, retain) NSURLConnection *urlConnection;
//@property (nonatomic, retain) id didUpdateTarget;
@property (nonatomic) id* destinationData;
@property (nonatomic, retain) NSURL* sourceURL;
@property (nonatomic, retain) Reachability* reachabilityNotifier;
@end