//
//  HomeCell.m
//  ChillN
//
//  Created by Vincent Jardel on 26/03/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    //    self.cellView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    //    self.cellView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    //    self.cellView.opaque = NO;
    //    self.cellView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    //    UIImage *bg     =   SomeImage();
    //    UIColor *bgc    =   [UIColor colorWithPatternImage:bg alfa:0.5];
    //    [self setBackgroundColor:bgc];
    [self.background setImage:[UIImage imageNamed:@"background"]];
    self.background.opaque = NO;
    [self.background setAlpha:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view {
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.background.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.background.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.background.frame = imageRect;
}

@end
