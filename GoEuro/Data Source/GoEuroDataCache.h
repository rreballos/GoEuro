//
//  GoEuroDataCache.h
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import <Foundation/Foundation.h>
#import "GoEuroDataTypes.h"

@interface GoEuroDataCache : NSObject
+ (instancetype)sharedInstance;
- (void)cacheData:(id)rawData OfItineraryType:(ItineraryType)itineraryType;
- (NSArray *)getCachedDataOfItineraryType:(ItineraryType)itineraryType;
@end
