//
//  Itinerary.h
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import <Foundation/Foundation.h>

@interface Itinerary : NSObject
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSInteger numberOfStops;
-(NSArray *)itineraryJSONToObject:(NSArray *)itineraryObjectsArray;
@end
