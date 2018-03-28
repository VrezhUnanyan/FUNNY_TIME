//
//  Facebook.m
//  ImageRotateAndZoom
//
//  Created by Admin on 29.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "Facebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKPlacesKit/FBSDKPlacesKit.h>

@implementation Facebook
- (void) getAlbumsRequest {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath: @"me/albums"
                                                                    parameters: nil
                                                                    HTTPMethod: @"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"ALBUM Result %@",result);
            NSDictionary *data = [result valueForKey: @"data"];
            [self.delegate setAlbumIDs: [data valueForKey: @"id"]
                            albumNames: [data valueForKey: @"name"]];
        }
    }];
}

- (void) getImageWithAlbumID: (NSString *)albumID {
    NSString *coverid = [NSString stringWithFormat:@"/%@?fields=picture", albumID];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath: coverid
                                                                   parameters: nil
                                                                   HTTPMethod: @"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Image Result WIth album id: %@ Result: %@", albumID, result);
        NSDictionary *pictureData  = [result valueForKey: @"picture"];
        NSDictionary *redata = [pictureData valueForKey: @"data"];
        NSURL *imagesUrl = [redata valueForKey: @"url"];
        NSURL *strUrl = [NSURL URLWithString: [NSString stringWithFormat: @"%@", imagesUrl]];
        NSData *data = [NSData dataWithContentsOfURL: strUrl];
        UIImage *img = [[UIImage alloc] initWithData: data];
        [self.delegate setImagesWithAlbumID: img];
     }];
}
@end
