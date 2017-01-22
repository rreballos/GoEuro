//
//  ItineraryCell.h
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
@interface ItineraryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStopsLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
- (void)setCellData:(Itinerary *)itinerary;
@end
