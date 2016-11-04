//
//  detailsViewController.m
//  CPPlacesAroundMeApp
//
//  Created by Student P_05 on 21/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import "detailsViewController.h"

@interface detailsViewController ()

@end

@implementation detailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    placeDetailsList = [[NSMutableArray alloc]init];
    currentPlaceLatitude = self.selectedPlaceLat;
    currentPlaceLongitude = self.selectedPlaceLng;
    widthPhoto=self.selectedPhotoWidth.floatValue;
    photoRef = self.selectedPhotoReference;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// https://maps.googleapis.com/maps/api/place/nearbysearch/xml?location=-33.8670522,151.1957362&radius=500&type=restaurant&key=AIzaSyAqbc-6LVPEOoCehaduRszYQnYJEjXsETY

//    AIzaSyCxB6JjzGikl5erpjgXgupw0R2VyQZAMko
//
//    content_copy
//    AIzaSyCxB6JjzGikl5erpjgXgupw0R2VyQZAMko
//
//    content_copy
//
//
//
//AIzaSyAqbc-6LVPEOoCehaduRszYQnYJEjXsETY






/*-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(currentPlaceLatitude,currentPlaceLongitude));
    
    [self.placeMapView setRegion:region animated:YES];
}*/

-(void)getPlaceListDetailsWithAPIKey:(NSString *)key
                             placeID:(NSString *)placeID
{
    //[self.detailsListIndicator startAnimating];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/xml?&key=%@&placeid=%@",key,placeID];
    
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
            NSLog(@"%@",error.localizedDescription);
        }
        else {
            
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        
                        //xml parsing
                        
                        parser = [[NSXMLParser alloc]initWithData:data];
                        parser.delegate = self;
                        [parser parse];
                        
                    }
                    else {
                        //alert
                       // [self.detailsListIndicator stopAnimating];
                        
                    }
                }
                else {
                    //alert
                   // [self.detailsListIndicator stopAnimating];
                    
                }
                
            }
            else {
                //alert
               // [self.detailsListIndicator stopAnimating];
                
            }
        }
        
        
    }];
    
    
    [task resume];
    
}
//-(void)getPhotoDetailsWithAPIKey:(NSString *)key
//                             photoReference:(NSString *)photoREf
//                      photoWidth:(double)width
//{
//   // [self.detailsListIndicator startAnimating];
//
//    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=%@&photoreference=%@&maxwidth=%f",key,photoRef,width];
//
//
//
//    NSLog(@"%@",urlString);
//
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        if (error) {
//            //alert
//        }
//        else {
//
//            if (response) {
//
//                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//
//                if (httpResponse.statusCode == 200) {
//
//                    if (data) {
//
//                        //xml parsing
//
//                        parser = [[NSXMLParser alloc]initWithData:data];
//                        parser.delegate = self;
//                        [parser parse];
//
//
//                        self.locationImage = [UIImage imageWithData:data];
//
//
//                    }
//                    else {
//                        //alert
//                        [self.detailsListIndicator stopAnimating];
//
//                    }
//                }
//                else {
//                    //alert
//                    [self.detailsListIndicator stopAnimating];
//
//                }
//
//            }
//            else {
//                //alert
//                [self.detailsListIndicator stopAnimating];
//
//            }
//        }
//
//
//    }];
//
//
//    [task resume];
//
//
//
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placeDetailsList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Custom_Cell"];
    
    
   // [self.detailsListIndicator stopAnimating];
    
    
    NSMutableDictionary *tempDictionary = [placeDetailsList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",tempDictionary);
    
    
    
    NSString *reviewerName = [tempDictionary valueForKey:@"author_name"];
    NSString *unix = [tempDictionary valueForKey:@"time"];
    NSString *reviewerText = [tempDictionary valueForKey:@"text"];
    
    
    // NSString *unix = [NSString stringWithFormat:@"%@",[placeDetailsList valueForKey:@"time"]];
    
    double unixTimeStamp = unix.intValue;
    
    NSTimeInterval _interval  =   unixTimeStamp;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_interval];
    
    NSDateFormatter *formatterHours= [[NSDateFormatter alloc] init];
    
    
    [formatterHours setLocale:[NSLocale currentLocale]];
    
    [formatterHours setDateFormat:@"HH:mm a"];
    
    NSString *hoursString = [formatterHours stringFromDate:date];
    
    
    
    
    cell.reviewerNameLabel.text = reviewerName;
    
   // cell.labelReviewName.textColor = [UIColor blueColor];
    
    
    
   // cell.labelReviewTime.text = hoursString;
    
    
    
    cell.reviewsLabel.text = reviewerText;
    
    
    
    cell.backgroundColor = [UIColor lightTextColor];
    
    
    return cell;
    
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    
    if ([elementName isEqualToString:@"result"]) {
        placeDetailsDictionary = [[NSMutableDictionary alloc]init];
        
    }
    else if ([elementName isEqualToString:@"name"]) {
        DataString = [[NSMutableString alloc]init];
        
    }
    else if ([elementName isEqualToString:@"vicinity"]) {
        DataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"formatted_phone_number"]) {
        DataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"author_name"]) {
        DataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"time"]) {
        DataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"text"]) {
        DataString = [[NSMutableString alloc]init];
    }
    
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    DataString = string;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"result"]) {
        
        [placeDetailsList addObject:placeDetailsDictionary];
        
        
        
        //[self.detailsListIndicator stopAnimating];
        NSLog(@"%@",placeDetailsDictionary);
        
        NSLog(@"%@",placeDetailsList);
        
        
    }
    else if ([elementName isEqualToString:@"name"]) {
        
        [placeDetailsDictionary setValue:DataString forKey:@"name"];
    }
    else if ([elementName isEqualToString:@"vicinity"]) {
        
        [placeDetailsDictionary setValue:DataString forKey:@"vicinity"];
        
    }
    else if ([elementName isEqualToString:@"formatted_phone_number"]) {
        
        [placeDetailsDictionary setValue:DataString forKey:@"formatted_phone_number"];
    }
    
    else if ([elementName isEqualToString:@"author_name"]) {
        
        [placeDetailsDictionary setValue:DataString forKey:@"author_name"];
        
    }
    else if ([elementName isEqualToString:@"time"]) {
        
        [placeDetailsDictionary setValue:DataString forKey:@"time"];
        
    }
    else if ([elementName isEqualToString:@"text"]) {
        
        [placeDetailsDictionary setValue:DataString forKey:@"text"];
        
    }
    
    else if([elementName isEqualToString:@"PlaceDetailsResponse"]){
        
        //[self.detailsListIndicator stopAnimating];
        
        
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
        
    }
    
    
    
    self.nameLabel.text = [placeDetailsDictionary valueForKey:@"name"];
    
    self.addressLabel.text = [placeDetailsDictionary valueForKey:@"vicinity"];
    
    self.contactLabel.text = [placeDetailsDictionary valueForKey:@"formatted_phone_number"];
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"PARSE ERROR : %@",parseError.localizedDescription);
}



-(void)updateTableView {
    
    
    [self.detailsTableView reloadData];
    
    
    
}






    























-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail_cell"];
    
   // cell.distanceLabel.text=[NSString stringWithFormat:@"%@",self.selectedPlaceID];
    
    //cell.distanceLabel.text = [placeIDArray addObject:[NSString stringWithFormat:@"%@",self.selectedPlaceID]];
    
    
    
    return cell;
    
}

@end
