//
//  SwitchTableViewCell.h
//  Abbvie
//
//  Created by Creatiwity on 20/10/2015.
//  Copyright © 2015 Creatiwity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+CustomColors.h"

@interface SwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

@end
