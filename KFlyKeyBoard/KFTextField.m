//
//  KFTextField.m
//  KFlyKeyBoard
//
//  Created by kangzq on 16/3/31.
//  Copyright © 2016年 com.kk. All rights reserved.
//

#import "KFTextField.h"

@implementation KFTextField
{
    
    NSMutableArray *ulbs;
    UILabel *ulb;
    CGPoint tcg;
}

- (void)awakeFromNib
{
    ulbs=[[NSMutableArray alloc]init];
    [[NSBundle mainBundle] loadNibNamed:@"KFTextField" owner:self options:nil];
    [self addSubview:self.contentView];
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rect = frame;
    tcg=CGPointMake(frame.origin.x, frame.origin.y);
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    self.contentView.frame = rect;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    CGFloat cWidth=self.contentView.frame.size.width-60;
    CGFloat toX=[self getRandomNumber:tcg.x to:tcg.x+cWidth];

    CGSize titleSize = [textField.text sizeWithAttributes:@{NSFontAttributeName : textField.font}];
    float  f1 = 1.00;
    CGFloat ff=range.location;
    if(textField.text.length>0){
        f1=ff/textField.text.length;
    }
    CGFloat showWidth = tcg.x+(titleSize.width+5)*f1;
    if(showWidth>tcg.x+self.frame.size.width-30){
        showWidth=tcg.x+self.frame.size.width-30;
    }
    if ([string isEqualToString:@""] && range.length > 0) {
        //删除
        ulb=[[UILabel alloc]initWithFrame:CGRectMake(showWidth, tcg.y+15, 20, 20)];
        ulb.text=[textField.text substringWithRange:range];
        ulb.textColor=[UIColor whiteColor];
        ulb.adjustsFontSizeToFitWidth=YES;
        [self.superview addSubview:ulb];
        //1.创建核心动画
        CABasicAnimation *anima=[CABasicAnimation animationWithKeyPath:@"position"];
        //设置通过动画，将layer从哪儿移动到哪儿
        anima.fromValue=[NSValue valueWithCGRect:ulb.frame];
        anima.toValue=[NSValue valueWithCGRect:CGRectMake(showWidth,self.superview.frame.size.height+100,400,400)];
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
        //组合动画
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.removedOnCompletion=NO;
        animationGroup.duration=0.4f;
        animationGroup.delegate=self;
        animationGroup.fillMode=kCAFillModeForwards;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animationGroup setAnimations:[NSArray arrayWithObjects:anima, scaleAnimation, nil]];
        [ulb.layer addAnimation:animationGroup forKey:@"l"];
        [ulbs addObject:ulb];
    }else{
        ulb=[[UILabel alloc]initWithFrame:CGRectMake(showWidth, self.superview.frame.size.height+100, 20, 20)];
        ulb.text=string;
        ulb.textColor=[UIColor whiteColor];
        ulb.adjustsFontSizeToFitWidth=YES;
        [self.superview addSubview:ulb];
        //1.创建核心动画
        CABasicAnimation *anima=[CABasicAnimation animationWithKeyPath:@"position"];
        anima.fromValue=[NSValue valueWithCGPoint:ulb.frame.origin];
        anima.toValue=[NSValue valueWithCGPoint:CGPointMake(toX, tcg.y+15)];
        
        //缩放动画
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
        //组合动画
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
         animationGroup.removedOnCompletion=NO;
        animationGroup.duration=0.4f;
        animationGroup.delegate=self;
        animationGroup.fillMode=kCAFillModeBackwards;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animationGroup setAnimations:[NSArray arrayWithObjects:anima, scaleAnimation, nil]];
        [ulb.layer addAnimation:animationGroup forKey:@"l"];
        [ulbs addObject:ulb];
       
    }

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for(UILabel *ub in ulbs){
        if(ub!=nil){
            [ub removeFromSuperview];
        }
    }
    [ulbs removeAllObjects];
    [textField resignFirstResponder];
    return YES;
}

/**
 * 动画开始时
 */
- (void)animationDidStart:(CAAnimation *)theAnimation
{
   
}

/**
 * 动画结束时
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSArray *ublsa=[NSArray arrayWithArray:ulbs];
    for(UILabel *ub in ublsa){
        if([ub.layer animationForKey:@"l"]==theAnimation){
            [ub removeFromSuperview];
            [ulbs removeObject:ub];
        }
    }
}
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
@end
