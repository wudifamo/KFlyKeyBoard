//
//  KFTextField.h
//  KFlyKeyBoard
//
//  Created by kangzq on 16/3/31.
//  Copyright © 2016年 com.kk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFTextField : UIView<UITextFieldDelegate>

- (void)setFrame:(CGRect)frame;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *kTextField;

@end
