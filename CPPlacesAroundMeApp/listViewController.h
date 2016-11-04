//
//  listViewController.h
//  CPPlacesAroundMeApp
//
//  Created by Student P_05 on 21/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailsViewController.h"
#import "listsTableViewCell.h"

#define KLatitude "-33.8670522"
#define KLongitude "151.1957362"
#define KGoogleAPIKey "AIzaSyAqbc-6LVPEOoCehaduRszYQnYJEjXsETY"


@interface listViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,CLLocationManagerDelegate>

{
    NSMutableArray *placeList;
    NSXMLParser *parser;
    NSMutableString *dataString;
    NSMutableDictionary *placesDictionary;
    CLLocationManager *myLocation;
       NSMutableString *placeIDString;
       NSMutableString *addressString;
    NSString *latitude;
    NSString *longitude;
    
}
@property NSString *selectedRange;
@property NSString *selectedPlaceType;

@property (strong, nonatomic) IBOutlet UITableView *listsTableView;

@end
