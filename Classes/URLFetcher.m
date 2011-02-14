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
@synthesize didUpdateMessage;
@synthesize destinationData;
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

-(URLFetcher*) initForObject:(id*)dataPoint fromURL:(NSURL*)url
{
  [self init];
  destinationData = dataPoint;
  [self setSourceURL:url];
  return self;
}



-(void) refresh   
{	
  NSMutableURLRequest *request;
  //  NSError *error;
	
  BUGOUT(@"Hello from %s", __func__);

  if(connectionInProgress!=false) 
    {
      BUGOUT(@"%s: I think there is already a connection in progress?",__func__);
      return;
    }	

  if(![reachabilityNotifier currentReachabilityStatus])
    {
      BUGOUT(@"in %s, Reachability status negative.", __func__);

      if  (*(self.destinationData)) 
	[(*(self.destinationData)) release];
      
      // TODO this message can't say that there is a network error unless we actually know that it the problem
      (*(self.destinationData)) = [NSArray arrayWithObject:
					     [NSDictionary dictionaryWithObjectsAndKeys:
							     @"Device Offline",@"HeadLine",
							   @"The latest Agile and Beyond 2011 news will be downloaded when an internet connection is available.",@"Detail",
							   nil]];
      [(*(self.destinationData)) retain];
      return;
    }

  connectionInProgress=true;
  connectionData=[[NSMutableData alloc] init];

  if( sourceURL == nil ) 
    BUGOUT(@"Warning : URLFetch refresh called but no URL.");
  
  request = [[NSMutableURLRequest alloc] initWithURL:sourceURL
					 cachePolicy:NSURLRequestUseProtocolCachePolicy 
					 timeoutInterval:12.5];

  [request setHTTPMethod:@"get"];
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
  id dict;// hack
  BUGOUT(@"Hello from %s", __func__);
  NSError* plistError;
  NSStringEncoding nsEncoding = NSUTF8StringEncoding;
  NSString* encoding = [connectionResponse textEncodingName];
	
  //TODO return string validation
  if (connectionData!=nil) 
    {
      if (encoding) 
	{
	  CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)encoding);
	  if (cfEncoding != kCFStringEncodingInvalidId) 
	    {
	      nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
	    }
	}
    }
  else 
    {
      BUGOUT(@"%s: empty connectionData in get request",__func__);
    }		
  
  // if( connectionInProgress == true ) 
  //  {
      // this was originally a block to check if this was a get or a put, 
      // in this contect we are only doing gets
      // so i'm not sure this conditional block is nessisary.
      
  dict = [NSPropertyListSerialization propertyListWithData:connectionData 
				      options:NSPropertyListImmutable
				      format:NULL error:&plistError];
  //  if(plistError)
  //	BUGOUT(@"plistError .. %@",plistError); 
  //else
  //	{

  if(*destinationData) [*destinationData release];
  (*destinationData) = dict;
  [(*destinationData) retain];

  dumpNestedDictToLog(dict);
  if(didUpdateMessage)  [didUpdateMessage send];

  //}
  
  //}
  //  else 
  // {
  //BUGOUT(@"%s: PUT request completed",__func__);
  // }
  
  // the following log statement is useful for debugging but the string appears to leak 
  // BUGOUT(@"%s: request completed, returned data is %@",__func__,[[[NSString alloc] initWithData:connectionData encoding:nsEncoding] autorelease]);
  
  connectionInProgress=false;
  [self clearUrlConnection];		// nessisary?
  //  [encoding release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
  BUGOUT(@"%s", __func__);
  BUGOUT(@"%s: Error [%@]", __func__, error);

  //	  if(![dict isKindOfClass:[NSArray class]] || ![dict count])
  // {
  
  if  (*(self.destinationData)) 
      [(*(self.destinationData)) release];

  // TODO this message can't say that there is a network error unless we actually know that it the problem
  (*(self.destinationData)) = [NSArray arrayWithObject:
					 [NSDictionary dictionaryWithObjectsAndKeys:
							 @"News Offline",@"HeadLine",
						       @"We're sorry, Agile and Beyond 2011 News could not be updated.",@"Detail",
						       nil]];
  [(*(self.destinationData)) retain];

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
  // if(connectionData) [connectionData release];
  // I feel that the next line belongs, but it releases on a already released object
  // if(connectionResponse) [connectionResponse release];
  //  if(urlConnection) [urlConnection release];
  //if(didUpdateTarget) [didUpdateTarget release];
  //if(sourceURL) [sourceURL release];
  
  [super dealloc];
}
@end 

