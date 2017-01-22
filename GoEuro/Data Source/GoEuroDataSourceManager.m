//
//  GoEuroDataSourceManager.m
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import "GoEuroDataSourceManager.h"
#import "GoEuroDataCache.h"
#import "CloudRequestManager.h"

@interface GoEuroDataSourceManager ()
@property (nonatomic) SortType sort;
@property (nonatomic) ItineraryType itineraryType;
@property (nonatomic, strong) NSArray <Itinerary *>*itineraries;
@end

@implementation GoEuroDataSourceManager

+ (instancetype)sharedInstance {
    static GoEuroDataSourceManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [GoEuroDataSourceManager new];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.sort = SortTypeDepartureTime;
        self.itineraryType = ItineraryTypeBus;
        self.itineraries =[NSArray array];
    }
    return self;
}

-(NSArray <NSString *> *)tabNames {
    return @[@"Train", @"Bus", @"Flight"];
}


-(NSString *)getCurrentDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM YY";
    NSDate *currentDate = [NSDate date];
    return [dateFormatter stringFromDate:currentDate];
}

-(void)getItineraryOfType:(ItineraryType)itineraryType SortBy:(SortType)sortBy {

    NSArray *localItinerary = [[GoEuroDataCache sharedInstance]getCachedDataOfItineraryType:itineraryType];
    self.itineraries = [self sortItinerary:localItinerary By:sortBy];
    if(self.itineraries && [self.dataHelper respondsToSelector:@selector(didfetchedItineraryDataSource:)]) {
        [self.dataHelper didfetchedItineraryDataSource:self.itineraries];
    }

    //fetch the new data again if there are
    [[CloudRequestManager sharedInstance]fetchDataForItineraryType:itineraryType Success:^(NSArray *obj) {
        NSArray *localItinerary = [obj copy];
        self.itineraries = [self sortItinerary:localItinerary By:sortBy];
        if(self.itineraries && [self.dataHelper respondsToSelector:@selector(didfetchedItineraryDataSource:)]) {
            [self.dataHelper didfetchedItineraryDataSource:self.itineraries];
        }
    } failure:^(NSError *error) {
        if([self.dataHelper respondsToSelector:@selector(didFailedfetchedItineraryDataSource:)]) {
            [self.dataHelper didFailedfetchedItineraryDataSource:error];
        }
    }];
}


-(NSArray <Itinerary *> *)sortItinerary:(NSArray <Itinerary *>*)itineraries By:(SortType)sortBy {

    if(!itineraries)
        return nil;

    NSArray *locaCopy = [itineraries copy];
    NSString *descriptorKey = @"departureTime";
    switch (sortBy) {
        case SortTypeDepartureTime:
            descriptorKey = @"departureTime";
            break;
        case SortTypeArrivalTime:
            descriptorKey = @"arrivalTime";
            break;
        case SortTypeTravelDuration:
            descriptorKey = @"duration";
            break;
        default:
            break;
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:descriptorKey ascending:YES];
    return [locaCopy sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
