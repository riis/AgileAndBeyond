//
//  URLFetcher.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/14/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface URLFetcher : NSObject 
{
  NSURL* sourceURL;
  //@protected
  NSMutableData *connectionData;
  NSURLConnection *urlConnection;
  NSURLResponse *connectionResponse;
  BOOL connectionInProgress; //TODO revisit this whole approach
  Reachability* reachabilityNotifier;
  void (^didLoadData)(NSData*);
  void (^networkUnavailable)();
  void (^didEncounterError)(); 
}

@property (nonatomic, retain) NSMutableData *connectionData; 
@property (nonatomic, retain) NSURLResponse *connectionResponse;
@property () BOOL connectionInProgress;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSURL* sourceURL;
@property (nonatomic, retain) Reachability* reachabilityNotifier;
@property (copy) void (^didLoadData)(NSData*);
@property (copy) void (^networkUnavailable)();
@property (copy) void (^didEncounterError)();

-(URLFetcher*) initWithURL:(NSURL*)url;
-(void) refresh;

@end
