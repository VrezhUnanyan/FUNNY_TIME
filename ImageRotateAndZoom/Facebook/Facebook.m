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

- (void) getImagesWithAlbum: (NSDictionary *)album {
    NSString *strAlbumid = [NSString stringWithFormat:@"/%@/photos", [album valueForKey: @"albumID"]];

    //NSString *coverid = [NSString stringWithFormat:@"/%@?fields=picture", albumID];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath: strAlbumid
                                                                   parameters: nil
                                                                   HTTPMethod: @"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Image Result WIth album id: %@ Result: %@", [album valueForKey: @"albumID"], result);
        //NSDictionary *pictureData  = [result valueForKey: @"picture"];
        NSDictionary *data = [result valueForKey: @"data"];
        NSArray *imageIDs = [data valueForKey: @"id"];
        /*NSURL *strUrl = [NSURL URLWithString: [NSString stringWithFormat: @"%@", imagesUrl]];
        NSData *data = [NSData dataWithContentsOfURL: strUrl];
        UIImage *img = [[UIImage alloc] initWithData: data];*/
        //[album setValue: imageIDs forKey: @"imageIDs"];
        for (int i = 0; i < imageIDs.count; ++i) {
            [album valueForKey:@"images"][i] = [[NSDictionary alloc] initWithObjectsAndKeys: imageIDs[i], @"imageID", [[NSData alloc] init], @"imageData", nil];
            [self getImagesWithImageID: imageIDs[i] image: [album valueForKey:@"images"][i] ];
        }
     }];
}
    
- (void) getImagesWithImageID:(NSString *)imageID image:(NSDictionary *) image {
    NSString *strAlbumid = [NSString stringWithFormat:@"/%@/?fields=images", imageID];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:strAlbumid
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSLog(@"IMAGES RESULT: %@", result);
        NSArray *picture_images = [result valueForKey:@"images"];
        NSMutableArray *picCount = [picture_images objectAtIndex:picture_images.count - 1];

        NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[picCount valueForKey:@"source"]]];

        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            /* Fetch the image from the server... */
            [(NSDictionary *)image setValue: [NSData dataWithContentsOfURL: strUrl] forKey: @"imageData"];
            [self.delegate reloadData];
            //[image initWithData: data];
            //[self.delegate setImages:img withimageID: imageID inAlbum: (NSString *)albumID];
        });
    }];
}







@end
