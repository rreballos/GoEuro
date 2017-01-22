//
//  GoEuroDataCache.m
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import "GoEuroDataCache.h"
#import "Itinerary.h"

NSString *const kBus = @"Bus";
NSString *const kTrain = @"Train";
NSString *const kFlight = @"Flight";
NSString *const kItineraryDataPlistFile = @"ItineraryData.plist";

@interface GoEuroDataCache ()
@property (nonatomic, strong) NSString *pLisFilePath;

@end

@implementation GoEuroDataCache

+ (instancetype)sharedInstance {
    static GoEuroDataCache *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [GoEuroDataCache new];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setUpCache];
    }
    return self;
}

- (void)setUpCache {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths.firstObject;
    self.pLisFilePath = [documentsPath stringByAppendingPathComponent:kItineraryDataPlistFile];
}

- (void)cacheData:(id)rawData OfItineraryType:(ItineraryType)itineraryType {

    if(!rawData)
        return;

    if(!self.pLisFilePath) {
        [self setUpCache];
    }

    NSDictionary *itineraryDictionary = @{[self stringyFyItineraryType:itineraryType]:rawData};
    NSError *writeError = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:itineraryDictionary format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&writeError];
    if(plistData){
        [plistData writeToFile:self.pLisFilePath atomically:YES];
    }
}

- (NSArray *)getCachedDataOfItineraryType:(ItineraryType)itineraryType {

    if(!self.pLisFilePath) {
        [self setUpCache];
    }
    
    NSMutableDictionary *plistdict = [NSMutableDictionary dictionaryWithContentsOfFile:self.pLisFilePath];
    if(!plistdict) {
        return nil;
    }
    
    NSArray *itineraryJSON = [plistdict valueForKey:[self stringyFyItineraryType:itineraryType]];
    Itinerary *itinerary = [Itinerary new];
    NSArray *itineraries = [itinerary itineraryJSONToObject:itineraryJSON];
    return itineraries;
}

-(NSString *)stringyFyItineraryType:(ItineraryType)itineraryType {

    NSString *itineraryTypeString;
    switch (itineraryType) {
        case 0:
            itineraryTypeString = kBus;
            break;
        case 1:
            itineraryTypeString = kTrain;
            break;
        case 2:
            itineraryTypeString = kFlight;
            break;
        default:
            break;
    }

    return itineraryTypeString;
}

@end
