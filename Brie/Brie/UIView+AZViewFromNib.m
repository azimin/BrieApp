//
//  UIView+AZViewFromNib.m
//  TabBarWithView
//
//  Created by Alex Zimin on 27/07/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

#import "UIView+AZViewFromNib.h"

@implementation UIView (UCViewFromNib)

+ (instancetype)az_viewFromNib
{
  return [[self class] az_viewFromNibWithOwner:nil];
}

+ (instancetype)az_viewFromNibWithOwner:(id)owner
{
  NSString *name = [[NSStringFromClass(self) componentsSeparatedByString:@"."] lastObject];
  typeof([self new]) view = [[[UINib nibWithNibName:name bundle:nil] instantiateWithOwner:owner options:nil] firstObject];

  NSAssert([view isKindOfClass:self], nil);

  return view;
}

- (instancetype)az_loadFromNibIfEmbeddedInDifferentNib
{
  // based on: http://blog.yangmeyer.de/blog/2012/07/09/an-update-on-nested-nib-loading

  BOOL isJustAPlaceholder = self.subviews.count == 0;
  if (isJustAPlaceholder) {
    typeof(self) theRealThing = [[self class] az_viewFromNibWithOwner:nil];

    theRealThing.frame = self.frame;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    theRealThing.translatesAutoresizingMaskIntoConstraints = NO;

    return theRealThing;
  }

  return self;
}

@end
