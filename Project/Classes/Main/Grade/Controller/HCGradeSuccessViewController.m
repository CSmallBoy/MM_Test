//
//  HCGradeSuccessViewController.m
//  Project
//
//  Created by 陈福杰 on 15/12/24.
//  Copyright © 2015年 com.xxx. All rights reserved.
//

#import "HCGradeSuccessViewController.h"
#import "HCCreateGradeInfo.h"
#import "AppDelegate.h"
#import "ZXingObjC.h" // 二维码

@interface HCGradeSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *joinMemberBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *codingBtn;
@property (weak, nonatomic) IBOutlet UILabel *gradeIdNum;

@property (nonatomic, strong) HCCreateGradeInfo *info;

@end

@implementation HCGradeSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"完成创建";
    [self setupBackItem];
    
    ViewRadius(_joinMemberBtn, 4);
    ViewRadius(_nextBtn, 4);
    
    _info = self.data[@"data"];
    self.gradeIdNum.text = @"恭喜您完胜了家庭创建";
    self.gradeIdNum.font = [UIFont systemFontOfSize:14];
    self.gradeIdNum.textColor = kHCNavBarColor;
    
    UILabel *familuIdLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxX(self.gradeIdNum.frame)+20, SCREEN_WIDTH-20, 20)];
    familuIdLB.text = [NSString stringWithFormat:@"您的家庭ID是%@",_info.familyId];
    familuIdLB.font = [UIFont systemFontOfSize:14];
    familuIdLB.textAlignment = NSTextAlignmentCenter;
    familuIdLB.textColor = kHCNavBarColor;
    
    [self.view addSubview:familuIdLB];
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:_info.familyId
                                  format:kBarcodeFormatQRCode
                                   width:WIDTH(self.view)
                                  height:WIDTH(self.view)
                                   error:&error];
    if (result)
    {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        [_codingBtn setImage:[UIImage imageWithCGImage:image] forState:UIControlStateNormal];
    }
}

- (IBAction)joinMemberButton:(UIButton *)sender
{
}

- (IBAction)nextButton:(UIButton *)sender
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setupRootViewController];
}



@end
