//
//  URLFetcher.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 2/14/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "URLFetcher.h"
#import "AgileAndBeyondAppGlobals.h"


@implementation URLFetcher 
@synthesize connectionData,connectionResponse,urlConnection,connectionInProgress;
@synthesize didLoadData, networkUnavailable, didEncounterError; 
@synthesize sourceURL;
@synthesize reachabilityNotifier;

-(id) init {
  [super init];
  reachabilityNotifier = [[Reachability reachabilityForInternetConnection] retain];
  connectionInProgress=false;
    return self;
}

-(URLFetcher*) initWithURL:(NSURL*)url
{
  [self init];
  [self setSourceURL:url];
  return self;
}

-(void) refresh   
{	
  NSMutableURLRequest *request;

  // TODO detect multiple refresh requests and initiate uncached request? 
  // might use CFTimeInterval, CFAbsoluteTimeGetCurrent(),
  // might switch connectionInProgress to an int and use it like a sort of semaphore
  // people also use performSelector:withObject:afterDelay and static function counters
  // to detect double taps
  // so it could be done here that way ,or in the UI button
	
  BUGOUT(@"Hello from %s", __func__);

  if(connectionInProgress!=false) 
    {
      BUGOUT(@"%s: I think there is already a connection in progress?",__func__);
      return;
    }	

  if(![reachabilityNotifier currentReachabilityStatus])
    {
      BUGOUT(@"in %s, Reachability status negative.", __func__);
      if(networkUnavailable) networkUnavailable();
      return;
    }

  connectionInProgress=true;
  connectionData=[[NSMutableData alloc] init];

  if( sourceURL == nil ) 
    BUGOUT(@"Warning : URLFetch refresh called but no URL.");
  
  request = [[NSMutableURLRequest alloc] initWithURL:sourceURL
					 cachePolicy:NSURLRequestUseProtocolCachePolicy 
					 timeoutInterval:12.5];
  [request setHTTPMethod:@"GET"];
       
  BUGOUT(@"%s about to start asynchronous connection",__func__);
  self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
  [request release];
}


//////////////////////////////////////// URL Connection Delegate message implementations //

- (void)clearUrlConnection
{
  BUGOUT(@"%s", __func__);
  // TODO should we [connection cancel] ? 
  self.urlConnection = nil; // also does a release
  self.connectionData = nil;
  connectionInProgress=false;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData;
{
  BUGOUT(@"%s", __func__);
  if(connectionData==nil || connectionData == NULL ) 
    connectionData=[NSMutableData  dataWithData: newData]; 
  [connectionData appendData:newData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
  BUGOUT(@"Hello from %s", __func__);
  
  if (!connectionData) 
    BUGOUT(@"Warning: %s: nil connectionData in get request",__func__);
     
  if(didLoadData)  didLoadData(connectionData);
  else BUGOUT(@"WARNING: in %s, you probably wanted to set didLoadData to a block");

  connectionInProgress=false;
  
  // is it nessisary to clearUrlConnection here?
  // leave data in case caller wants it later ? 
  //   or .. do this and make it up to the didLoadData block to make a copy or retain it 
  [self clearUrlConnection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
  BUGOUT(@"%s", __func__);
  BUGOUT(@"%s: Error [%@]", __func__, error);
  if(didEncounterError) didEncounterError();
  [self clearUrlConnection];
}

- (void)dealloc 
{
  // TODO cancel connection? ( [connection cancel] ) 
  //  if(didLoadData)  [didLoadData release];
  self.didLoadData = nil;
  if(didEncounterError) [didEncounterError release];
  if(networkUnavailable) [networkUnavailable release];
  if(connectionData) [connectionData release];
  if(connectionResponse) [connectionResponse release];
  if(urlConnection) [urlConnection release];
  if(sourceURL) [sourceURL release];
  if(reachabilityNotifier) [reachabilityNotifier release];
  
  [super dealloc];
}
@end 

