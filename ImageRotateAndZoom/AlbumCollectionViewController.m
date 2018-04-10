//
//  AlbumCollectionViewController.m
//  ImageRotateAndZoom
//
//  Created by Admin on 28.03.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "AlbumCollectionViewController.h"
#import "Facebook.h"
#import "AlbumCollectionViewCell.h"

@interface AlbumCollectionViewController ()
{
    NSDictionary *albums;
    NSMutableArray *images;
    NSDictionary *image;
    NSDictionary *album;
    Facebook *facebook;
}
@end

@implementation AlbumCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //album = [[NSDictionary alloc] initWithObjectsAndKeys: @"", @"ID", @"", @"name", nil];
    //image = [[NSDictionary alloc] initWithObjectsAndKeys: @"", @"ID", @"", @"albumID", @"", @"image", nil];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    facebook = [[Facebook alloc] init];
    facebook.delegate = self;
    [facebook getAlbumsRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) getImageIDsInAlbums {
//    for (int i = 0; albums && i < albums.count; ++i) {
//        [facebook getImageIDsWithAlbumID:albums[i][@"ID"]];
//    }
//}

- (void) getImagesWithAlbum {
    for (int i = 0 ; i < [[albums valueForKey: @"albums"] count]; ++i) {
        [facebook getImagesWithAlbum: [albums valueForKey: @"albums"][i]];
    }
}
//
//{
//albums: [
//         {
//             albumID : ""
//             albumName : ""
//         images: [
//                  {
//                  imageID: "",
//                  imageData: ""
//                  },
//                  ...
//                  ]
//         },
//         ...
//         ]
//}

- (void)setAlbumIDs:(NSArray *)IDs albumNames:(NSArray *)names {
    if (IDs) {
        albums = [[NSDictionary alloc] initWithObjectsAndKeys: [NSMutableArray array], @"albums", nil];
        for (int i = 0; i < IDs.count; ++i) {
            NSDictionary *album =  [[NSDictionary alloc] initWithObjectsAndKeys: IDs[i], @"albumID", names[i], @"albumName", [NSMutableArray array], @"images", nil];
            [albums valueForKey: @"albums"][i] = album;
        }
        NSLog(@"IDs -> %@ names -> %@", IDs, names);
        [self getImagesWithAlbum];
    }
}

- (void) reloadData {
    NSLog(@"========albums: %@", albums);
    [self.collectionView reloadData];
}

//- (void)setImageIDsWithAlbumID:(NSArray *)imageIDs  albumID:(NSString *)albumID {
//    if (imageIDs) {
//        [albums ob]
//        for (int i = 0; i < imageIDs.count; ++i) {
//            NSDictionary *image = [[NSDictionary alloc] initWithObjectsAndKeys: imageIDs[i], @"ID", albumID, @"albumID", @"", @"image", nil];
//            [images addObject: image];
//        }
//        [albums[@"imageIDs"][[(NSArray *)(albums[@"ids"]) indexOfObject: albumID]] setValue: imageIDs forKey: @"imageIDs"];
//        [self getImageWithImageIDs: imageIDs];
//        NSLog(@"IMAGES -> %@", albums[@"imageIDs"]);
//    }
//}
//
//- (void)setImages: (UIImage *)image withimageID: (NSString *)imageID  inAlbum: (NSString *)albumID {
//    if (imageID) {
//        NSUInteger index = [(NSArray *)(albums[@"ids"]) indexOfObject: albumID];
//        [albums[@"images"][index] insertObject:image atIndex: (albums[@"images"][index] ?  [(NSArray *)(albums[@"images"][index]) count] : 0)];
//        NSLog(@"IMAGES -> %@", albums[@"imageIDs"]);
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return albums ? [[albums valueForKey: @"albums"] count] : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (albums && [albums valueForKey: @"albums"][section] && [[albums valueForKey: @"albums"][section] valueForKey:@"images"]) ? [[[albums valueForKey: @"albums"][section] valueForKey:@"images"] count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell.image setImage: [UIImage imageWithData: [[[albums valueForKey: @"albums"][indexPath.section] valueForKey:@"images"][indexPath.row] valueForKey:@"imageData"]]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
