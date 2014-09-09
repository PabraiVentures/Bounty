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
    UILabel *detailDefaultText;
    UILabel *priceDefaultText;
    UILabel *titleDefaultText;
    UITextView *price;
    UITextView *detail;
    UITextView *title;
    
    UIImagePickerController *imagePicker;
    UIImageView * selectedBountyImage;
    UIButton *bountyPicture;
    NSMutableArray *locationPickerViews;
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
    [locationManager startUpdatingLocation];


}
- (void)viewDidAppear:(BOOL)animated{
    
    if (!locationManager) {
        [self initializeLocationManager];
        [locationManager startUpdatingLocation];
    }

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
    float margin = 20;
    float spacing = 20;
    bountyFormView = [[UIView alloc]initWithFrame:CGRectMake(margin, margin, width-(2*margin) , height - (2*margin))];
    [bountyFormView setBackgroundColor:[UIColor whiteColor]];
    bountyFormView.alpha = .90;
    [mapView addSubview:bountyFormView];
    
    /*UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(closeCreateNewBounty)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Kill" forState:UIControlStateNormal];
    [button setBackgroundColor: [UIColor whiteColor]];
    button.frame = CGRectMake(70.0, 256.0, 120.0, 20.0);
    [bountyFormView addSubview:button];
     */
    float formHeight = bountyFormView.frame.size.height;
    float formWidth = bountyFormView.frame.size.width;
    
    //title for bounty at top
    //---><---//
    //\\\^//////
    
    title = [[UITextView alloc] initWithFrame:CGRectMake(margin+.5*spacing, 0,formWidth-(2*margin + spacing),2*spacing)];
    title.font = [UIFont fontWithName:@"Helvetica Neue" size:22.0];
    title.textAlignment = NSTextAlignmentCenter;
    title.delegate = self;
    [bountyFormView addSubview:title];

    titleDefaultText = [[UILabel alloc] initWithFrame:CGRectMake(margin+.5*spacing,0,formWidth-(2*margin + spacing),2*spacing)];
    titleDefaultText.text = @"Name your Bounty";
    titleDefaultText.font = [UIFont fontWithName:@"Helvetica Neue" size:22.0];
    titleDefaultText.textColor = [UIColor lightGrayColor];
    [title addSubview:titleDefaultText];

    
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(margin+.5*spacing, margin+spacing, formWidth-(2*margin + spacing), spacing)];
    location.font= [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    location.text= @"Your Current Location";
    location.textAlignment=NSTextAlignmentCenter;
    [bountyFormView addSubview:location];
    
    UIButton *changeLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changeLocation addTarget:self action:@selector(changeBountyLocation) forControlEvents:UIControlEventTouchUpInside];
    [changeLocation setTitle:@"Specify other location" forState:UIControlStateNormal];
    changeLocation.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    [changeLocation setBackgroundColor:[UIColor whiteColor]];
    changeLocation.frame = CGRectMake(margin+.5*spacing, margin+2*spacing, formWidth-(2*margin + spacing), spacing);
    [bountyFormView addSubview:changeLocation];
 
    detail = [[UITextView alloc]initWithFrame:CGRectMake(margin+.5*spacing, margin+3*spacing, formWidth-(2*margin + spacing), 4*spacing)];
    detail.delegate = self;
    detail.editable = true;
    [bountyFormView addSubview:detail];
    
    detailDefaultText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, formWidth-(2*margin + spacing), spacing)];
    detailDefaultText.text = @"What do you want done today?";
    detailDefaultText.textColor = [UIColor lightGrayColor];
    detailDefaultText.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    detailDefaultText.textAlignment=NSTextAlignmentCenter;
    [detail addSubview:detailDefaultText];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin+.5*spacing,margin+7*spacing,formWidth-(2*margin +spacing), spacing)];
    priceLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    priceLabel.text = @"What Bounty are you posting?";
    priceLabel.textAlignment=NSTextAlignmentCenter;
    [bountyFormView addSubview:priceLabel];
 
    price = [[UITextView alloc] initWithFrame:CGRectMake(margin+.5*spacing,margin+8*spacing,formWidth-(2*margin+spacing),spacing)];
    price.keyboardType= UIKeyboardTypeDecimalPad;
    price.textAlignment=NSTextAlignmentCenter;
    price.delegate = self;
    [bountyFormView addSubview:price];
    
    priceDefaultText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, formWidth-(2*margin + spacing), spacing)];
    priceDefaultText.text = @"9.50";
    priceDefaultText.textColor = [UIColor lightGrayColor];
    priceDefaultText.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    priceDefaultText.textAlignment=NSTextAlignmentCenter;
    [price addSubview:priceDefaultText];
    
    UIImageView* bag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dollar_sign_19"]];
    bag.frame=CGRectMake(margin+.5*spacing + 19 ,margin+8*spacing, 15, 15);
    [bountyFormView addSubview:bag];
    
    bountyPicture = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bountyPicture addTarget:self
    action:@selector(addBountyPicture)
    forControlEvents:UIControlEventTouchUpInside];
    [bountyPicture setTitle:@"Bounty Picture" forState:UIControlStateNormal];
    bountyPicture.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bountyPicture setBackgroundColor: [UIColor whiteColor]];
    bountyPicture.frame = CGRectMake(margin+.5*spacing,margin+9*spacing, formWidth-(2*margin+spacing), spacing*2);
    [bountyFormView addSubview:bountyPicture];
    
    UIDatePicker* datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(margin+.5*spacing,margin+11*spacing, 0,0)];
    datepicker.datePickerMode = UIDatePickerModeDate;
    datepicker.minuteInterval = 5;
    //datepicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    datepicker.datePickerMode = UIDatePickerModeTime;
    [datepicker addTarget:self action:@selector(bountyTimeChanged) forControlEvents:UIControlEventValueChanged];
    [bountyFormView addSubview:datepicker];
    
    
}


-(void) closeCreateNewBounty{
    [bountyFormView removeFromSuperview];
    addBounty.enabled=true;
}

//Called when creating a bounty and the user wants to pick a custom location
//This should present a map instructing the user to drop a pin at the desired location and confirm or canel
//Should return control to the bountyFormView
-(void) changeBountyLocation{
    locationPickerViews = [[NSMutableArray alloc] init];
    float height=self.view.frame.size.height;
    float width=self.view.frame.size.width;
    bountyFormView.hidden = true;
    addBounty.hidden = true;
    
    UILabel* dropLocation = [[UILabel alloc] init];
    dropLocation.frame = CGRectMake(40, 24.0,width-80 , 28);
    dropLocation.text = @"Drop the location";
    dropLocation.textAlignment= NSTextAlignmentCenter;
    dropLocation.backgroundColor = [UIColor lightGrayColor];
    dropLocation.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    [self.view addSubview:dropLocation];
    [locationPickerViews addObject:dropLocation];
    
    UIButton *confirmLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirmLocation addTarget:self action:@selector(confirmLocation) forControlEvents:UIControlEventTouchUpInside];
    confirmLocation.enabled = false;
    [confirmLocation setBackgroundColor:[UIColor lightGrayColor]];
    confirmLocation.frame = CGRectMake(10, height-42, 32, 32);
    [confirmLocation setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [self.view addSubview:confirmLocation];
    [locationPickerViews addObject:confirmLocation];
    
    UIButton *revertLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [revertLocation addTarget:self action:@selector(revertLocation) forControlEvents:UIControlEventTouchUpInside];
    [revertLocation setBackgroundColor:[UIColor lightGrayColor]];
    revertLocation.frame = CGRectMake(width-42, height-42, 32, 32);
    [revertLocation setImage:[UIImage imageNamed:@"nope"] forState:UIControlStateNormal];
    [self.view addSubview:revertLocation];
    [locationPickerViews addObject:revertLocation];
    
}
-(void) revertLocation{
    for (id view in locationPickerViews) {
        [((UIView*)view) removeFromSuperview];
    }
    bountyFormView.hidden = false;
    addBounty.hidden = false;
}
-(void) addBountyPicture{
    //Uses imagePicker to let user pick an image
    imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
     else
         imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}
//UITextView Protocol methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == detail)detailDefaultText.hidden = YES;
    if(textView == price) priceDefaultText.hidden = YES;
    if(textView == title)titleDefaultText.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView == detail) detailDefaultText.hidden = ([textView.text length] > 0);
    if(textView == price)priceDefaultText.hidden  = ([textView.text length] > 0 );
    if(textView == title)titleDefaultText.hidden = ([textView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == detail) detailDefaultText.hidden = ([textView.text length] > 0);
    if(textView == price)priceDefaultText.hidden  = ([textView.text length] > 0 );
    if(textView == title)titleDefaultText.hidden = ([textView.text length] > 0);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([price isFirstResponder] && [touch view] != price) {
        [price resignFirstResponder];
    }
    if ([detail isFirstResponder] && [touch view] != detail) {
        [detail resignFirstResponder];
    }
    if ([title isFirstResponder] && [touch view] != title) {
        [title resignFirstResponder];
    }

    [super touchesBegan:touches withEvent:event];
}

//UIImagePicker Protocol methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *) picker

didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    selectedBountyImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [bountyPicture setImage:selectedBountyImage.image forState:UIControlStateNormal];
    
}

//DateChanged
-(void) bountyTimeChanged{
    
}

//MapView Protocol methods
-(void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    
}
@end