//
//  Facebook.h
//  ImageRotateAndZoom
//
//  Created by Admin on 29.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookDelegate.h"

@interface Facebook : NSObject
@property (nonatomic, weak)id <FacebookDelegate> delegate;
- (void) getAlbumsRequest;
- (void) getImageWithAlbumID: (NSString *)albumID;
@end
