//
//  HCNotifcationMessageCell.m
//  Project
//
//  Created by 朱宗汉 on 16/1/29.
//  Copyright © 2016年 com.xxx. All rights reserved.
//

#import "HCNotifcationMessageCell.h"
#import "HCNotifcationMessageInfo.h"

#define INTERVAL 10

@interface HCNotifcationMessageCell ()

@property (nonatomic,strong) UIImageView  *headIV;
@property (nonatomic,strong) UILabel      *titleLabel;
@property (nonatomic,strong) UILabel      *messageLabel;
@property (nonatomic,strong) UILabel      *timeLabel;

@end



@implementation HCNotifcationMessageCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
   static  NSString   * ID = @"messageCellID";
    HCNotifcationMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HCNotifcationMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews];
    }
    return cell;
    
}



#pragma mark ---- private mothods

-(void)addSubviews
{

    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self addSubview:self.headIV];
    [self addSubview:self.timeLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];

}


#pragma mark --- getter Or setter


-(void)setMessageInfo:(HCNotifcationMessageInfo *)messageInfo
{
    _messageInfo = messageInfo;
    
    self.titleLabel.text = messageInfo.title;
    self.timeLabel.text = [NSString stringWithFormat:@"留言时间：%@",messageInfo.time];
    self.messageLabel.text = messageInfo.message;
  
}


- (UIImageView *)headIV
{
    if(!_headIV){
        _headIV = [[UIImageView alloc]initWithFrame:CGRectMake(INTERVAL, INTERVAL, 60, 60)];
        _headIV.image = IMG(@"label_Head-Portraits");
        
    }
    return _headIV;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, INTERVAL, 150, 30)];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -150, INTERVAL, 150, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor  = [UIColor lightGrayColor];
    }
    return _timeLabel;
}



- (UILabel *)messageLabel
{
    if(!_messageLabel){
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH-80, 30)];
        _messageLabel.font = [UIFont systemFontOfSize:14];
    }
    return _messageLabel;
}



@end