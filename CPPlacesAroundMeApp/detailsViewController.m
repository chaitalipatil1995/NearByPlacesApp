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
  
    self.placeMapView.delegate = self;
    
   // [self setUp];
    
    self.title =[NSString stringWithFormat:@"Place Details"];
    
    
    placeDetailsList = [[NSMutableArray alloc]init];
    
    reviewsList = [[NSMutableArray alloc]init];
    
    
    detailsLatitude = self.selectedPlaceLat.doubleValue;
    
    detailsLongitude = self.selectedPlaceLng.doubleValue;
    
    
    CLLocationCoordinate2D location = self.placeMapView.userLocation.coordinate;
    MKCoordinateRegion region;
    
    location.latitude  = detailsLatitude;
    location.longitude = detailsLongitude;
    
    MKPointAnnotation *myAnnotation =[[MKPointAnnotation alloc]init];
    
    myAnnotation.coordinate = location;
    
    [self.placeMapView addAnnotation:myAnnotation];
    
    region.center = location;
    
    
    widthPhoto = self.selectedPhotoWidth.intValue;
    
    photoRef = self.selectedPhotoReference;
    
    CurrentStatus= self.selectedPlaceStatus;
    
    
    [self getPhotoDetailsWithAPIKey:@KGoogleAPIKey photoReference:photoRef photoWidth:widthPhoto];
    
    [self getPlaceListDetailsWithAPIKey:@KGoogleAPIKey placeID:self.selectedPlaceID];
    
    
    
    if ([CurrentStatus isEqualToString:@"true"]) {
        
        
        self.statusLabel.text = [NSString stringWithFormat:@"Open Now"];
    }
    else{
        self.statusLabel.text = [NSString stringWithFormat:@"Close Now"];
        
    }
    
    
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
            NSLog(@"%@",error.localizedDescription);
            [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error.localizedDescription]];

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
                    [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]];
                   // [self.detailsListIndicator stopAnimating];
                    
                }
                
            }
            else {
               // [self.detailsListIndicator stopAnimating];
            }
        }
        
        
    }];
    
    
    [task resume];
    
}

-(void)getPhotoDetailsWithAPIKey:(NSString *)key
                  photoReference:(NSString *)photoREf
                      photoWidth:(int)width
{
    // [self.detailsListIndicator startAnimating];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=%@&photoreference=%@&maxwidth=%d",key,photoRef,width];
    
    
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDownloadTask *myDownloadTask = [mySession downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            NSLog(@"%@",error.localizedDescription);
            
        }
        else {
            
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:location];
                    
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    [self performSelectorOnMainThread:@selector(updateImageView:) withObject:image waitUntilDone:NO];
                }
                else {
                    [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]];
                   // NSLog(@"%ld",(long)httpResponse.statusCode);
                   
                    NSData *imageData = [NSData dataWithContentsOfURL:location];
                    
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    [self performSelectorOnMainThread:@selector(updateImageView:) withObject:image waitUntilDone:NO];
                    
                   // [self.detailsListIndicator stopAnimating];
                    
                }
                
            }
            else {
                //alert
                //[self.detailsListIndicator stopAnimating];
                
            }
        }
        
        
    }];
    
    
    [myDownloadTask resume];
    
    
    
}

-(void)updateImageView:(UIImage *)image {
    
    self.placeImageView.image  = image;
  //  [self.detailsListIndicator stopAnimating];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placeDetailsList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    customTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"review_cell"];
    
    
   // [self.detailsListIndicator stopAnimating];
    
    
    NSMutableDictionary *tempDictionary = [placeDetailsList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",tempDictionary);
    
    
    
    NSString *reviewerName = [tempDictionary valueForKey:@"author_name"];
    NSString *unix = [tempDictionary valueForKey:@"time"];
    NSString *reviewerText = [tempDictionary valueForKey:@"text"];
    
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
    
    cell.reviewerContactLabel.text = hoursString;

    
    cell.backgroundColor = [UIColor lightTextColor];
    
    
    return cell;
    
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    

if ([elementName isEqualToString:@"result"]) {
    
    placeDetailsDictionary = [[NSMutableDictionary alloc]init];
    
}

else if ([elementName isEqualToString:@"review"]) {
    
    reviewsDictionary = [[NSMutableDictionary alloc]init];
}

else if ([elementName isEqualToString:@"name"]) {
    detailDataString = [[NSMutableString alloc]init];
    
}
else if ([elementName isEqualToString:@"vicinity"]) {
    detailDataString = [[NSMutableString alloc]init];
}
else if ([elementName isEqualToString:@"formatted_phone_number"]) {
    detailDataString = [[NSMutableString alloc]init];
}
else if ([elementName isEqualToString:@"author_name"]) {
    
    reviewString = [[NSMutableString alloc]init];
}
else if ([elementName isEqualToString:@"time"]) {
    reviewString = [[NSMutableString alloc]init];
}
else if ([elementName isEqualToString:@"text"]) {
    reviewString = [[NSMutableString alloc]init];
}


}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    detailDataString = string;
    reviewString = string;
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"result"]) {
        
        [placeDetailsList addObject:placeDetailsDictionary];
        
        //  [self.detailsListIndicator stopAnimating];
        NSLog(@"%@",placeDetailsDictionary);
        
        // NSLog(@"%@",placeDetailsList);
        
    }
    
    
    else if ([elementName isEqualToString:@"review"]) {
        
        [reviewsList addObject:reviewsDictionary];
        
        //    [self.detailsListIndicator stopAnimating];
        //    NSLog(@"%@",placeDetailsDictionary);
        
        //    NSLog(@"%@",placeDetailsList);
        
    }
    else if ([elementName isEqualToString:@"name"]) {
        
        [placeDetailsDictionary setValue:detailDataString forKey:@"name"];
    }
    else if ([elementName isEqualToString:@"vicinity"]) {
        
        [placeDetailsDictionary setValue:detailDataString forKey:@"vicinity"];
        
    }
    else if ([elementName isEqualToString:@"formatted_phone_number"]) {
        
        [placeDetailsDictionary setValue:detailDataString forKey:@"formatted_phone_number"];
    }
    
    else if ([elementName isEqualToString:@"author_name"]) {
        
        [reviewsDictionary setValue:reviewString forKey:@"author_name"];
        
    }
    else if ([elementName isEqualToString:@"time"]) {
        
        [reviewsDictionary setValue:reviewString forKey:@"time"];
        
    }
    else if ([elementName isEqualToString:@"text"]) {
        
        [reviewsDictionary setValue:reviewString forKey:@"text"];
        
    }
    
    else if([elementName isEqualToString:@"PlaceDetailsResponse"]){
        
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
        
    }
    
    
    self.titleLabel.text = [placeDetailsDictionary valueForKey:@"name"];
    
    
    self.addressLabel.text = [placeDetailsDictionary valueForKey:@"vicinity"];
    
    
    
    self.contactNoLabel.text = [placeDetailsDictionary valueForKey:@"formatted_phone_number"];
    
    //[self.detailsListIndicator stopAnimating];
  
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"PARSE ERROR : %@",parseError.localizedDescription);
}



-(void)updateTableView {
    
    
    [self.detailsTableView reloadData];
    
    
    
}

- (IBAction)doneAction:(id)sender {
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:viewController animated:NO];

}


-(void) showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok");
        
    }];
    
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
