//
//  ViewController.m
//  Map-C
//
//  Created by Rui on 2016-11-24.
//  Copyright © 2016 Rui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Initialize locationManger object
    CLLocationManager *locationManager=[[CLLocationManager alloc]init];
    self.locationManager = locationManager;
    
    //CLLocationManager is not enabled
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"The location service is not already open on the device");
    }
    
    //if current device is newer then 8.0
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        //Ask always Authorization
        [locationManager requestAlwaysAuthorization];
        //Ask Authorization only when applibation be used
        [locationManager requestWhenInUseAuthorization];
    }
    
    //set delegate is locationManager itself
    locationManager.delegate=self;
    //set accuracy
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    //set relocation distance
    CLLocationDistance distance=10;
    locationManager.distanceFilter=distance;
    
    //start location manager
    [locationManager startUpdatingLocation];
}

//When location change more then relocation distance, will trigger this function
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //get start location
    //CLLocation *startLocation=[locations firstObject];
    //get current location
    CLLocation *currentLocation=[locations lastObject];
    
    //NSLog(@"Old Location %@",startLocation.timestamp);
    
    NSLog(@"New Location %@",currentLocation.timestamp);
    
    //Set coordinater
    CLLocationCoordinate2D coordinate= currentLocation.coordinate;
    
    //NSLog(@"Longitude：%f,Latitude：%f,Altitude：%f,Course：%f,Speed：%f",coordinate.longitude,coordinate.latitude,startLocation.altitude, startLocation.course, startLocation.speed);
    
    NSLog(@"Longitude：%f,Latitude：%f,Altitude：%f,Course：%f,Speed：%f",coordinate.longitude,coordinate.latitude,currentLocation.altitude, currentLocation.course, currentLocation.speed);
    
    //If don't need always using location manager, after update can close it
    //[_locationManager stopUpdatingLocation];
}


// Converting Place Names Into Coordinates
- (IBAction)genocoder:(id)sender {
    
    //Create geocoder object
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    //if input is empty
    if (self.addressTextField.text.length ==0) {
        return;
    }
    [geocoder geocodeAddressString:self.addressTextField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error!=nil || placemarks.count==0) {
            return ;
        }
        //Create placemark object
        CLPlacemark *placemark = [placemarks firstObject];
        //get longitude
        self.longitudeLabel.text =[NSString stringWithFormat:@"Longitude: %f",placemark.location.coordinate.longitude];
        //get latitude
        self.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %f",placemark.location.coordinate.latitude];
        //get detail address
        self.detailAddressLabel.text = [NSString stringWithFormat:@"Detail Address: %@", placemark.name];
        
        //use addressDictionary
        NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
        NSString *addressString = [lines componentsJoinedByString:@"\n"];
        NSLog(@"Address: %@", addressString);
        
        NSLog(@"name=%@\r isoCountryCode=%@\r country=%@\r postalcode=%@\r administrativeArea=%@\r subAdministrativeArea=%@\r locality=%@\r subLocality=%@\r thoroughfare=%@\r subThoroughfare=%@\r region=%@\r timeZone=%@", placemark.name, placemark.ISOcountryCode, placemark.country, placemark.postalCode, placemark.administrativeArea, placemark.subAdministrativeArea, placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare, placemark.region, placemark.timeZone);
    }];
}

// Converting Coordinates into Place Names
- (IBAction)AntiEncoder:(id)sender {
    
    //Create geocoder object
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    
    //if input is empty
    if (self.longitudeTextField.text.length == 0) {
        return;
    }
    
    //if input is empty
    if (self.latitudeTextField.text.length == 0 ) {
        return;
    }
    
    //Create Location
    CLLocation *location=[[CLLocation alloc]initWithLatitude:[self.latitudeTextField.text floatValue] longitude:[self.longitudeTextField.text floatValue]];
    
    //reverse Geocode Location
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error !=nil || placemarks.count == 0) {
            NSLog(@"%@",error);
            return ;
        }
        for (CLPlacemark *placemark in placemarks) {
            //address
            //self.addressLabel.text = [NSString stringWithFormat:@"Address: %@", placemark.name];
            
            //use addressDictionary
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            NSString *addressString = [lines componentsJoinedByString:@" "];
            NSLog(@"Address: %@", addressString);
            
            self.addressLabel.text = addressString;
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
