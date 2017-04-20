//
//  UYUTabBarController.m
//  UYUClient
//
//  Created by mac on 17/3/14.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUTabBarController.h"
#import "UYUWebViewController.h"
#import "UYUColor.h"
#import "AppConfig.h"
#import "UYUUserHistoryViewController.h"
#import "UYUCreateViewController.h"


@interface UYUTabBarController ()<UITabBarDelegate>

@end

@implementation UYUTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabViewController];
    
    
    // **** image
    for (UITabBarItem *item in self.tabBar.items) {
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    // **** title
    NSDictionary *dicSelected = @{NSForegroundColorAttributeName : [UYUColor uyuGreenColor]};
    NSDictionary *dicNormal = @{NSForegroundColorAttributeName : [UYUColor aluminiumColor]};
    [[UITabBarItem appearance] setTitleTextAttributes:dicSelected forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:dicNormal forState:UIControlStateNormal];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [UITabBar appearance].shadowImage = [UIImage new];
    [UITabBar appearance].backgroundImage = [[UIImage alloc] init];
    
    [self dropShadowWithOffset:CGSizeMake(0, -2) radius:8 color:[UIColor blackColor] opacity:0.15];
}

- (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    self.tabBar.clipsToBounds = NO;
}

- (void)setupTabViewController {
    NSArray *arrTitle = @[@"我的", @"视光师", @"设备", @"用户"];
    NSArray *arrImageNormal = @[@"ic_tab_mine", @"ic_tab_eyesight", @"ic_tab_dev", @"ic_tab_train"];
    NSArray *arrImageGray = @[@"ic_tab_mine_light", @"ic_tab_eyesight_light", @"ic_tab_dev_light", @"ic_tab_train_light"];
    NSArray *arrUrl = @[mineUrl, eyesightUrl, deviceUrl, billsUrl];
    NSMutableArray *arrVCs = [[NSMutableArray alloc] init];
    for (int i=0; i<arrTitle.count; i++) {
        NSString *urlString = [kCDBaseUrl stringByAppendingString:arrUrl[i]];
        UIViewController *itemVC = nil;
        switch (i) {
            case 0:
            {
                UYUWebViewController *perVC = [[UYUWebViewController alloc] initWithUrlString:urlString];
                perVC.canPullDownRefresh = YES;
                perVC.canPullUpRefresh = NO;
                itemVC = perVC;
            }
                break;
            case 1:
            {
                UYUWebViewController *perVC = [[UYUWebViewController alloc] initWithUrlString:urlString];
                perVC.canPullDownRefresh = YES;
                perVC.canPullUpRefresh = YES;
                itemVC = perVC;
            }
                break;
            case 2:
            {
                UYUWebViewController *perVC = [[UYUWebViewController alloc] initWithUrlString:urlString];
                perVC.canPullDownRefresh = YES;
                perVC.canPullUpRefresh = YES;
                itemVC = perVC;
            }
                break;
            case 3:
            {
                UYUUserHistoryViewController *vc = [[UYUUserHistoryViewController alloc] init];
                __weak UYUUserHistoryViewController *weadUser = vc;
                
                [vc setMiddleNaviWithTitle:@"客户"];
                [vc setRightNaviItemWithTitle:@"新建客户" image:nil action:^(UIButton *obj) {
                    UYUCreateViewController *addUser = [[UYUCreateViewController alloc] init];
                    [addUser setMiddleNaviWithTitle:@"新建客户"];

                    [addUser setLeftNaviItemAction:^(UIButton *obj) {
                        [weadUser.navigationController popViewControllerAnimated:YES];
                    }];
                    addUser.hidesBottomBarWhenPushed = YES;
                    [weadUser.navigationController pushViewController:addUser animated:YES];
                }];
                itemVC = vc;
            }
                break;
                
            default:
                break;
        }
        UINavigationController *navController = [self getPerTabBarNavigationWithVC:itemVC
                                                                       normalImage:arrImageNormal[i]
                                                                       selectImage:arrImageGray[i]
                                                                             title:arrTitle[i]];
        
        [arrVCs addObject:navController];
    }
    
    [self setViewControllers:arrVCs];
}


- (UINavigationController *)getPerTabBarNavigationWithVC:(UIViewController *)perVC normalImage:(NSString *)strNormalImage selectImage:(NSString *)strSelectImage title:(NSString *)strTitle {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:perVC];
    
    UIImage *normalImage = [UIImage imageNamed:strNormalImage];
    UIImage *selectImage = [UIImage imageNamed:strSelectImage];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:strTitle image:normalImage selectedImage:selectImage];
    
    [navController setTabBarItem:barItem];
    
    return navController;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}
@end
