//
//  Itinerary.m
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import "Itinerary.h"

@implementation Itinerary

-(NSArray *)itineraryJSONToObject:(NSArray *)itineraryObjectsArray {

    if(!itineraryObjectsArray)
        return nil;

    NSMutableArray *itemsObjects = [NSMutableArray array];
    for(NSDictionary *item in itineraryObjectsArray) {

        Itinerary *itineraryObject = [Itinerary new];
        double price = [item[@"price_in_euros"] doubleValue];
        itineraryObject.price = [NSString stringWithFormat:@"%.02f", price];
        itineraryObject.departureTime = item[@"departure_time"];
        itineraryObject.arrivalTime = item[@"arrival_time"];
        itineraryObject.numberOfStops = [item[@"number_of_stops"] integerValue];

        NSString *logoURL = item[@"provider_logo"];
        if(logoURL){
            itineraryObject.logo = [logoURL stringByReplacingOccurrencesOfString:@"{size}" withString:@"63"];
        }

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSDate *arrivalDate = [dateFormatter dateFromString:itineraryObject.arrivalTime];
        NSDate *departureDate = [dateFormatter dateFromString:itineraryObject.departureTime];
        NSTimeInterval timeDifference = [arrivalDate timeIntervalSinceDate:departureDate];
        itineraryObject.duration = timeDifference;
        [itemsObjects addObject:itineraryObject];
    }

    return itemsObjects;
}

@end
