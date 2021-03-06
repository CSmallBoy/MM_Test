//
//  HCTagAddObjectApi.m
//  Project
//
//  Created by 朱宗汉 on 16/4/11.
//  Copyright © 2016年 com.xxx. All rights reserved.
//

#import "HCTagAddObjectApi.h"
#import "HCNewTagInfo.h"

// -------------------添加对象----------------------

@implementation HCTagAddObjectApi

-(void)startRequest:(HCTagAddObjectBlock)requestBlock
{
    [super startRequest:requestBlock];
}

-(NSString *)requestUrl
{
   return @"Label/createObject.do";
}

-(id)requestArgument
{
    NSDictionary *head = @{@"platForm":[readUserInfo GetPlatForm],
                           @"token":[HCAccountMgr manager].loginInfo.Token,
                           @"UUID":[HCAccountMgr manager].loginInfo.UUID};
    
  

    
    
    if ([_openHealthCard isEqualToString:@"0"]) {
        
        
        NSDictionary *para2 =@{@"trueName":_info.trueName,
                               @"imageName":_info.imageName,
                               @"sex":_info.sex,
                               @"birthDay":_info.birthDay,
                               @"homeAddress":_info.homeAddress,
                               @"school":_info.school,
                               
                               @"openHealthCard":_openHealthCard,
                               
                               
                               @"relation1":_info.relation1,
                               @"contactorId1":_info.contactorId1,
                               @"relation2":_info.relation2,
                               @"contactorId2":_info.contactorId2};
        return @{@"Head":head,
                 @"Para":para2};

    }
    else
    {
        NSDictionary *para1 = @{@"trueName":_info.trueName,
                                @"imageName":_info.imageName,
                                @"sex":_info.sex,
                                @"birthDay":_info.birthDay,
                                @"homeAddress":_info.homeAddress,
                                @"school":_info.school,
                                
                                @"openHealthCard":_openHealthCard,
                                
                                @"height":_info.height,
                                @"weight":_info.weight,
                                @"bloodType":_info.bloodType,
                                @"allergic":_info.allergic,
                                @"cureCondition":_info.cureCondition,
                                @"cureNote":_info.cureNote,
                                
                                
                                @"relation1":_info.relation1,
                                @"contactorId1":_info.contactorId1,
                                @"relation2":_info.relation2,
                                @"contactorId2":_info.contactorId2};
        return @{@"Head":head,
                 @"Para":para1};
    }
    
}

-(id)formatResponseObject:(id)responseObject
{
    return responseObject;
}

@end
