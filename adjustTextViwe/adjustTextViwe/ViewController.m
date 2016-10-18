//
//  ViewController.m
//  adjustTextViwe
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 CYC. All rights reserved.
//

// 做一个类似QQ评论框，自适应高度，做好适配



#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加键盘弹出的通知
    // 注意：应该选即将弹出键盘这个通知，不然修改textview会延迟，效果很差
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyboard:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
}


- (void)showKeyboard:(NSNotification *)notification {

    // 获取键盘位置信息
    CGRect rect = [notification.userInfo[UIKeyboardBoundsUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:.35
                     animations:^{
                         _inputTextView.transform = CGAffineTransformMakeTranslation(0, -rect.size.height);
                     }];

}

- (void)hideKeyboard:(NSNotification *)notification {

    [UIView animateWithDuration:.35
                     animations:^{
                         _inputTextView.transform = CGAffineTransformIdentity;
                     }];

}

- (void)textViewDidChange:(UITextView *)textView {

//    NSLog(@"%ld", textView.text.length);
//    NSLog(@"%@", textView.text);
    
    
    static float maxHeight = 100.0f;
    CGRect frame = textView.frame;
    CGSize contentSize = CGSizeMake(frame.size.width, MAXFLOAT);
    
    // 根据做给的size来确定当前textview所占的size
    CGSize size = [textView sizeThatFits:contentSize];
    
    // 没必要调整textview的情况
    if (size.height <= frame.size.height) {
        size.height = frame.size.height;
    } else {
    
        //保障textview的最大高度
        if (size.height > maxHeight) {
            size.height = maxHeight;
        }
    
    }
    
    // 重新指定textview的高度和位置
    textView.frame = CGRectMake(frame.origin.x,
                                frame.origin.y - (fabs(size.height - frame.size.height)),
                                frame.size.width,
                                size.height);
    
}


// 使得输入return时没有任何效果
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        
        // 隐藏键盘
        [_inputTextView resignFirstResponder];
        return NO;
    }
    
    NSLog(@"%@", NSStringFromRange(range));
    
    
    return YES;

}






























@end
