//
//  UYUPresDetialViewController.m
//  UYUClient
//
//  Created by mac on 17/4/12.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUPresDetialViewController.h"
#import "UIView+YSKit.h"
#import "Macro.h"
#import "UYUColor.h"
#import "UYUHttpHandler.h"
#import "UYUCheckBox.h"
#import "UIButton+ButtonStyle.h"
#import "UYUPresModel.h"
#import "UYUHttpHandler.h"
#import "UYUUserInfo.h"
#import "SVProgressHUD.h"


#define kTitleWidth AdaptWidth(64)
#define kRowHeight  AdaptWidth(40)
#define kContentLeft (16+8+kTitleWidth)
#define kContentWith (kScreenWidth - (16*2+8+kTitleWidth))

@interface UYUPresDetialViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UYUPresNameMenuDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIView *trainTimesView;//训练次数
@property (nonatomic, strong) UIView *trainTypeView;//集合散开
@property (nonatomic, strong) UIView *eyeTypeView;//单眼双眼
@property (nonatomic, strong) UIView *leftEyeGradeView;//左眼等级
@property (nonatomic, strong) UIView *rightEyeGradeView;//右眼等级
@property (nonatomic, strong) UIView *fontSizeView;//字体等级
@property (nonatomic, strong) UIView *lineTypeView;//线类型
@property (nonatomic, strong) UIView *lineCountView;//先的条数
@property (nonatomic, strong) UIView *imageCountView;//图的个数

@property (nonatomic, strong) UITextField *trainTimesTF;//训练次数
@property (nonatomic, strong) UITextField *leftEyeGradeTF;//左眼等级
@property (nonatomic, strong) UITextField *rightEyeGradeTF;//右眼等级
@property (nonatomic, strong) UITextField *fontSizeTF;//字体等级
@property (nonatomic, strong) UITextField *lineCountTF;//先的条数
@property (nonatomic, strong) UITextField *imageCountTF;//图的个数

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIPickerView *fontSizePicker;//字体大小级别
@property (nonatomic, strong) UIPickerView *eyeGradePicker;//眼睛等级
@property (nonatomic, strong) UIToolbar    *toolBar;

@property (nonatomic, strong) NSArray *fontSizeArray;
@property (nonatomic, strong) NSArray *eyeGradeArray;

@property (nonatomic, strong) NSMutableArray *subViewsArray;

@property (nonatomic, strong) NSDictionary *presNamesDict;

@property (nonatomic, copy) NSString *letterSize;
@property (nonatomic, copy) NSString *leftEyeLevel;
@property (nonatomic, copy) NSString *rightEyeLevel;
@property (nonatomic, copy) NSString *lineType;
@property (nonatomic, copy) NSString *eyeType;
@property (nonatomic, copy) NSString *trainType;

@end

@implementation UYUPresDetialViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAddPrescription = YES;
        self.currentPresType = @"stereoscope";
    }
    return self;
}

- (NSDictionary *)presNamesDict{
    if (_presNamesDict == nil) {
        _presNamesDict = @{@"stereoscope":@"立体镜",
                           @"fractured_ruler":@"裂隙尺",
                           @"reversal":@"翻转拍",
                           @"red_green_read":@"红绿阅读训练",
                           @"approach":@"推进训练",
                           @"r_g_variable_vector":@"红绿可变训练",
                           @"r_g_fixed_vector":@"红绿固定训练",
                           @"glance":@"扫视",
                           @"follow":@"追随训练"};
    }
    return _presNamesDict;
}

- (NSMutableArray *)subViewsArray
{
    if (_subViewsArray == nil) {
        _subViewsArray = [NSMutableArray array];
    }
    return _subViewsArray;
}
- (UILabel *)createTitleLabelWithTitle:(NSString *)title
{
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kTitleWidth, kRowHeight)];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.text = title;
    return titleLab;

}

- (UITextField *)createTextFieldWithPlaceHoder:(NSString *)placeHoder tag:(NSInteger)tag
{
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(kContentLeft, 0, kContentWith, kRowHeight)];
    tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.placeholder = placeHoder;
    tf.font = [UIFont systemFontOfSize:15];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.delegate = self;
    [tf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    return tf;
}

- (UIView *)createLine
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kContentLeft, kRowHeight - 2, kContentWith, 2)];
    line.backgroundColor = [UYUColor uyuGreenColor];
    return line;
}
- (UIView *)createPadView
{
    UIView *padView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRowHeight)];
    padView.backgroundColor = [UIColor whiteColor];
    return padView;
}
- (UIButton *)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = [UYUColor uyuGreenColor];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureButton.layer.cornerRadius = 3;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setTitle:@"确  定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sureButton;
}
- (UYUCheckBox *)createCheckBoxWithTitle:(NSString *)title checked:(BOOL)checked
{
    
        UYUCheckBox *checkBox = [UYUCheckBox buttonWithType:UIButtonTypeCustom];
        checkBox.selected = checked;
        checkBox.titleLabel.font = [UIFont systemFontOfSize:15];
        [checkBox setImage:[UIImage imageNamed:@"ic_unselect"] forState:UIControlStateNormal];
        [checkBox setImage:[UIImage imageNamed:@"ic_select"] forState:UIControlStateSelected];
        [checkBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [checkBox setTitle:title forState:UIControlStateNormal];
    return checkBox;
}
- (UIView *)trainTimesView{
    if (_trainTimesView == nil) {
        _trainTimesView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"训练次数"];
        _trainTimesTF = [self createTextFieldWithPlaceHoder:@"请输入训练次数(默认1次)" tag:5001];
        
        [_trainTimesView addSubview:titleLab];
        [_trainTimesView addSubview:_trainTimesTF];
        [_trainTimesView addSubview:[self createLine]];
    }
    return _trainTimesView;
}

- (UIView *)trainTypeView{
    if (_trainTypeView == nil) {
        _trainTypeView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"训练类型"];
        UYUCheckBox *checkBoxJihe = [self createCheckBoxWithTitle:@"集合" checked:YES];
        UYUCheckBox *checkBoxSankai = [self createCheckBoxWithTitle:@"散开" checked:NO];
        
        checkBoxJihe.frame = CGRectMake(kContentLeft, 0, kContentWith/2.0, kRowHeight);
        checkBoxSankai.frame = CGRectMake(checkBoxJihe.right, 0, checkBoxJihe.width, kRowHeight);
        
        [checkBoxJihe addTarget:self action:@selector(jiheSankaiAction:) forControlEvents:UIControlEventTouchUpInside];
        [checkBoxSankai addTarget:self action:@selector(jiheSankaiAction:) forControlEvents:UIControlEventTouchUpInside];

        checkBoxJihe.tag = 1000;
        checkBoxSankai.tag = 1001;
        
        [_trainTypeView addSubview:titleLab];
        [_trainTypeView addSubview:checkBoxJihe];
        [_trainTypeView addSubview:checkBoxSankai];
        [_trainTypeView addSubview:[self createLine]];
    }
    return _trainTypeView;
}

- (UIView *)eyeTypeView{
    if (_eyeTypeView == nil) {
        _eyeTypeView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"眼睛类型"];
        UYUCheckBox *checkBoxOne = [self createCheckBoxWithTitle:@"单眼" checked:YES];
        UYUCheckBox *checkBoxTwo = [self createCheckBoxWithTitle:@"双眼" checked:NO];
        
        checkBoxOne.frame = CGRectMake(kContentLeft, 0, kContentWith/2.0, kRowHeight);
        checkBoxTwo.frame = CGRectMake(checkBoxOne.right, 0, checkBoxOne.width, kRowHeight);
        
        [checkBoxOne addTarget:self action:@selector(eyeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [checkBoxTwo addTarget:self action:@selector(eyeTypeAction:) forControlEvents:UIControlEventTouchUpInside];

        checkBoxOne.tag = 2001;
        checkBoxTwo.tag = 2002;
        
        [_eyeTypeView addSubview:titleLab];
        [_eyeTypeView addSubview:checkBoxOne];
        [_eyeTypeView addSubview:checkBoxTwo];
        [_eyeTypeView addSubview:[self createLine]];

    }
    return _eyeTypeView;
}

- (UIView *)leftEyeGradeView{
    if (_leftEyeGradeView == nil) {
        _leftEyeGradeView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"左眼等级"];
        _leftEyeGradeTF = [self createTextFieldWithPlaceHoder:@"(一级)+1.50/-1.50" tag:6000];
        _leftEyeGradeTF.text = @"(一级)+1.50/-1.50";
        _leftEyeGradeTF.inputAccessoryView = self.toolBar;
        _leftEyeGradeTF.inputView = self.eyeGradePicker;
        
        [_leftEyeGradeView addSubview:titleLab];
        [_leftEyeGradeView addSubview:_leftEyeGradeTF];
        [_leftEyeGradeView addSubview:[self createLine]];
    }
    return _leftEyeGradeView;
}
- (UIView *)rightEyeGradeView{
    if (_rightEyeGradeView == nil) {
        _rightEyeGradeView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"右眼等级"];
        _rightEyeGradeTF = [self createTextFieldWithPlaceHoder:@"(一级)+1.50/-1.50" tag:6001];
        _rightEyeGradeTF.text = @"(一级)+1.50/-1.50";
        _rightEyeGradeTF.inputAccessoryView = self.toolBar;
        _rightEyeGradeTF.inputView = self.eyeGradePicker;
        
        [_rightEyeGradeView addSubview:titleLab];
        [_rightEyeGradeView addSubview:_rightEyeGradeTF];
        [_rightEyeGradeView addSubview:[self createLine]];
    }
    return _rightEyeGradeView;
}

- (UIView *)fontSizeView{
    if (_fontSizeView == nil) {
        _fontSizeView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"字体级别"];
        _fontSizeTF = [self createTextFieldWithPlaceHoder:@"字体大小(1级最大)" tag:6002];
        _fontSizeTF.inputView = self.fontSizePicker;
        _fontSizeTF.inputAccessoryView = self.toolBar;
        
        [_fontSizeView addSubview:titleLab];
        [_fontSizeView addSubview:_fontSizeTF];
        [_fontSizeView addSubview:[self createLine]];

    }
    return _fontSizeView;
}
- (UIView *)lineTypeView{
    if (_lineTypeView == nil) {
        _lineTypeView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"线条类型"];
        UYUCheckBox *checkBoxOne = [self createCheckBoxWithTitle:@"直线" checked:YES];
        UYUCheckBox *checkBoxTwo = [self createCheckBoxWithTitle:@"曲线" checked:NO];
        UYUCheckBox *checkBoxThree = [self createCheckBoxWithTitle:@"虚线" checked:NO];

        checkBoxOne.frame = CGRectMake(kContentLeft, 0, kContentWith/3.0, kRowHeight);
        checkBoxTwo.frame = CGRectMake(checkBoxOne.right, 0, checkBoxOne.width, kRowHeight);
        checkBoxThree.frame = CGRectMake(checkBoxTwo.right, 0, checkBoxOne.width, kRowHeight);

        [checkBoxOne addTarget:self action:@selector(lineTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [checkBoxTwo addTarget:self action:@selector(lineTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [checkBoxThree addTarget:self action:@selector(lineTypeAction:) forControlEvents:UIControlEventTouchUpInside];

        checkBoxOne.tag = 3001;
        checkBoxTwo.tag = 3002;
        checkBoxThree.tag = 3003;
        
        [_lineTypeView addSubview:titleLab];
        [_lineTypeView addSubview:checkBoxOne];
        [_lineTypeView addSubview:checkBoxTwo];
        [_lineTypeView addSubview:checkBoxThree];
        [_lineTypeView addSubview:[self createLine]];

    }
    return _lineTypeView;
}

- (UIView *)lineCountView{
    if (_lineCountView == nil) {
        _lineCountView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"线的条数"];
        _lineCountTF = [self createTextFieldWithPlaceHoder:@"请输入线的条数" tag:5002];
        
        [_lineCountView addSubview:titleLab];
        [_lineCountView addSubview:_lineCountTF];
        [_lineCountView addSubview:[self createLine]];

    }
    return _lineCountView;
}

- (UIView *)imageCountView{
    if (_imageCountView == nil) {
        _imageCountView = [self createPadView];
        
        UILabel *titleLab = [self createTitleLabelWithTitle:@"线的条数"];
        _imageCountTF = [self createTextFieldWithPlaceHoder:@"请输入图片的个数" tag:5003];
        
        [_imageCountView addSubview:titleLab];
        [_imageCountView addSubview:_imageCountTF];
        [_imageCountView addSubview:[self createLine]];

    }
    return _imageCountView;
}

#pragma mark -
#pragma mark UIInput UIToolBar
- (UIToolbar *)toolBar
{
    
    if (_toolBar == nil) {
        _toolBar = [[ UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, AdaptWidth(30))];
        _toolBar.barStyle = UIBarStyleDefault;
        
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn buttonStyleUseForBarWithTarget:self Title:@"确定" buttonAction:@selector(doneTouched:)];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn buttonStyleUseForBarWithTarget:self Title:@"取消" buttonAction:@selector(cancelTouched:)];
        
        UIBarButtonItem *doneButton   = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
        
        UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        
        UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"选择等级"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:nil
                                                                       action:nil];
        titleButton.tintColor = [UIColor lightGrayColor];
        
        UIBarButtonItem *spaceButton1  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        UIBarButtonItem *spaceButton2  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        
        [_toolBar setItems:@[cancleButton, spaceButton1 ,titleButton, spaceButton2, doneButton]];
    }
    return _toolBar;
    
}

#pragma mark -
#pragma mark UIPickerView
- (UIPickerView *)fontSizePicker{
    if (_fontSizePicker == nil) {
        _fontSizePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, AdaptWidth(256))];
        _fontSizePicker.dataSource = self;
        _fontSizePicker.delegate = self;
        _fontSizePicker.tag = 10001;
    }
    return _fontSizePicker;
}

- (UIPickerView *)eyeGradePicker
{
    if (_eyeGradePicker == nil) {
        _eyeGradePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, AdaptWidth(256))];
        _eyeGradePicker.dataSource = self;
        _eyeGradePicker.delegate = self;
        _eyeGradePicker.tag = 10002;
    }
    return _eyeGradePicker;
}

- (NSArray *)fontSizeArray
{
    if (_fontSizeArray == nil) {
        NSMutableArray *fontSizeArr = [NSMutableArray array];
        for (int i = 1; i < 16; i++) {
            NSString *itemStr = [NSString stringWithFormat:@"%d", i];
            if (i == 1) {
                itemStr = [itemStr stringByAppendingString:@"(最大)"];
            }else if(i == 15){
                itemStr = [itemStr stringByAppendingString:@"(最小)"];
            }
            [fontSizeArr addObject:itemStr];
        }
        _fontSizeArray = fontSizeArr;
    }
    return _fontSizeArray;
}

- (NSArray *)eyeGradeArray
{
    if (_eyeGradeArray == nil) {
        _eyeGradeArray = @[@"(一级)1.50/-1.50", @"(二级)1.50/-2.50", @"(三级)1.50/-3.50", @"(四级)1.50/-4.50", @"(五级)1.50/-6.50", @"(六级)1.50/-8.50"];
    }
    return _eyeGradeArray;
}
#pragma mark -
#pragma mark UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;
    switch (pickerView.tag) {
        case 10001:
        {
            rows = [self.fontSizeArray count];
        }
            break;
        case 10002:
        {
            rows = [self.eyeGradeArray count];
        }
            break;
            
        default:
            break;
    }
    return rows;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *cellLabel = (UILabel *)view;
    if (cellLabel == nil) {
        cellLabel = [[UILabel alloc] init];
        cellLabel.font = [UIFont systemFontOfSize:15];
        cellLabel.textAlignment = NSTextAlignmentCenter;
        cellLabel.textColor = [UIColor blueColor];
        [cellLabel sizeToFit];
    }
    switch (pickerView.tag) {
        case 10001:
        {
            cellLabel.text = self.fontSizeArray[row];
        }
            break;
        case 10002:
        {
            cellLabel.text = self.eyeGradeArray[row];
        }
            break;
            
        default:
            break;
    }
    return cellLabel;
}

#pragma mark -
#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
    
    [self layoutSubviews];
    
    [UYUPresNameMenu shared].delegate = self;
    [UYUPresNameMenu shared].selectType = self.currentPresType;
    
    [self configBaseData];
    
    
    [self.view insertSubview:self.sureButton belowSubview:self.customNavigationView];
    self.sureButton.frame = CGRectMake(15, kScreenHeight - AdaptWidth(60), kScreenWidth - 15*2, AdaptWidth(40));
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyBoard)]];

}

- (void)cancelKeyBoard
{
    [self.view endEditing:YES];
    [[UYUPresNameMenu shared] hiddenPrescriPtion];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.subViewsArray removeAllObjects];
    [[UYUPresNameMenu shared] hiddenPrescriPtion];
}
- (void)addSubviews{

    if ([self.currentPresType isEqualToString:@"stereoscope"]) {
        [self.subViewsArray addObject:self.trainTimesView];
        [self.subViewsArray addObject:self.trainTypeView];
        
        
    }else if([self.currentPresType isEqualToString:@"fractured_ruler"]){
        [self.subViewsArray addObject:self.trainTimesView];
        [self.subViewsArray addObject:self.trainTypeView];
        
    }else if([self.currentPresType isEqualToString:@"reversal"]){
        [self.subViewsArray addObject:self.trainTimesView];
        [self.subViewsArray addObject:self.eyeTypeView];
        [self.subViewsArray addObject:self.leftEyeGradeView];
        [self.subViewsArray addObject:self.rightEyeGradeView];

        
    }else if([self.currentPresType isEqualToString:@"red_green_read"]){
        [self.subViewsArray addObject:self.trainTimesView];
        [self.subViewsArray addObject:self.fontSizeView];
        
    }else if([self.currentPresType isEqualToString:@"approach"]){
        [self.subViewsArray addObject:self.trainTimesView];
        
    }else if([self.currentPresType isEqualToString:@"r_g_variable_vector"]){
        [self.subViewsArray addObject:self.trainTimesView];
        [self.subViewsArray addObject:self.trainTypeView];
        
    }else if([self.currentPresType isEqualToString:@"r_g_fixed_vector"]){
        [self.subViewsArray addObject:self.trainTimesView];
        [self.subViewsArray addObject:self.eyeTypeView];
        
    }else if([self.currentPresType isEqualToString:@"glance"]){
        [self.subViewsArray addObject:self.trainTimesView];
        [self.subViewsArray addObject:self.fontSizeView];
        
    }else if([self.currentPresType isEqualToString:@"follow"]){
        [self.subViewsArray addObject:self.trainTimesView];
        [self.subViewsArray addObject:self.lineTypeView];
        [self.subViewsArray addObject:self.lineCountView];
        [self.subViewsArray addObject:self.imageCountView];
    }

    for (int i = 0; i < [self.subViewsArray count]; i++) {
        [self.view insertSubview:self.subViewsArray[i] belowSubview:self.customNavigationView];
    }
}

- (void)layoutSubviews{
    ((UIView *)self.subViewsArray[0]).frame = CGRectMake(0, 80, kScreenWidth, kRowHeight);
    
    if ([self.subViewsArray count] > 1) {
        for (int i = 1 ; i < [self.subViewsArray count]; i++) {
            ((UIView *)self.subViewsArray[i]).frame = CGRectMake(0, ((UIView *)self.subViewsArray[i-1]).bottom+10, kScreenWidth, kRowHeight);
        }
    }
}

- (void)configBaseData{
    if (self.isAddPrescription == YES) {//添加
        self.letterSize = @"10";
        self.leftEyeLevel = @"1";
        self.rightEyeLevel = @"1";
        
        self.lineType = @"0";
        self.eyeType = @"0";
        self.trainType = @"0";
    }else{//修改
        //训练次数 所有的处方都有
        self.trainTimesTF.text = self.modifyInfoDict[@"repeat_training_times"];
        
        if ([self.currentPresType isEqualToString:@"stereoscope"] ||
            [self.currentPresType isEqualToString:@"fractured_ruler"] ||
            [self.currentPresType isEqualToString:@"r_g_variable_vector"] ||
            [self.currentPresType isEqualToString:@"r_g_fixed_vector"]) {
            
            NSString *trainTypeStr = [self.modifyInfoDict[@"training_type"] description];
            self.trainType = trainTypeStr;
            if([trainTypeStr isEqualToString:@"0"]){
                ((UIButton *)[self.trainTypeView viewWithTag:1000]).selected = YES;
                ((UIButton *)[self.trainTypeView viewWithTag:1001]).selected = NO;
            }else{
                ((UIButton *)[self.trainTypeView viewWithTag:1000]).selected = NO;
                ((UIButton *)[self.trainTypeView viewWithTag:1001]).selected = YES;
            }
            
        }else if([self.currentPresType isEqualToString:@"reversal"]){
            NSString *eyeTypeStr = [self.modifyInfoDict[@"eye_type"] description];
            self.eyeType = eyeTypeStr;
            if ([eyeTypeStr isEqualToString:@"0"]) {
                ((UIButton *)[self.eyeTypeView viewWithTag:2001]).selected = YES;
                ((UIButton *)[self.eyeTypeView viewWithTag:2002]).selected = NO;
            }else{
                ((UIButton *)[self.eyeTypeView viewWithTag:2001]).selected = NO;
                ((UIButton *)[self.eyeTypeView viewWithTag:2002]).selected = YES;
            }
            
            self.leftEyeLevel = [self.modifyInfoDict[@"l_positive_degree_level"] description];
            NSInteger l_level = [[self.modifyInfoDict[@"l_positive_degree_level"] description] integerValue];
            NSInteger l_level_index = l_level - 1 >= 0 ? l_level - 1 : 0;
            self.leftEyeGradeTF.text = self.eyeGradeArray[l_level_index];
            
            self.rightEyeLevel = [self.modifyInfoDict[@"r_positive_degree_level"] description];
            NSInteger r_level = [[self.modifyInfoDict[@"r_positive_degree_level"] description] integerValue];
            NSInteger r_level_index = r_level - 1 >= 0 ? r_level - 1 : 0;
            self.rightEyeGradeTF.text = self.eyeGradeArray[r_level_index];
            
            
        }else if([self.currentPresType isEqualToString:@"red_green_read"] ||
                 [self.currentPresType isEqualToString:@"glance"]){
            NSString *leterSize = [self.modifyInfoDict[@"letter_size"] description];
            self.letterSize = leterSize;
            self.fontSizeTF.text = leterSize;
            
            
        }else if([self.currentPresType isEqualToString:@"approach"]){
            
        }else if([self.currentPresType isEqualToString:@"follow"]){

            NSString *lineType = [self.modifyInfoDict[@"line_type"] description];
            self.lineType = lineType;
            if ([lineType isEqualToString:@"0"]) {
                ((UIButton *)[self.lineTypeView viewWithTag:3001]).selected = YES;
                ((UIButton *)[self.lineTypeView viewWithTag:3002]).selected = NO;
                ((UIButton *)[self.lineTypeView viewWithTag:3003]).selected = NO;

            }else if ([lineType isEqualToString:@"1"]) {
                ((UIButton *)[self.lineTypeView viewWithTag:3001]).selected = NO;
                ((UIButton *)[self.lineTypeView viewWithTag:3002]).selected = YES;
                ((UIButton *)[self.lineTypeView viewWithTag:3003]).selected = NO;
            }else{
                ((UIButton *)[self.lineTypeView viewWithTag:3001]).selected = NO;
                ((UIButton *)[self.lineTypeView viewWithTag:3002]).selected = NO;
                ((UIButton *)[self.lineTypeView viewWithTag:3003]).selected = YES;
            }
            
            self.lineCountTF.text = [self.modifyInfoDict[@"line_count"] description];
            self.imageCountTF.text = [self.modifyInfoDict[@"pic_count"] description];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UYUPresNameMenuDelegate
- (void)selectPrescritionType:(NSString *)type
{
    for (int i = 0; i < [self.subViewsArray count]; i++) {
        [((UIView *)self.subViewsArray[i]) removeFromSuperview];
    }
    [self.subViewsArray removeAllObjects];
    
    self.currentPresType = type;
    
    [self updateMiddelTitle:self.presNamesDict[type]];
    
    [self addSubviews];
    
    [self layoutSubviews];
    
    [self configBaseData];
}

#pragma mark -
#pragma mark UIButton Action
- (void)jiheSankaiAction:(UIButton *)btn{
    UIView *btnPad = [btn superview];
    switch (btn.tag) {
        case 1000:
        {
            btn.selected = YES;
            ((UIButton *)[btnPad viewWithTag:1001]).selected = NO;
            self.trainType = @"0";
        }
            break;
        
        case 1001:
        {
            btn.selected = YES;
            ((UIButton *)[btnPad viewWithTag:1000]).selected = NO;
            self.trainType = @"1";
        }
            break;
        default:
            break;
    }
}

- (void)eyeTypeAction:(UIButton *)btn
{
    UIView *btnPad = [btn superview];
    switch (btn.tag) {
        case 2001:
        {
            btn.selected = YES;
            ((UIButton *)[btnPad viewWithTag:2002]).selected = NO;
            self.eyeType = @"0";
        }
            break;
            
        case 2002:
        {
            btn.selected = YES;
            ((UIButton *)[btnPad viewWithTag:2001]).selected = NO;
            self.eyeType = @"2";
        }
            break;
            
        default:
            break;
    }
}

- (void)lineTypeAction:(UIButton *)btn
{
    UIView *btnPad = [btn superview];
    switch (btn.tag) {
        case 3001:
        {
            btn.selected = YES;
            ((UIButton *)[btnPad viewWithTag:3002]).selected = NO;
            ((UIButton *)[btnPad viewWithTag:3003]).selected = NO;
            self.lineType = @"0";
        }
            break;
        case 3002:
        {
            btn.selected = YES;
            ((UIButton *)[btnPad viewWithTag:3001]).selected = NO;
            ((UIButton *)[btnPad viewWithTag:3003]).selected = NO;
            self.lineType = @"1";
        }
            break;
        case 3003:
        {
            btn.selected = YES;
            ((UIButton *)[btnPad viewWithTag:3001]).selected = NO;
            ((UIButton *)[btnPad viewWithTag:3002]).selected = NO;
            self.lineType = @"2";
        }
            break;
            
        default:
            break;
    }
}


- (void)doneTouched:(UIButton *)btn
{
    if ([self.leftEyeGradeTF isFirstResponder]) {
        
        NSInteger index = [self.eyeGradePicker selectedRowInComponent:0];
        self.leftEyeLevel = [NSString stringWithFormat:@"%ld", index+1];
        self.leftEyeGradeTF.text = self.eyeGradeArray[index];
        
    }else if([self.rightEyeGradeTF isFirstResponder]){
        
        NSInteger index = [self.eyeGradePicker selectedRowInComponent:0];
        self.rightEyeLevel = [NSString stringWithFormat:@"%ld", index+1];
        self.rightEyeGradeTF.text = self.eyeGradeArray[index];
    }else if([self.fontSizeTF isFirstResponder]){
        
        NSInteger index = [self.fontSizePicker selectedRowInComponent:0];
        self.letterSize = [NSString stringWithFormat:@"%ld", index+1];
        self.fontSizeTF.text = self.fontSizeArray[index];
    }
    
    [self.view endEditing:YES];
}

- (void)cancelTouched:(UIButton *)btn
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    [[UYUPresNameMenu shared] hiddenPrescriPtion];
    return YES;
}
- (void)textFieldValueChanged:(UITextField *)tf
{
    NSString *tfText = tf.text;
    switch (tf.tag) {
        case 5001:
        {
            if (tf.text.length > 4) {
                tf.text = [tfText substringWithRange:NSMakeRange(0, 4)];
            }
        }
            break;
        case 5002:
        {
            if (tf.text.length > 4) {
                tf.text = [tfText substringWithRange:NSMakeRange(0, 4)];
            }
        }
            break;
        
        case 5003:
        {
            if (tf.text.length > 4) {
                tf.text = [tfText substringWithRange:NSMakeRange(0, 4)];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)submitAction:(UIButton *)btn
{
    NSDictionary *presTempDict = nil;
    NSString *presId = [self.allPrescriptioonsDict[@"id"] description];
    NSString *times = self.trainTimesTF.text;
    if ([self.currentPresType isEqualToString:@"stereoscope"]) {
        presTempDict = [UYUPresModel stereoscopeWithId:presId
                                                         times:[times integerValue]>0 ? times:@"1"
                                                     trainType:self.trainType];
        

    }else if([self.currentPresType isEqualToString:@"fractured_ruler"]){

        presTempDict = [UYUPresModel fracturedRulerWithId:presId
                                                    times:[times integerValue]>0 ? times:@"1"
                                                trainType:self.trainType];
        
    }else if([self.currentPresType isEqualToString:@"reversal"]){
       
        presTempDict = [UYUPresModel reversalWithId:presId
                                              times:[times integerValue]>0 ? times:@"1"
                                            eyeType:self.eyeType
                                       leftEyeGrade:self.leftEyeLevel
                                      rightEyeGrade:self.rightEyeLevel];
        
        
    }else if([self.currentPresType isEqualToString:@"red_green_read"]){

        presTempDict = [UYUPresModel redGreenRedWithId:presId
                                                 times:times
                                              fontSize:self.letterSize];
        
        
    }else if([self.currentPresType isEqualToString:@"approach"]){
        presTempDict = [UYUPresModel approachWithId:presId
                                              times:[times integerValue]>0 ? times:@"1"];
        
    }else if([self.currentPresType isEqualToString:@"r_g_variable_vector"]){
        presTempDict = [UYUPresModel rgVariableWithId:presId
                                                times:[times integerValue]>0 ? times:@"1"
                                            trainType:self.trainType];
        
    }else if([self.currentPresType isEqualToString:@"r_g_fixed_vector"]){
        presTempDict = [UYUPresModel rgFixedWithId:presId
                                             times:[times integerValue]>0 ? times:@"1"
                                         trainType:self.trainType];
        
    }else if([self.currentPresType isEqualToString:@"glance"]){
        presTempDict = [UYUPresModel glanceWithId:presId
                                            times:[times integerValue]>0 ? times:@"1"
                                         fontSize:self.letterSize];
        
    }else if([self.currentPresType isEqualToString:@"follow"]){
        NSString *lineCount = self.lineCountTF.text;
        NSString *picCount = self.imageCountTF.text;
        
        presTempDict = [UYUPresModel followWithId:presId
                                            times:[times integerValue]>0 ? times:@"1"
                                         lineType:self.lineType
                                        lineCount:[lineCount integerValue]>0 ? lineCount:@"1"
                                         imgCount:[picCount integerValue]>0 ? picCount:@"1"];
    }
    
    NSMutableDictionary *presSubmitDict = [NSMutableDictionary dictionaryWithDictionary:presTempDict];
    
    NSMutableDictionary *presListDict = nil;
    if (![self.allPrescriptioonsDict[@"training_pres_list"] isKindOfClass:[NSMutableDictionary class]]) {
        presListDict = [NSMutableDictionary dictionaryWithDictionary:self.allPrescriptioonsDict[@"training_pres_list"]];
    }else{
        presListDict = self.allPrescriptioonsDict[@"training_pres_list"];
    }
    
    if (self.isAddPrescription == YES) {
        NSString *insertKey = [NSString stringWithFormat:@"%@", presListDict[@"subcount"]];
        [presListDict setValue:presSubmitDict forKey:insertKey];
        presListDict[@"subcount"] = [NSString stringWithFormat:@"%ld", [presListDict[@"subcount"] integerValue] +1];
    }else{
        
        NSString *modifyKey = [NSString stringWithFormat:@"%ld", self.modifyIndex];
        presListDict[modifyKey] = presSubmitDict;
    }

    [SVProgressHUD show];
    
    [[UYUHttpHandler shareInstance] createTrainPresSchemeWithToken:[UYUUserInfo shared].sessionId
                                                         presParam:self.allPrescriptioonsDict
                                                           success:^(NSDictionary *responseDictionary) {
                                                               NSString *code = [responseDictionary[@"code"] description];
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   if ([code isEqualToString:@"0"]) {
                                                                       [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePrescritionTableNotification object:nil];
                                                                       [SVProgressHUD showSuccessWithStatus:@"提交处方成功"];
                                                            
                                                                   }else{
                                                                       [SVProgressHUD showErrorWithStatus:@"提交失败请稍后重试"];
                                                                   }
                                                               });
    } failure:^(NSDictionary *errorDictionary) {
        
    }];
}
@end
