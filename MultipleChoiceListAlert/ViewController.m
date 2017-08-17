//
//  ViewController.m
//  MultipleChoiceListAlert
//
//  Created by panyf on 2017/8/17.
//  Copyright © 2017年 panyuanfeng. All rights reserved.
//

#import "ViewController.h"
#import "MultipleChoiceListAlert.h"

@interface ViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) MultipleChoiceListAlert *alert;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];

    [btn setTitle:@"点击弹框" forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)btnClicked{

    self.alert = [MultipleChoiceListAlert tableAlertWithTitle:@"请选择" numberOfRows:^NSInteger(NSInteger section) {
        return 5;
    } andCells:^UITableViewCell *(MultipleChoiceListAlert *alertTab, NSIndexPath *indexPath) {

        static NSString *CellIdentifier = @"CellIdentifier";

        UITableViewCell *cell = [alertTab.table dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];

        cell.textLabel.font = [UIFont systemFontOfSize:15.0];

        cell.textLabel.textAlignment = NSTextAlignmentCenter;

        return cell;
    }];

    self.alert.height = 5 * 40 + 50;

    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"点击了第%ld行",selectedIndex.row] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

        [alertView show];

    } andCompletionBlock:^{

    }];

    [self.alert show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
