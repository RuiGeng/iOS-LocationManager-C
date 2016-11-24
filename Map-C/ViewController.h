//
//  ViewController.h
//  Map-C
//
//  Created by Rui on 2016-11-24.
//  Copyright © 2016 Rui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;

@end

