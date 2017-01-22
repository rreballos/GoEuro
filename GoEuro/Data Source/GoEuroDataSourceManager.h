//
//  GoEuroDataSourceManager.h
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import <Foundation/Foundation.h>
#import "Itinerary.h"
#import "GoEuroDataTypes.h"

@protocol GoEuroDataHelper <NSObject>
@optional
-(void)didfetchedItineraryDataSource:(NSArray <Itinerary *>*)itineraries;
-(void)didFailedfetchedItineraryDataSource:(NSError*)error;
@end


@interface GoEuroDataSourceManager : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, weak) id<GoEuroDataHelper> dataHelper;

-(NSString *)getCurrentDateString;
-(NSArray <NSString *> *)tabNames;
-(void)getItineraryOfType:(ItineraryType)itineraryType SortBy:(SortType)sortBy;
@end
