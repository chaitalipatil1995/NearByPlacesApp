//
//  detailsViewController.h
//  CPPlacesAroundMeApp
//
//  Created by Student P_05 on 21/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "customTableViewCell.h"

@interface detailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,NSXMLParserDelegate>
{
    NSMutableArray *placeIDArray;
    
    NSString *currentPlaceLatitude;
    NSString *currentPlaceLongitude;
    NSString *photoRef;
    double widthPhoto;
    NSXMLParser *parser;
    NSMutableArray *placeDetailsList;
    NSMutableDictionary *placeDetailsDictionary;
    NSString *DataString;
    

}
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *TimingLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;
@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;

@property NSString *selectedPlaceID;
@property NSString *selectedPlaceLat;
@property NSString *selectedPlaceLng;
@property NSString *selectedPhotoReference;
@property NSString *selectedPhotoWidth;

@property (strong, nonatomic) IBOutlet UIImageView *placeImageView;
@property (strong, nonatomic) IBOutlet MKMapView *placeMapView;

@end
