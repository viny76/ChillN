//
//  LabelButtonTableViewCell.m
//  Abbvie
//
//  Created by Creatiwity on 21/10/2015.
//  Copyright © 2015 Creatiwity. All rights reserved.
//

#import "LabelButtonTableViewCell.h"

@implementation LabelButtonTableViewCell

- (void)awakeFromNib {
    [self.cellButton setTitleColor:[UIColor colorLabelAndButtonCell] forState:UIControlStateNormal];
}

@end
