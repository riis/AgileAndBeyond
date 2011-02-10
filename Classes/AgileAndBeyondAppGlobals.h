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


extern NSDate* AABDateOfFirstSlot;
extern NSDate* AABDateOfSecondSlot;
extern NSDate* AABDateOfWelcome;
extern NSDate* AABDateOfOpeningKeynote;
extern NSDate* AABDateOfLunch;
extern NSDate* AABDateOfClosingKeynote;
extern NSDate* AABDateOfClosingSummary;
extern NSDateFormatter* AABDateConstFormatter;
extern NSDateFormatter* AABDateSectionTitleFormmater;

/*#define AAB_FIRST_SLOT_DATE [NSDate dateWithString:@"2011-03-12 10:15:00 -0500"]
#define AAB_SECOND_SLOT_DATE [NSDate dateWithString:@"2011-03-12 12:30:00 -0500"]
#define AAB_WELCOMEINTRO_DATE [NSDate dateWithString:@"2011-03-12 8:30:00 -0500"]
#define AAB_OPENINGKEYNOTE_DATE [NSDate dateWithString:@"2011-03-12 8:45:00 -0500"]
#define AAB_LUNCH_DATE [NSDate dateWithString:@"2011-03-12 11:30:00 -0500"]
#define AAB_CLOSINGKEYNOTE_DATE [NSDate dateWithString:@"2011-03-12 15:15:00 -0500"]
#define AAB_CLOSINGSUMMARY_DATE [NSDate dateWithString:@"2011-03-12 16:15:00 -0500"]
*/
#define AAB_FIRST_SLOT_DATE AABDateOfFirstSlot
#define AAB_SECOND_SLOT_DATE AABDateOfSecondSlot
#define AAB_WELCOMEINTRO_DATE AABDateOfWelcome
#define AAB_OPENINGKEYNOTE_DATE AABDateOfOpeningKeynote
#define AAB_LUNCH_DATE AABDateOfLunch
#define AAB_CLOSINGKEYNOTE_DATE AABDateOfClosingKeynote
#define AAB_CLOSINGSUMMARY_DATE AABDateOfClosingSummary


// date format string is in the old style for date format strings
// there is a new style that is used with some (all?) functions
// old style works with descriptionWithCalandarFormat:timezone:locale:dict...
// maybe the new style does also, in which case it'd be more robust
//  (superseeded by use of NSDateFormatter) 
//#define DATE_FORMAT_STRING @"%A, %B %e %Y %I:%M"

#ifdef CONFIGURATION_Debug
#define BUGOUT(...) NSLog(__VA_ARGS__)
#else
#define BUGOUT(...)
#endif

/*
NSDate* AABDateOfFirstSlot();
NSDate* AABDateOfSecondSlot();
NSDate* AABDateOfWelcome();
NSDate* AABDateOfOpeningKeynote();
NSDate* AABDateOfLunch();
NSDate* AABDateOfClosingKeynote();
NSDate* AABDateOfClosingSummary();
NSDateFormatter* AABDateConstFormatter();
NSDateFormatter* AABDateSectionTitleFormmater();
*/

/*
@class URLFetcher;
@class newsListViewController;
@class sessionListViewController;

URLFetcher* getNewsFetcher();
newsListViewController* getNewsView();

NSDictionary* getSessions();
NSDictionary* getPeople();
NSArray*  getNews();

sessionListViewController* getUserSessionsView();
*/
// like NSObject* const& getObject(); ? 


UIFont* getFontDefault();
UIFont* getFontSessionListCell();
UIFont* getFontSessionListCellSubtitle();
UIFont* getFontSessionDetailCell();
UIFont* getFontSessionDetailCellSubtitle();
UIFont* getFontPersonDetailCell();
UIFont* getFontPersonDetailCellSubtitle();

