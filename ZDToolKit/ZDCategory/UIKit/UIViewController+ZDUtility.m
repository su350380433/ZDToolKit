//
//  UIViewController+ZDUtility.m
//  ZDUtility
//
//  Created by 符现超 on 16/1/16.
//  Copyright © 2016年 Zero.D.Saber. All rights reserved.
//

#import "UIViewController+ZDUtility.h"


@implementation UIViewController (ZDUtility)

- (BOOL)isSupport3DTouch {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        return YES;
    }
    return NO;
}

- (BOOL)isComefromPresent {
    BOOL isPresent = (self.presentationController != nil);
    return isPresent;
}

- (void)popOrDismiss {
    if (self.presentationController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)presentModalBuyItemVCWithId:(NSString *)itemId animated:(BOOL)animated {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        SKStoreProductViewController *skvc = [[SKStoreProductViewController alloc] init];
        skvc.delegate = self;
        [skvc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : itemId} completionBlock:^(BOOL result, NSError *error){
            if (!result || error) {
                [skvc dismissViewControllerAnimated:YES completion:nil];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", itemId]]];
            }
        }];
        [self presentViewController:skvc animated:YES completion:nil];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", itemId]]];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

// reference: http://stackoverflow.com/questions/19140530/toplayoutguide-in-child-view-controller
- (id<UILayoutSupport>)zd_navigationBarTopLayoutGuide {
    if (self.parentViewController && ![self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return self.parentViewController.zd_navigationBarTopLayoutGuide;
    }
    else {
        return self.topLayoutGuide;
    }
}

- (id<UILayoutSupport>)zd_navigationBarBottomLayoutGuide {
    if (self.parentViewController && ![self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return self.parentViewController.zd_navigationBarBottomLayoutGuide;
    }
    else {
        return self.topLayoutGuide;
    }
}

@end
