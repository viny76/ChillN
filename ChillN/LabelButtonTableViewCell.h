//
//  LabelButtonTableViewCell.h
//  Abbvie
//
//  Created by Creatiwity on 21/10/2015.
//  Copyright © 2015 Creatiwity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+CustomColors.h"
#import "ActionSheetPicker.h"

@interface LabelButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;

@end
