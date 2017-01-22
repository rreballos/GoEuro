//
//  ItineraryCell.m
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import "ItineraryCell.h"
#import "AsyncImageView.h"

NSString *const ItineraryCellDefaultImage = @"Placeholder.png";

@interface ItineraryCell ()
@end

@implementation ItineraryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setCellData:(Itinerary *)itinerary {
    if(!itinerary)
        return;

    //cancel the previosu request
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.logoImage];

    //set placeholder image or cell won't update when image is loaded
    self.logoImage.image = [UIImage imageNamed:ItineraryCellDefaultImage];
    self.logoImage.imageURL = [NSURL URLWithString:itinerary.logo];
    self.priceLabel.text = [NSString stringWithFormat:@"€ %@", itinerary.price];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *arrivalDate = [dateFormatter dateFromString:itinerary.arrivalTime];
    NSDate *departureDate = [dateFormatter dateFromString:itinerary.departureTime];
    self.durationLabel.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:departureDate], [dateFormatter stringFromDate:arrivalDate]];


    div_t hrs = div(itinerary.duration, 3600);
    int hours = hrs.quot;
    div_t mins = div(hrs.rem, 60);
    int minutes = mins.quot;
    NSString *durationTime = [dateFormatter stringFromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d:%d", hours, minutes]]];
    
    self.numberOfStopsLabel.text = [NSString stringWithFormat:@"%@   %@h", (itinerary.numberOfStops ? [NSString stringWithFormat:@"%ld %@", (long)itinerary.numberOfStops, (itinerary.numberOfStops == 1 ? @"Stop" : @"Stops")] : @"Direct"), durationTime];
}

@end
