//
//  BTYMapViewController.m
//  Bounty
//
//  Created by Nathan Pabrai on 9/7/14.
//  Copyright (c) 2014 Nathan Pabrai. All rights reserved.
//

#import "BTYMapViewController.h"

@interface BTYMapViewController ()

@end

@implementation BTYMapViewController
{
    GMSMapView *mapView;
    CLLocationManager* locationManager;
    CLLocation* currentLocation;
    UIView *bountyFormView;
    UIButton *addBounty;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeLocationManager];

}
- (void)viewDidAppear:(BOOL)animated{
    [locationManager startUpdatingLocation];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutAction:(id)sender {
    [PFUser logOut];
    [self viewDidAppear:false];
}

-(void)loadMap{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    NSLog(@"loading map");
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:16.0];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    // Creates a marker in the center of the map.
    UIImage* moneyBag = [UIImage imageNamed:@"money_bag_26"];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position =  currentLocation.coordinate;
    marker.icon = moneyBag;
    marker.title = @"Your";
    marker.snippet = @"Australia";
    marker.map = mapView;
    
    addBounty = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addBounty addTarget:self
               action:@selector(createNewBounty)
     forControlEvents:UIControlEventTouchUpInside];
    [addBounty setTitle:@"Create Bounty" forState:UIControlStateNormal];
    [addBounty setBackgroundColor: [UIColor whiteColor]];
    addBounty.frame = CGRectMake(0.0, 16.0, 120.0, 20.0);
    [mapView addSubview:addBounty];
    
    
}

-(void)initializeLocationManager{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}
//LocationManager Protocol methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    [self loadMap];
}
-(void)createNewBounty{
    addBounty.enabled= false;
    float width= self.view.frame.size.width;
    float height= self.view.frame.size.height;
    bountyFormView = [[UIView alloc]initWithFrame:CGRectMake(40, 40, width-80 , height - 80)];
    [bountyFormView setBackgroundColor:[UIColor redColor]];
    [mapView addSubview:bountyFormView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(closeCreateNewBounty)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Kill" forState:UIControlStateNormal];
    [button setBackgroundColor: [UIColor whiteColor]];
    button.frame = CGRectMake(70.0, 256.0, 120.0, 20.0);
    [bountyFormView addSubview:button];
    
}
-(void)closeCreateNewBounty{
    [bountyFormView removeFromSuperview];
    addBounty.enabled=true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
