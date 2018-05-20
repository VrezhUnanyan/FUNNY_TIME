//
//  FacebookDelegate.h
//  ImageRotateAndZoom
//
//  Created by Admin on 29.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FacebookDelegate <NSObject>
@optional
- (void)setAlbumIDs: (NSArray *)IDs albumNames: (NSArray *)names;
//- (void)setImageIDsWithAlbumID: (NSArray *)imagesIDs  albumID: (NSString *)albumID;
//- (void)setImages: (UIImage *)image withimageID: (NSString *)imageID;
- (void)reloadData;
@end
