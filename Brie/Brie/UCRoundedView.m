//
//  UCRoundedView.m
//  Uberchord
//
//  Created by Alex Zimin on 24/09/15.
//  Copyright © 2015 Uberchord Engineering. All rights reserved.
//

#import "UCRoundedView.h"

@implementation UCRoundedView

- (void)awakeFromNib 
{
  [super awakeFromNib];
  self.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.layer.cornerRadius = self.frame.size.width / 2;
}

@end
