////  LanguageSetViewController.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "LanguageSetViewController.h"

@interface LanguageSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *languageArr;
@property (nonatomic, copy) NSString *language;
@end

@implementation LanguageSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)setlaguageWithString:(NSString *)language {
    [DAConfig setUserLanguage:language];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BaseTabBarController *tab = [[BaseTabBarController alloc] init];
        tab.selectedIndex = 0;
        [BOSTools RestoreRootViewController:tab];
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BOS_H(10) ;
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LanguageSetTableViewCell * cell = [LanguageSetTableViewCell initWithTableView:tableView ID:@"LanguageSetTableViewCell"];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = FONT(14);
    cell.textLabel.textColor = TEXTCOLOR;
    cell.line.hidden = indexPath.row + 1 == self.titleArray.count;
    cell.rightButton.hidden = ![self.language isEqualToString:self.languageArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(50);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        if ([self.language isEqualToString:@"zh-Hans"]) {
            //切换英文
            [self setlaguageWithString:@"en"];
        }
    }else{
        if (![self.language isEqualToString:@"zh-Hans"]) {
            //切换中文
            [self setlaguageWithString:@"zh-Hans"];
        }
    }
}

- (void)createUI {
    self.title = NSLocalizedString(@"语言设置", nil);
    self.language = [DAConfig userLanguage];
    self.view.backgroundColor = COLOR(@"F6F6F9");
    [self.view addSubview:self.tableview];
    WeakSelf(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakSelf.view);
    }];
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"F6F6F9") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:50 superView:nil];
        _tableview.scrollEnabled = NO;
    }
    return _tableview;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"简体中文",@"English"];
    }
    return _titleArray;
}

- (NSArray *)languageArr {
    if (!_languageArr) {
        _languageArr = @[@"zh-Hans",@"en"];
    }
    return _languageArr;
}


@end
