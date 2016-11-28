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
#import "ViewController.h"
#import "listViewController.h"

@interface detailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,NSXMLParserDelegate>
{
    double detailsLatitude;
    double detailsLongitude;
    
    
    NSString *photoRef;
    NSString *CurrentStatus;
    
    int widthPhoto;
    
    
    NSXMLParser *parser;
    
    NSMutableArray *placeDetailsList;
    NSMutableArray *reviewsList;
    
    NSMutableDictionary *placeDetailsDictionary;
    NSMutableDictionary *reviewsDictionary;
    
    NSString *detailDataString;
    NSString *reviewString;
    

    

}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;










- (IBAction)doneAction:(id)sender;



@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;

@property NSString *selectedPlaceID;
@property NSString *selectedPlaceLat;
@property NSString *selectedPlaceLng;
@property NSString *selectedPhotoReference;
@property NSString *selectedPhotoWidth;
@property NSString *selectedPlaceStatus;


@property (strong, nonatomic) IBOutlet UIImageView *placeImageView;
@property (strong, nonatomic) IBOutlet MKMapView *placeMapView;

@end
