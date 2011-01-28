//
//  session.h
//  AgileAndBeyond
//
//  Created by Derek VerLee on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Because we will want tag sessions in the app and have this persist even if E.G.
 * the session title changes, we will use a unique ID for refering to sessions 
 * internally and when pulling updates, any data stored remotely
 * will use the same unique IDs.
 * Everything else will be identified by a unique string (a person by their name, eg), 
 * since the entire rest of the graph can be rebuilt as a whole, unless more features 
 * come up.
 * 
 */



@end
