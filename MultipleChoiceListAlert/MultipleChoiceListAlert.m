//
//  MultipleChoiceAlert.m
//  wiseCloudCrm
//
//  Created by panyf on 2017/5/9.
//  Copyright © 2017年 panyf. All rights reserved.
//

#import "MultipleChoiceListAlert.h"

#define kTableAlertWidth 280.0
#define kLateralInset 12.0
#define kVerticalInset 8.0
#define kMinAlertHeight 264.0
#define kCancelButtonHeight 44.0
#define kCancelButtonMargin 5.0
#define kTitleLabelMargin 12.0
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

@interface MultipleChoiceListAlert()

@property (strong, nonatomic) UIView *alertBg;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL cellSelected;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesturRecognizer;

@property (nonatomic, strong) MultipleChoiceAlertNumberOfRowsBlock numberOfRows;

@property (nonatomic, strong) MultipleChoiceAlertTableCellsBlock cells;

- (void)createBackgroundView;

- (void)animateIn;

- (void)animateOut;

- (void)dismissTableAlert;

@end

@implementation MultipleChoiceListAlert

+ (MultipleChoiceListAlert *)tableAlertWithTitle:(NSString *)title numberOfRows:(MultipleChoiceAlertNumberOfRowsBlock)rowsBlock andCells:(MultipleChoiceAlertTableCellsBlock)cellsBlock{

    return [[self alloc] initWithTitle:title numberOfRows:rowsBlock andCells:cellsBlock];

}

- (id)initWithTitle:(NSString *)title numberOfRows:(MultipleChoiceAlertNumberOfRowsBlock)rowsBlock andCells:(MultipleChoiceAlertTableCellsBlock)cellsBlock{

    if (rowsBlock == nil || cellsBlock == nil) {

        [[NSException exceptionWithName:@"rowsBlock and cellsBlock Error" reason:@"These blocks MUST NOT be nil" userInfo:nil] raise];

        return nil;
    }

    self = [super init];

    if (self) {
        _numberOfRows = rowsBlock;
        _cells = cellsBlock;
        _title = title;
        _height = kMinAlertHeight;
    }

    return self;
}

- (void)configureSelectionBlock:(MultipleChoiceAlertRowSelectionBlock)selectionBlock andCompletionBlock:(MultipleChoiceAlertCompletionBlock)completionBlock{

    self.selectionBlock = selectionBlock;

    self.completionBlock = completionBlock;
}

- (void)createBackgroundView{

    self.cellSelected = NO;

    self.frame = [[UIScreen mainScreen] bounds];

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];

    self.opaque = NO;

    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];

    [appWindow addSubview:self];

    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    }];

    self.tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTableAlert)];

    self.tapGesturRecognizer.delegate = self;

    [self addGestureRecognizer:self.tapGesturRecognizer];
}

#pragma mark-手势代理，解决和tableview点击发生的冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    //判断如果点击的是tableView的cell，就把手势给关闭了
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //关闭手势
        return NO;
    }else{
        //否则手势存在
        return YES;
    }
}

- (void)animateIn{

    self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.2 animations:^{
        self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0/7.5 animations:^{
                self.alertBg.transform = CGAffineTransformIdentity;
            }];
        }];
    }];

}

- (void)animateOut{
    [UIView animateWithDuration:1.0/7.5 animations:^{
        self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0/25.0 animations:^{
            self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
                self.alpha = 0.3;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }];
}

- (void)show{
    [self createBackgroundView];

    self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];

    [self addSubview:self.alertBg];

    UIView *bgView = [[UIView alloc] init];

    bgView.layer.masksToBounds = YES;

    bgView.layer.cornerRadius = 6.0;

    [self.alertBg addSubview:bgView];

    // alert of title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    self.titleLabel.backgroundColor = [UIColor colorWithRed:32/255.0 green:154/255.0 blue:253/255.0 alpha:1];

    self.titleLabel.textColor = [UIColor whiteColor];

    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.titleLabel.layer.masksToBounds = YES;

    self.titleLabel.layer.cornerRadius = 6.0;

    self.titleLabel.font = [UIFont systemFontOfSize:17.0];

    self.titleLabel.frame = CGRectMake(0, 0, kTableAlertWidth, 40);

    self.titleLabel.text = self.title;

    [self.alertBg addSubview:self.titleLabel];

    // alert of table
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

    self.table.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 5, kTableAlertWidth, self.numberOfRows(1) * 40 + 10);

    self.table.layer.masksToBounds = YES;

    self.table.layer.cornerRadius = 6.0;

    self.table.delegate = self;

    self.table.dataSource = self;

    self.table.tableFooterView = [[UIView alloc] init];

    self.table.backgroundView = [[UIView alloc] init];

    [self.alertBg addSubview:self.table];

    // frame of alertbg
    self.alertBg.frame = CGRectMake((kDeviceWidth - kTableAlertWidth) / 2, (kDeviceHeight - self.height) / 2 + 10, kTableAlertWidth, self.height - kVerticalInset * 2);

    // frame of bgView
    bgView.frame = CGRectMake(0, 0, kTableAlertWidth, self.titleLabel.frame.size.height + self.table.frame.size.height + 5);

    [self becomeFirstResponder];

    [self animateIn];

}

- (void)dismissTableAlert{
    [self animateOut];

    if (self.completionBlock != nil) {
        if (!self.cellSelected) {
            self.completionBlock();
        }
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)setHeight:(CGFloat)height{
    if (height > kMinAlertHeight) {
        _height = height;
    }else{
        _height = kMinAlertHeight;
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numberOfRows(section);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.cells(self, indexPath);

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.cellSelected = YES;

    [self dismissTableAlert];

    if (self.selectionBlock != nil) {
        self.selectionBlock(indexPath);
    }
}

@end
