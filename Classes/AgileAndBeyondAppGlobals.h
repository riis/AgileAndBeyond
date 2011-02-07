/*
 *  AgileAndBeyondAppGlobals.h
 *  AgileAndBeyond
 *
 *  Created by Derek VerLee on 2/2/11.
 *  Copyright 2011 RIIS LLC. All rights reserved.
 *
 *  Some quick and dirty "constants", fix up later.
 *
 */

#define AAB_FIRST_SLOT_DATE [NSDate dateWithString:@"2011-03-12 10:15:00 -0500"]
#define AAB_SECOND_SLOT_DATE [NSDate dateWithString:@"2011-03-12 12:30:00 -0500"]
#define AAB_WELCOMEINTRO_DATE [NSDate dateWithString:@"2011-03-12 8:30:00 -0500"]
#define AAB_OPENINGKEYNOTE_DATE [NSDate dateWithString:@"2011-03-12 8:45:00 -0500"]
#define AAB_CLOSINGKEYNOTE_DATE [NSDate dateWithString:@"2011-03-12 3:15:00 -0500"]
#define AAB_CLOSINGSUMMARY_DATE [NSDate dateWithString:@"2011-03-12 4:15:00 -0500"]

// date format string is in the old style for date format strings
// there is a new style that is used with some (all?) functions
// old style works with descriptionWithCalandarFormat:timezone:locale:dict...
// maybe the new style does also, in which case it'd be more robust
#define DATE_FORMAT_STRING @"%A, %B %e %Y %I:%M"
