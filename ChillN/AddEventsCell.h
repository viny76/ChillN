//
//  addEventsCell.h
//  ChillN
//
//  Created by Vincent Jardel on 26/03/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *parallaxImage;
- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;

@end