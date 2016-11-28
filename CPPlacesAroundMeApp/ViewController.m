//
//  ViewController.m
//  CPPlacesAroundMeApp
//
//  Created by Student P_05 on 21/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    placeType =@[@"accounting",
                 @"airport",
                 @"amusement_park",
                 @"aquarium",
                 @"art_gallery",
                 @"atm",
                 @"bakery",
                 @"bank",
                 @"bar",
                 @"beauty_salon",
                 @"bicycle_store",
                 @"book_store",
                 @"bowling_alley",
                 @"bus_station",
                 @"cafe",
                 @"campground",
                 @"car_dealer",
                 @"car_rental",
                 @"car_repair",
                 @"car_wash",
                 @"casino",
                 @"cemetery",
                 @"church",
                 @"city_hall",
                 @"clothing_store",
                 @"convenience_store",
                 @"courthouse",
                 @"dentist",
                 @"department_store",
                 @"doctor",
                 @"electrician",
                 @"electronics_store",
                 @"embassy",
                 @"establishment (deprecated)",
                 @"finance (deprecated)",
                 @"fire_station",
                 @"florist",
                 @"food (deprecated)",
                 @"funeral_home",
                 @"furniture_store",
                 @"gas_station",
                 @"general contractor (deprecated)",
                 @"grocery or supermarket (deprecated)",
                 @"Gym",
                 @"Hair care",
                 @"Hardware store",
                 @"Health (deprecated)",
                 @"Hindu temple",
                 @"Home goods store",
                 @"Hospital",
                 @"Insurance agency",
                 @"Jewelry store",
                 @"Laundry",
                 @"lawyer",
                 @"Library",
                 @"Liquor store",
                 @"Local government office",
                 @"Locksmith",
                 @"Lodging",
                 @"Meal delivery",
                 @"Meal takeaway",
                 @"Mosque",
                 @"Movie rental",
                 @"Movie theater",
                 @"Moving company",
                 @"Museum",
                 @"Night club",
                 @"Painter",
                 @"Park",
                 @"Parking",
                 @"Pet store",
                 @"Pharmacy",
                 @"Physiotherapist",
                 @"Place of worship (deprecated)",
                 @"Plumber",
                 @"Police",
                 @"Post office",
                 @"Real estate agency",
                 @"Restaurant",
                 @"Roofing contractor",
                 @"Rv park",
                 @"School",
                 @"Shoe store",
                 @"Shopping mall",
                 @"Spa",
                 @"Stadium",
                 @"Storage",
                 @"Store",
                 @"Subway station",
                 @"Synagogue",
                 @"Taxi stand",
                 @"Train station",
                 @"Transit station",
                 @"Travel agency",
                 @"University",
                 @"Veterinary care",
                 @"Zoo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return placeType.count;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    
//    cell.textLabel.text = [placeType objectAtIndex:indexPath.row];
//    
//    return cell;
//    
//    
//    
//}
//
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString *placeTypes = [placeType objectAtIndex:indexPath.row];
//    
//    listViewController *placeListController = [self.storyboard instantiateViewControllerWithIdentifier:@"listViewController"];
//    
//    placeListController.selectedPlaceType = placeTypes;
//    [self.navigationController pushViewController:placeListController animated:YES];
//    
//
//
//
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:22];

    cell.textLabel.text = [placeType objectAtIndex:indexPath.row];
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 20.0 ];
    cell.textLabel.font  = myFont;

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *place = [placeType objectAtIndex:indexPath.row];
    NSString* placeTypes = [place stringByReplacingOccurrencesOfString:@" " withString:@"_"];

    listViewController *placeListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"listViewController"];
    
    placeListViewController.selectedPlaceType = placeTypes;
    placeListViewController.selectedRange = range;
    [self.navigationController pushViewController:placeListViewController animated:YES];
    
    
}


- (IBAction)rangeSetterSlider:(id)sender {
    
    self.rangeSet.minimumValue = 500;
    self.rangeSet.maximumValue = 5000;
    
    [self.rangeSet addTarget:self action:@selector(handleSlider:) forControlEvents:UIControlEventValueChanged];


}

-(void)handleSlider:(id)sender{
    //type convert
    localSlider = sender;
    range = [NSString stringWithFormat:@"%f",localSlider.value];
    NSLog(@"%f",localSlider.value);
    
}
@end
