//
//  session.m
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/28/11.
//  Copyright 2011 RIIS LLC. All rights reserved.
//

#import "session.h"
#import "AgileAndBeyondAppGlobals.h"

NSDate* AABDateOfFirstSlot;
NSDate* AABDateOfSecondSlot;
NSDate* AABDateOfWelcome;
NSDate* AABDateOfOpeningKeynote;
NSDate* AABDateOfLunch;
NSDate* AABDateOfClosingKeynote;
NSDate* AABDateOfClosingSummary;

NSDateFormatter* AABDateConstFormatter;
NSDateFormatter* AABDateSectionTitleFormmater;

URLFetcher* AABNewsFetcher;

NSString* getIdOfSession(NSDictionary*session)
{
  NSString* id = nil;
  NSArray* all_ids =  [AABSessions allKeysForObject:session];
  BUGOUT(@"Hello from %s", __func__);
  BUGOUT(@"Number of ids found is : %d", [all_ids count]);
  if([all_ids count] == 1)
    {
      id = [all_ids objectAtIndex:0];
      BUGOUT(@"Session id found is %@",id);
      if(id) [id retain];
    }		
  return id;
}

//this one dumps a nested dictionary structure to log
void dumpNestedDictToLog(NSDictionary* dict)
{
#ifdef CONFIGURATION_Debug
  NSEnumerator *enumerator;
  id	key = nil,
    obj = nil;
	
  if([dict isKindOfClass:[NSDictionary class]])
    {
      enumerator = [dict keyEnumerator];
      BUGOUT(@"size of dict is %d", [dict count]); 
      while (key = [enumerator nextObject]) {
	obj = [dict objectForKey:key];
	BUGOUT(@"%@ : %@", key, obj);
	dumpNestedDictToLog(obj); // then recurse
      }
    }
  else if([dict isKindOfClass:[NSArray class]])
    {
      enumerator = [dict objectEnumerator]; 
      BUGOUT(@"size of array is %d", [dict count]); 
      while (obj = [enumerator nextObject]) {
	BUGOUT(@"array element is %@", obj);
	dumpNestedDictToLog(obj);
      }
    }
  else if([dict isKindOfClass:[NSString class]]) {
    BUGOUT(@"string is %@",dict);
    return;
  }
  else {
    BUGOUT(@"Null or something unrecognized");
  }
#endif
}

void populateInitialData()
{
  AABSessions = nil;
  NSString* plistPath;

  AABDateConstFormatter = [[NSDateFormatter alloc] init];
  [AABDateConstFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  [(AABDateOfFirstSlot = [AABDateConstFormatter dateFromString:@"2011-03-12 10:15"])
    retain];
  [(AABDateOfSecondSlot = [AABDateConstFormatter dateFromString:@"2011-03-12 12:30"])
    retain];
  [(AABDateOfWelcome = [AABDateConstFormatter dateFromString:@"2011-03-12 8:30"])
    retain];
  [(AABDateOfOpeningKeynote = [AABDateConstFormatter dateFromString:@"2011-03-12 8:45"])
    retain];
  [(AABDateOfLunch = [AABDateConstFormatter dateFromString:@"2011-03-12 11:30"])
    retain];
  [(AABDateOfClosingKeynote = [AABDateConstFormatter dateFromString:@"2011-03-12 15:15"])
    retain];
  [(AABDateOfClosingSummary = [AABDateConstFormatter dateFromString:@"2011-03-12 16:15"])
    retain];

  
  AABDateSectionTitleFormmater = [[NSDateFormatter alloc] init];
  [AABDateSectionTitleFormmater setDateFormat:@"EEE, MMMM d h:mm a"];

  BUGOUT(@"AABDateOfFirstSlot is %@",  AABDateOfFirstSlot);

  plistPath = [[NSBundle mainBundle] pathForResource:@"AAB2011-initial" ofType:@"plist"];
  AABSessions = [NSDictionary dictionaryWithContentsOfFile:plistPath];
  if(AABSessions)
    {
      BUGOUT(@"I loaded in a plist as AABSessions from %@, and its got %d elements",  
	    plistPath,
	     [AABPeople count]);
    }
  else 
    {
      BUGOUT(@"Tried to load dictionary but ended up with nil, using path %@",plistPath);
    }

  plistPath = [[NSBundle mainBundle] pathForResource:@"AAB2011-people" ofType:@"plist"];
  AABPeople = [NSDictionary dictionaryWithContentsOfFile:plistPath];

  if(AABPeople)
    {
      BUGOUT(@"I loaded in a plist as AABPeople from %@, and its got %d elements", 
	    plistPath,
	    [AABPeople count]);
    }
  else 
    {
      BUGOUT(@"Tried to load dictionary but ended up with nil, using path %@",plistPath);
    }

  /*  plistPath = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"plist"];
      AABNews = [NSArray arrayWithContentsOfFile:plistPath]; */

  NSString* urlString=[[NSString alloc] initWithString:@"http://10.5.1.239/news.plist"];
  NSURL* newsURL = [NSURL URLWithString:urlString];
  [urlString release];
  /*
  AABNews = [[NSArray alloc]  init] WithContentsOfURL:[NSURL URLWithString:@"http://10.5.1.239/news.plist"]];
  
  if(AABNews)
    {
      BUGOUT(@"I loaded in a plist as AABNews from %@, and its got %d elements", 
	    // plistPath,
	    newsURL,
	    [AABPeople count]);
    }
  else 
    {
      BUGOUT(@"Tried to load dictionary but ended up with nil, using path %@",newsURL);
    }
  */
  // TODO memory
  [AABSessions retain];
  [AABPeople retain];
  //[AABNews retain];

  

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  

  // Next, check and see if we have the user's selected sessions saved, and if so, load
  //  NSString* fromPrefs = nil;
  userSessionFirstSlot = [defaults objectForKey:@"userSessionFirstSlot"];
  userSessionSecondSlot = [defaults objectForKey:@"userSessionSecondSlot"];


  AABNewsFetcher = [[[URLFetcher alloc] initForObject:&AABNews fromURL:newsURL] retain];
  [AABNewsFetcher refresh];
  [newsURL release];
  // [fetcher release];  

}


@implementation URLFetcher 
@synthesize connectionData,connectionResponse,urlConnection,connectionInProgress;
//@synthesize didUpdateTarget;//,didUpdateAction;
@synthesize destinationData;
@synthesize sourceURL;

-(id) init {
  [super init];
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
	
  // TODO 
  //some way of ensuring things such as there is only one request per resource happening at a time
  	
  if(connectionInProgress!=false) {
    BUGOUT(@"%s: I think there is already a connection in progress?",__func__);
    return;
  }
  connectionInProgress=true;
  connectionData=[[NSMutableData alloc] init];

  if( sourceURL == nil ) 
    BUGOUT(@"Warning : URLFetch refresh called but no URL.");
	
  request = [[NSMutableURLRequest alloc] initWithURL:sourceURL
				 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
				 timeoutInterval:12.5];
  NSString* get = [[NSString alloc] initWithString:@"GET"];
  [request setHTTPMethod:get];
  [get release];
  //  error = [[NSError alloc] init];
       
  BUGOUT(@"%s about to start asynchronous connection",__func__);
  self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
  
  // [error release];
  
  // TODO : replace with a target/action system like in ibroadsoft
  /*
  if(AABNewsView)
    {
      BUGOUT(@" Trying to reload newsview here");
      [AABNewsView didUpdate];
    }
  */
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
      
      //    dict = [NSDictionary dictionaryWithJSONString:[[NSString alloc] initWithData:connectionData encoding:nsEncoding]];
      dict = [NSPropertyListSerialization propertyListWithData:connectionData 
				   options:NSPropertyListImmutable
				   format:NULL error:&plistError];
      //  if(plistError)
      //	BUGOUT(@"plistError .. %@",plistError); 
      //else
      //	{
      	  dumpNestedDictToLog(dict);
	  [dict retain]; // todo ... a little bit of odd memory management to look at
	  // something like, if *destinationdata is an object, ..release? 
	  (*(self.destinationData)) = dict;
	  if(AABNewsView)
	    {
	      BUGOUT(@" Trying to reload newsview here");
	      [AABNewsView didUpdate];
	    }
	  //	}

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
