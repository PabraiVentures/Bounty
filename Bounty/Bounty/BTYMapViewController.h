//
//  BTYMapViewController.h
//  Bounty
//
//  Created by Nathan Pabrai on 9/7/14.
//  Copyright (c) 2014 Nathan Pabrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface BTYMapViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate, UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong,nonatomic) UITextField *priceField;
-(void) loadMap;
@end
