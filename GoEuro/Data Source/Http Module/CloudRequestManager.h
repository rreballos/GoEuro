//
//  CloudRequestManager.h
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import <Foundation/Foundation.h>
#import "GoEuroDataTypes.h"

typedef void(^CloudRequestFailure) (NSError *error);

@interface CloudRequestManager : NSObject
+ (instancetype)sharedInstance;
-(void)fetchDataForItineraryType:(ItineraryType)itineraryType Success:(void (^)(NSArray *obj))success failure:(CloudRequestFailure)failure;
@end
