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

//@synthesize didUpdateMessage;
//@synthesize destinationData;
@synthesize sourceURL;
@synthesize reachabilityNotifier;
/*
@class newsListViewController;
extern newsListViewController* AABNewsView; // TODO - note will this need to stay? 
*/
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
  
  //  NSError *error;

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
  //  error = [[NSError alloc] init];
       
  BUGOUT(@"%s about to start asynchronous connection",__func__);
  self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
  [request release];
  // [error release];
}


//////////////////////////////////////// URL Connection Delegate message implementations //

- (void)clearUrlConnection
{
  BUGOUT(@"%s", __func__);
  // TODO should we [connection cancel] ? 

  /*
  if (urlConnection != nil)
    {
      [urlConnection release];
      urlConnection=nil;
    }
  if (connectionData != nil)
    {
      [connectionData release];
      connectionData=nil;
    }
  */
  self.urlConnection = nil;
  self.connectionData = nil;
  //self.connectionResponse = nil; // correct? 
  connectionInProgress=false;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData;
{
  BUGOUT(@"%s", __func__);
  if(connectionData==nil || connectionData == NULL ) 
    connectionData=[NSMutableData  dataWithData: newData]; 
  [connectionData appendData:newData];
}
/*
- (void)willSendRequest:(NSURLRequest *)request
{
  BUGOUT(@"%s", __func__);
  //	[activityIndicator startAnimating];
}

- (void)didReceiveResponse:(NSURLResponse *)response
{
  // WHAT IS THIS? 
  self.connectionResponse = response; // correct? 
  BUGOUT(@"%s", __func__);
}

- (void)finishedReceivingData:(NSData *)data
{
  BUGOUT(@"%s", __func__);
	
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)aRequest redirectResponse:(NSURLResponse *)aResponse;
{
  BUGOUT(@"%s", __func__);
  BUGOUT(@"In connection: willSendRequest: %@ redirectResponse: %@", aRequest, aResponse);
  return aRequest;
}
*/
/*
  - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
  {
  const int maxFailureRetries = 5; // TODO move this
  NSURLCredential *cred;
	
  BUGOUT(@"%s: recieved challange %@", __func__, challenge);
	
  if ( [challenge previousFailureCount] > maxFailureRetries ) {
  [[challenge sender] cancelAuthenticationChallenge:challenge];  
  }
  else {
  if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])  {
  // some techniques garnered from stackoverflow user Gordon Henriksen whether original to him or not
  // this allow a connection despite certificate errors
  // should eventually be taken out or at leasst restricted in protectionspace
  BUGOUT(@"%s: servertrust authentication processing", __func__);
  cred=[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]; 
  }
  else {
  BUGOUT(@"%s: user authentication processing", __func__);
			
  cred = [NSURLCredential credentialWithUser:repo.userName
  password:repo.userPW 
  persistence:NSURLCredentialPersistenceForSession];
  }
		
  [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
  }
  }

  - (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
  {
  BUGOUT(@"%s", __func__);
  BUGOUT(@"In connection: didCancelAuthenticationChallenge: %@", challenge);
  [self clearUrlConnection];
  }
*/
/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse;
{
  BUGOUT(@"%s", __func__);
  BUGOUT(@"%s: Reponse URL/length [%@ / %lld]", __func__, [aResponse URL], [aResponse expectedContentLength]);
	
  self.connectionResponse = aResponse;
	
  //from apple : This message can be sent due to server redirects, or in rare cases multi-part MIME documents. 
  //Each time the delegate receives the connection:didReceiveResponse: message, it should reset any progress 
  //indication and discard all previously received data.
  // Yet with the following code uncommented, I get excbadaccess so...
	
  //if (connectionData != nil)
  //{
  //[connectionData release];
  //		connectionData=nil;
  //	}
}
*/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
  //  id dict;// hack
  BUGOUT(@"Hello from %s", __func__);
  
  if (!connectionData) 
    BUGOUT(@"Warning: %s: nil connectionData in get request",__func__);
     
  if(didLoadData)  didLoadData(connectionData);
  else BUGOUT(@"WARNING: in %s, you probably wanted to set didLoadData to a block");

  connectionInProgress=false;
  
  // nessisary to clearUrlConnection here?
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
/*
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
{
  BUGOUT(@"%s", __func__);
  return nil; 
}
*/
/*
// allow a connection despite certificate errors
// ideally, we won't need to do this and eventually this can be removed
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
return YES;
//return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
*/

- (void)dealloc 
{
  // TODO cancel connection? ( [connection cancel] ) 

  // if(connectionData) [connectionData release];
  // I feel that the next line belongs, but it releases on a already released object
  // if(connectionResponse) [connectionResponse release];
  //  if(urlConnection) [urlConnection release];
  //if(didUpdateTarget) [didUpdateTarget release];
  //if(sourceURL) [sourceURL release];
  
  [super dealloc];
}
@end 

