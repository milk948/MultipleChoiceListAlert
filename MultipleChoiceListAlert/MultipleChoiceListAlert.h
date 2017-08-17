//
//  MultipleChoiceAlert.h
//  wiseCloudCrm
//
//  Created by panyf on 2017/5/9.
//  Copyright © 2017年 panyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultipleChoiceListAlert;

typedef void (^MultipleChoiceAlertCompletionBlock)(void);

typedef void (^MultipleChoiceAlertRowSelectionBlock)(NSIndexPath *selectedIndex);

typedef NSInteger (^MultipleChoiceAlertNumberOfRowsBlock)(NSInteger section);

typedef UITableViewCell *(^MultipleChoiceAlertTableCellsBlock)(MultipleChoiceListAlert *alert, NSIndexPath *indexPath);

@interface MultipleChoiceListAlert : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) MultipleChoiceAlertCompletionBlock completionBlock;

@property (nonatomic, strong) MultipleChoiceAlertRowSelectionBlock selectionBlock;

+ (MultipleChoiceListAlert *)tableAlertWithTitle:(NSString *)title numberOfRows:(MultipleChoiceAlertNumberOfRowsBlock)rowsBlock andCells:(MultipleChoiceAlertTableCellsBlock)cellsBlock;

- (id)initWithTitle:(NSString *)title numberOfRows:(MultipleChoiceAlertNumberOfRowsBlock)rowsBlock andCells:(MultipleChoiceAlertTableCellsBlock)cellsBlock;

- (void)configureSelectionBlock:(MultipleChoiceAlertRowSelectionBlock)selectionBlock andCompletionBlock:(MultipleChoiceAlertCompletionBlock)completionBlock;

- (void)show;

@end
