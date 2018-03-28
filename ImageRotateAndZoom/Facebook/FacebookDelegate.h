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
- (void)setImagesWithAlbumID: (UIImage *)image;
@end
