//
//  R2Connection.h
//  Bounty
//
//  Created by Nathan Pabrai on 8/13/14.
//  Copyright (c) 2014 Nathan Pabrai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface R2Connection : NSObject
//Sends request to R2 to make new user and returns true if it recieves a sucess response from R2
-(BOOL) setupUserWithToken:(NSString*) token;
@end
