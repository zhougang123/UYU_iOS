//
//  Macro.h
//  FengMi
//
//  Created by Connor on 3/11/15.
//  Copyright (c) 2015 FengMi. All rights reserved.
//

#ifndef FengMi_Macro_h
#define FengMi_Macro_h



//Color
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBLOG(RGBValue) NSLog(@"%f %f %f",((float)((RGBValue & 0xFF0000) >> 16)),((float)((RGBValue & 0xFF00) >> 8)),((float)(RGBValue & 0xFF)))
//Red
#define kColorRed     UIColorFromRGB(0xfd5359)
//Black
#define kColorBlack   UIColorFromRGB(0x2f323a)
//Gray
#define kColorGray   UIColorFromRGB(0xa7a9ae)
//MidGray
#define kColorMidGray  UIColorFromRGB(0xc2c2c2)
//MidBlack
#define kColorMidBlack  UIColorFromRGB(0x4E5057)
//Primary BG
#define kColorPrimaryBg UIColorFromRGB(0xefefef)
//Aluminum
#define kColorAluminium UIColorFromRGB(0x8a8c92)
//div
#define kColorDiv UIColorFromRGB(0xE5E5E5)

//div
#define kColorCellGray UIColorFromRGB(0xf5f5f5)


#pragma mark -
#pragma mark - Devices functions

#define iOS8_OR_HIGHER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define iOS9_OR_HIGHER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)
#define iOS10_OR_HIGHER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

#define isQPOSUser !IS_NULL_STRING([QFUser shared].session)

#define isIPadNotAdapt kScreenWidth/kScreenHeight == 320.0f/480.0f || kScreenWidth/kScreenHeight == 320.0/480.0

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kStatusBarHeight 20.0f
#define kNavigationBarHeight 44.0f

#define kLeftSpaceWidth 13.f

#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#pragma mark -
#pragma mark Common Define


#define AppVersionShort [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppVersionBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppVersion      [NSString stringWithFormat:@"%@.%@",AppVersionShort,AppVersionBuild]

#define Device  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?@"iPad":@"iPhone"

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

#define ImageFromRAM(_pointer) [UIImage imageNamed:_pointer]
#define ImageFromFile(_pointer) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:_pointer ofType:nil]]


#define GCDBACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCDMAIN(block) dispatch_async(dispatch_get_main_queue(),block)
#define GCDAFTER(time,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time) * NSEC_PER_SEC)), dispatch_get_main_queue(),(block))


#define KXHGridItemWidth (145.0 * 1)

#define kXHLargeGridItemPadding 10

#define kXHScreen [[UIScreen mainScreen] bounds]
#define kXHScreenWidth CGRectGetWidth(kXHScreen)

#define XH_CELL_IDENTIFIER @"XHWaterfallCell"

#define XH_CELL_COUNT 12


// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// iPad
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// image STRETCH
#define XH_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

//Documents Path
#define DOCUMENTSPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//kit width 以5s为基准
#define AdaptWidth(__width) (__width/320.f)*kScreenWidth
#define AdaptHeight(__height) (__height/568.f)*kScreenHeight

//kit width 以6为基准
#define AdaptWidth6Standard(__width) (__width/375.f)*kScreenWidth
#define AdaptHeight6Standard(__height) (__height/667.f)*kScreenHeight//iphone4的文字等可以按比例来
#define AdaptHeight6StandardNot4(__height) (__height/667.f)*(kScreenHeight<568 ? 568 : kScreenHeight)//iphone4的cell高度等以5为标准

#define kScreenWidth_scale  kScreenWidth/320
#define kScreenHeight_scale kScreenHeight>568 ? kScreenHeight/568 : 1


#define DIV_LINE_HEIGHT 0.5

//轮询时间间隔
#define SEARCH_LOOP_TIME 2.0

#define IMPORTANTINFO_SPEED  0.02   // 重大通知文字移动速度

#define kCommonCornerRadius   3.0f   // 圆角

#endif
