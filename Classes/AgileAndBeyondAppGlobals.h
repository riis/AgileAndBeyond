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
NSDateFormatter* sessionDetailViewTitleDateFormattor;

#define AAB_FIRST_SLOT_DATE AABDateOfFirstSlot
#define AAB_SECOND_SLOT_DATE AABDateOfSecondSlot
#define AAB_WELCOMEINTRO_DATE AABDateOfWelcome
#define AAB_OPENINGKEYNOTE_DATE AABDateOfOpeningKeynote
#define AAB_LUNCH_DATE AABDateOfLunch
#define AAB_CLOSINGKEYNOTE_DATE AABDateOfClosingKeynote
#define AAB_CLOSINGSUMMARY_DATE AABDateOfClosingSummary

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
// better if like NSObject* const& getObject(); ? 

UIFont* getFontDefault();
UIFont* getFontSessionListCell();
UIFont* getFontSessionListCellSubtitle();
UIFont* getFontSessionDetailCell();
UIFont* getFontSessionDetailCellSubtitle();
UIFont* getFontPersonDetailCell();
UIFont* getFontPersonDetailCellSubtitle();

