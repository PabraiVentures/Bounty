//
//  BTYViewController.h
//  Bounty
//
//  Created by Nathan Pabrai on 8/12/14.
//  Copyright (c) 2014 Nathan Pabrai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
@interface BTYViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
-(void) loadMap;
@end
