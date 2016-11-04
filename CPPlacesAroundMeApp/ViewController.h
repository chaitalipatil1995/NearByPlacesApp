//
//  ViewController.h
//  CPPlacesAroundMeApp
//
//  Created by Student P_05 on 21/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "listViewController.h"
#import "listViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *placeType;
    UISlider *localSlider;
    NSString *range;
}
- (IBAction)rangeSetterSlider:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *placeTypeTableView;
@property (strong, nonatomic) IBOutlet UISlider *rangeSet;

@end

