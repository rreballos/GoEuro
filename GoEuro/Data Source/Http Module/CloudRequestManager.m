//
//  CloudRequestManager.m
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import "CloudRequestManager.h"
#import "AFURLSessionManager.h"
#import "Itinerary.h"
#import "GoEuroDataCache.h"
#import "AFNetworkActivityIndicatorManager.h"

NSString *const kBusURL = @"https://api.myjson.com/bins/37yzm";
NSString *const kTrainURL = @"https://api.myjson.com/bins/3zmcy";
NSString *const kFlightURL = @"https://api.myjson.com/bins/w60i";

@implementation CloudRequestManager

+ (instancetype)sharedInstance {
    static CloudRequestManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [CloudRequestManager new];
        [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
    });
    return _sharedInstance;
}

-(void)fetchDataForItineraryType:(ItineraryType)itineraryType Success:(void (^)(NSArray *obj))success failure:(CloudRequestFailure)failure {

    NSString *requestURL = kBusURL;
    switch (itineraryType) {
        case 0:
            requestURL = kBusURL;
            break;
        case 1:
            requestURL = kTrainURL;
            break;
        case 2:
            requestURL = kFlightURL;
            break;
        default:
            break;
    }

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                failure(error);
            } else {
                NSLog(@"%@ %@", response, responseObject);
                NSArray *jsonArray = [NSArray arrayWithArray:responseObject];
                if(jsonArray) {
                    //cache return json
                    [[GoEuroDataCache sharedInstance]cacheData:jsonArray OfItineraryType:itineraryType];

                    //parse to Itinerary object array
                    Itinerary *itinerary = [Itinerary new];
                    NSArray *itineraries = [itinerary itineraryJSONToObject:jsonArray];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(itineraries);
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }
            }
        }];
        [dataTask resume];
    });
}


@end
