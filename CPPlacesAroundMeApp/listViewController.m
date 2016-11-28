//
//  listViewController.m
//  CPPlacesAroundMeApp
//
//  Created by Student P_05 on 21/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import "listViewController.h"

@interface listViewController ()

@end

@implementation listViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    placeList = [[NSMutableArray alloc]init];
    
    NSString *range = self.selectedRange;
    
    if (range == NULL) {
        NSLog(@"alert please select range first");
        [self showAlertWithTitle:@"Error" message:@"Please select range first for proceed"];
        
    }
    
    [self getPlaceListWithGoogleAPIKey:@KGoogleAPIKey placeType:self.selectedPlaceType radius:self.selectedRange latitude:@KLatitude longitude:@KLongitude format:@"xml"];

    
    
    
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






-(void)startDetectingLocation{
    
    myLocation = [[CLLocationManager alloc]init];
    myLocation.delegate = self;
    [myLocation setDesiredAccuracy:kCLLocationAccuracyBest];
    [myLocation requestWhenInUseAuthorization];
    [myLocation startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
   
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"Latitude:%0.2f",currentLocation.coordinate.latitude);
    NSLog(@"Longitude:%0.2f",currentLocation.coordinate.longitude);
    
    
    latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
//    self.latitudeLabel.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
//    self.longitudeLabel.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    if (currentLocation != nil) {
        [myLocation stopUpdatingLocation];
        
    }
    
   // [self getPlaceListWithGoogleAPIKey:@KGoogleAPIKey placeType:self.selectedPlaceType radius:self.selectedRange latitude:latitude longitude:longitude format:@"xml"];

    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.localizedDescription);
    
}



-(void)getPlaceListWithGoogleAPIKey:(NSString *)key
                    placeType:(NSString *)type
                       radius:(NSString *)radius
                     latitude:(NSString *)latitude
                    longitude:(NSString *)longitude
                       format:(NSString *)format {
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/%@?location=%@,%@&radius=%@&type=%@&key=%@",format,latitude,longitude,radius,type,key];
    
    NSLog(@"%@",urlString);

    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error:%@",error.localizedDescription);
            
            [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error.localizedDescription]];

        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        parser = [[NSXMLParser alloc]initWithData:data];
                        parser.delegate = self;
                        [parser parse];
                        
                    }
                    else {
                        
                    }
                }
                else {
                    [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode]];
 
                }
            }
            else {
            }
        }
    }];
    [task resume];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placeList.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    listsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lists_cell"];
    NSLog(@"%@",placeList);


    NSMutableDictionary *tempDictionary = [placeList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",tempDictionary);
    
    NSString *placeName = [tempDictionary valueForKey:@"name"];
    NSString *address = [tempDictionary valueForKey:@"vicinity"];
    
    
    
    cell.nameLabel.text = placeName;
    
    cell.nameLabel.textColor = [UIColor blueColor];
    
    cell.nameLabel.font = [UIFont boldSystemFontOfSize:16];
   
    cell.addressLabel.text = address;
    
    cell.addressLabel.textColor = [UIColor darkGrayColor];
    
    cell.addressLabel.font = [UIFont systemFontOfSize:15];
    
    cell.backgroundColor = [UIColor lightTextColor];
   
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    detailsViewController *placeDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsViewController"];
    
    NSDictionary *placeDic = [placeList objectAtIndex:indexPath.row];
    
    NSString *place_id = [placeDic valueForKey:@"place_id"];
    
    NSString *latitudes = [placeDic valueForKey:@"lat"];
    NSString *longitudes = [placeDic valueForKey:@"lng"];
    NSString *photoReference = [placeDic valueForKey:@"photo_reference"];
    NSString *width = [placeDic valueForKey:@"width"];
    NSString *status = [placeDic valueForKey:@"open_now"];
    
    
    
    placeDetailViewController.selectedPlaceID = place_id;
    placeDetailViewController.selectedPlaceLat = latitudes;
    placeDetailViewController.selectedPlaceLng = longitudes;
    placeDetailViewController.selectedPhotoReference = photoReference;
    placeDetailViewController.selectedPhotoWidth = width;
    placeDetailViewController.selectedPlaceStatus = status;
    
    
    
    [self.navigationController pushViewController:placeDetailViewController animated:YES];
    
}



-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if ([elementName isEqualToString:@"result"]) {
        placesDictionary = [[NSMutableDictionary alloc]init];
    }
    else if ([elementName isEqualToString:@"name"]){
        dataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"vicinity"]){
        dataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"place_id"]){
        dataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"rating"]) {
        dataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"lat"]) {
        dataString = [[NSMutableString alloc]init];
    }
    
    else if ([elementName isEqualToString:@"lng"]) {
        dataString = [[NSMutableString alloc]init];
    }
    
    else if ([elementName isEqualToString:@"photo_reference"]) {
        dataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"width"]) {
        dataString = [[NSMutableString alloc]init];
    }
    else if ([elementName isEqualToString:@"open_now"]) {
        dataString = [[NSMutableString alloc]init];
    }
    
    

        
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    dataString = [string mutableCopy];
    
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"result"]) {
        
        [placeList addObject:placesDictionary];
        
    }
    else if ([elementName isEqualToString:@"name"]){
        [placesDictionary setValue:dataString forKey:@"name"];
    }
    else if ([elementName isEqualToString:@"vicinity"]){
        [placesDictionary setValue:dataString forKey:@"vicinity"];
    }
    else if ([elementName isEqualToString:@"place_id"]){
        [placesDictionary setValue:dataString forKey:@"place_id"];
    }
    else if ([elementName isEqualToString:@"lat"]) {
        
        [placesDictionary setValue:dataString forKey:@"lat"];
        
    }
    else if ([elementName isEqualToString:@"lng"]) {
        
        [placesDictionary setValue:dataString forKey:@"lng"];
        
    }
    else if ([elementName isEqualToString:@"photo_reference"]) {
        
        [placesDictionary setValue:dataString forKey:@"photo_reference"];
        
    }
    
    else if ([elementName isEqualToString:@"width"]) {
        
        [placesDictionary setValue:dataString forKey:@"width"];
        
    }
    else if ([elementName isEqualToString:@"rating"]) {
        
        [placesDictionary setValue:dataString forKey:@"rating"];
        
    }
    else if ([elementName isEqualToString:@"open_now"]) {
        
        [placesDictionary setValue:dataString forKey:@"open_now"];
        
    }

    else if ([elementName isEqualToString:@"PlaceSearchResponse"]){
        
        [self performSelectorOnMainThread:@selector(updateDetailsTableView) withObject:nil waitUntilDone:NO];
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
    NSLog(@"parser Error:%@",parseError.localizedDescription);
    [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",parseError.localizedDescription]];

}

-(void)updateDetailsTableView{
    
    [self.listsTableView reloadData];
    
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
