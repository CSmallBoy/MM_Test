//
//  NHCUSerInfoApi.m
//  Project
//
//  Created by 朱宗汉 on 16/3/23.
//  Copyright © 2016年 com.xxx. All rights reserved.
//

#import "NHCUSerInfoApi.h"

@implementation NHCUSerInfoApi
- (void)startRequest:(NHCUserInfo)requestBlock
{
    [super startRequest:requestBlock];
}

- (NSString *)requestUrl
{   //完善用户信息
    return @"User/addUserInfo.do";
}
- (id)requestArgument
{   //完善用户信息
    NSDictionary *dict = [readUserInfo getReadDic];
    NSDictionary *head = @{@"UUID":dict[@"UserInf"][@"uuid"],
                           @"platForm":[readUserInfo GetPlatForm],
                           @"token":[HCAccountMgr manager].loginInfo.Token};
    
    if (IsEmpty(_myModel.nickName)) {
        _myModel.nickName = @"";
    }else if (IsEmpty(_myModel.adress)){
        _myModel.adress = @"";
    }else if (IsEmpty(_myModel.professional)){
        _myModel.professional = @"";
    }else if (IsEmpty(_myModel.company)){
        _myModel.company = @"";
    }else if (IsEmpty(_myModel.birday)){
        _myModel.birday = @"";
    }else if (IsEmpty(_myModel.userPhoto)){
        _myModel.userPhoto = @"";
    }
    NSDictionary *para = @{@"nickName":_myModel.nickName,
                           @"homeAddress":_myModel.adress,
                           @"career":_myModel.professional,
                           @"userDescription":@"日行一善",
                           @"company":_myModel.company,
                           @"birthDay":_myModel.birday,
                           @"imageName":_myModel.userPhoto
                           };
    NSDictionary *body = @{@"Para":para,@"Head":head};
    return body;
}
- (id)formatResponseObject:(id)responseObject
{
    NSString *str = responseObject[@"Data"][@"chineseZodiac"];
    return str;
}
@end
