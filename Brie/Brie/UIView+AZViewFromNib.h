//
//  UIView+AZViewFromNib.h
//  TabBarWithView
//
//  Created by Alex Zimin on 27/07/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (UCViewFromNib)

+ (instancetype)az_viewFromNib;
+ (instancetype)az_viewFromNibWithOwner:(id)owner;
- (instancetype)az_loadFromNibIfEmbeddedInDifferentNib;

@end
