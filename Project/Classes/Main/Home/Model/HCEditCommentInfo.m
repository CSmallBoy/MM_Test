//
//  HCEditCommentInfo.m
//  Project
//
//  Created by 陈福杰 on 15/12/18.
//  Copyright © 2015年 com.xxx. All rights reserved.
//

#import "HCEditCommentInfo.h"

@implementation HCEditCommentInfo

- (NSMutableArray *)FTImages
{
    if (!_FTImages)
    {
        _FTImages = [NSMutableArray array];
        //评论带图的操作
        //[_FTImages addObject:OrigIMG(@"Add-Images")];
        //评论不带图片的
//        UIImage *image =[[UIImage alloc]init];
//        [_FTImages addObject:image];
    }
    return _FTImages;
}

@end
