//
//  detailEventCellTableViewCell.m
//  ChillN
//
//  Created by Vincent Jardel on 06/06/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import "EventDetailCell.h"

@implementation EventDetailCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end