//
//  VKStartScreen.m
//
//  Copyright (c) 2014 VK.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "VKStartScreen.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";
static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"START_WORK";
static NSArray  * SCOPE = nil;
@interface VKStartScreen () <UIAlertViewDelegate>

@end
@implementation VKStartScreen

- (void)viewDidLoad {
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
	[super viewDidLoad];
    
	[VKSdk initializeWithDelegate:self andAppId:@"3974615"];
    if ([VKSdk wakeUpSession])
    {
        [self startWorking];
    }
}
- (void)startWorking {
    [self performSegueWithIdentifier:NEXT_CONTROLLER_SEGUE_ID sender:self];
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)authorize:(id)sender {
	[VKSdk authorize:SCOPE revokeAccess:YES];
}

- (IBAction)authorizeForceOAuth:(id)sender {
	[VKSdk authorize:SCOPE revokeAccess:YES forceOAuth:YES];
}

- (IBAction)authorizeForceOAuthInApp:(id)sender {
	[VKSdk authorize:SCOPE revokeAccess:YES forceOAuth:YES inApp:YES display:VK_DISPLAY_MOBILE];
}
- (IBAction)openShareDialog:(id)sender {
    VKShareDialogController * shareDialog = [VKShareDialogController new];
    shareDialog.text         = @"This post created using #vksdk #ios";
//    shareDialog.vkImages     = @[@"-10889156_348122347",@"7840938_319411365",@"-60479154_333497085"];
    shareDialog.shareLink    = [[VKShareLink alloc] initWithTitle:@"Super puper link, but nobody knows" link:[NSURL URLWithString:@"https://vk.com/dev/ios_sdk"]];
    [shareDialog setCompletionHandler:^(VKShareDialogControllerResult result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:shareDialog animated:YES completion:nil];
}


- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
	VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
	[vc presentIn:self.navigationController.topViewController];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
	[self authorize:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [self startWorking];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
	[self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token {
    [self startWorking];
}
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
	[[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
