//
//  PQGIFImage.h
//  PQTool
//
//  Created by 盘国权 on 2018/6/27.
//  Copyright © 2018年 pgq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PQGIFImageBlock)(UIImage *GIFImage);

@interface PQGIFImage : NSObject
/** 根据本地GIF图片名 获得GIF image对象 */

+ (UIImage *)imageWithGIFNamed:(NSString *)name;

/** 根据一个GIF图片的data数据 获得GIF image对象 */

+ (UIImage *)imageWithGIFData:(NSData *)data;

/** 根据一个GIF图片的URL 获得GIF image对象 */

+ (void)imageWithGIFUrl:(NSString *)url and:(PQGIFImageBlock)PQGIFImageBlock;
@end
