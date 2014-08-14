//
//  R2Connection.m
//  Bounty
//
//  Created by Nathan Pabrai on 8/13/14.
//  Copyright (c) 2014 Nathan Pabrai. All rights reserved.
//

#import "R2Connection.h"

@implementation R2Connection
-(BOOL) setupUserWithToken:(NSString *)token{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://r2-env-znjehk5kjg.elasticbeanstalk.com/"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"POST"];
    NSString *post = token;
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSLog(@"output of the --- request --- is : \n%@", ([response1 length] > 0)?[NSString stringWithUTF8String:[response1 bytes]]: @"emptystring");
    return true;
}
@end
