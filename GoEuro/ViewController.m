//
//  ViewController.m
//  GoEuro
//
//  Created by Reno Reballos on 22/1/17.
//
//

#import "ViewController.h"
#import "GoEuroDataSourceManager.h"
#import "ItineraryCell.h"
#import "GoEuroDataTypes.h"
#import "AsyncImageView.h"
#import "Itinerary.h"

NSString *const TabNameIdentifier = @"TabNameIdentifier";
NSString *const ItineraryCellIdentifier = @"ItineraryCell";
#define kHiglightColor [UIColor colorWithRed:0.90 green:0.60 blue:0.20 alpha:1.00]
#define kClearColor [UIColor clearColor]

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, GoEuroDataHelper, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *tabCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GoEuroDataSourceManager *goEuroDataSourceManager;
@property (nonatomic, strong) NSArray <Itinerary *> *itineraries;
@property (nonatomic) SortType itinerarySort;
@property (nonatomic) ItineraryType itineraryType;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.dateLabel.text = [self.goEuroDataSourceManager getCurrentDateString];
    self.itinerarySort = SortTypeDepartureTime;
    self.itineraryType = ItineraryTypeBus;
    [self.tabCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.goEuroDataSourceManager getItineraryOfType:self.itineraryType SortBy:self.itinerarySort];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView Support

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.tabCollectionView dequeueReusableCellWithReuseIdentifier:TabNameIdentifier forIndexPath:indexPath];
    UILabel *tabName = (UILabel *)[cell.contentView viewWithTag:100];
    tabName.text = [self.goEuroDataSourceManager tabNames][indexPath.row];
    UIImageView *highlightIndicator = (UIImageView *)[cell.contentView viewWithTag:101];
    highlightIndicator.backgroundColor = cell.selected ? kHiglightColor : kClearColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [self.tabCollectionView cellForItemAtIndexPath:indexPath];
    UIImageView *highlightIndicator = (UIImageView *)[cell.contentView viewWithTag:101];
    highlightIndicator.backgroundColor = kHiglightColor;

    switch (indexPath.row) {
        case 0:
            self.itineraryType = ItineraryTypeTrain;
            break;
        case 1:
            self.itineraryType = ItineraryTypeBus;
            break;
        case 2:
            self.itineraryType = ItineraryTypeFlight;
            break;
        default:
            break;
    }

    [self.goEuroDataSourceManager getItineraryOfType:self.itineraryType SortBy:self.itinerarySort];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.tabCollectionView cellForItemAtIndexPath:indexPath];
    UIImageView *highlightIndicator = (UIImageView *)[cell.contentView viewWithTag:101];
    highlightIndicator.backgroundColor = kClearColor;
}


#pragma mark - UITableView Support
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itineraries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItineraryCell *itineraryCell = (ItineraryCell *)[self.tableView dequeueReusableCellWithIdentifier:ItineraryCellIdentifier];
    [itineraryCell setCellData:self.itineraries[indexPath.row]];
    return itineraryCell;
}

- (IBAction)tappedSort:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sort By" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Departure Time", @"Arrival Time", @"Travel Duration", nil];
    [alert show];
}

- (IBAction)tappedOffer:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Offer" message:@"Offer details are not yet implemented!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma UIAlertView Support
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            self.itinerarySort = SortTypeDepartureTime;
            break;
        case 2:
            self.itinerarySort = SortTypeArrivalTime;
            break;
        case 3:
            self.itinerarySort = SortTypeTravelDuration;
            break;

        default:
            break;
    }

    if(buttonIndex > 0) {
        [self.goEuroDataSourceManager getItineraryOfType:self.itineraryType SortBy:self.itinerarySort];
    }
}


#pragma GoEuroDataHelper protocol 
- (void)didfetchedItineraryDataSource:(NSArray<Itinerary *> *)itineraries {
    self.itineraries = itineraries;
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationRight];
}

-(void)didFailedfetchedItineraryDataSource:(NSError*)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps..." message:@"Something unexpected happen, Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma lazy instance
- (GoEuroDataSourceManager *)goEuroDataSourceManager {
    GoEuroDataSourceManager *sharedInstance = [GoEuroDataSourceManager sharedInstance];
    sharedInstance.dataHelper = self;
    return sharedInstance;
}

@end
