//
//  WebViewController.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(strong,nonatomic)UIProgressView * progress;
@end

@implementation WebViewController
- (void)backAction:(UIButton *)button {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)popView:(UIButton *)button {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreAction:(UIButton *)button {
    
}

- (void)reloadAction:(UIButton *)button {
     [self.webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableArray *leftBtns = [[NSMutableArray alloc] initWithCapacity:2];
//    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn0 setImage:IMAGE(@"icon_back") forState:UIControlStateNormal];
//    [btn0 setFrame:CGRectMake(0, 0, 40, 40)];
//    [btn0 addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithCustomView:btn0];
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setImage:IMAGE(@"icon_home") forState:UIControlStateNormal];
//    [btn1 setFrame:CGRectMake(0, 0, 40, 40)];
//    [btn1 addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
//    [leftBtns addObject:item0];
//    [leftBtns addObject:item1];
//    self.navigationItem.leftBarButtonItems = leftBtns;
//    
//    NSMutableArray *rightBtns = [[NSMutableArray alloc] initWithCapacity:2];
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 setImage:IMAGE(@"price_icon_more_default") forState:UIControlStateNormal];
//    [btn2 setFrame:CGRectMake(0, 0, 40, 40)];
//    [btn2 addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:btn2];
//    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn3 setImage:IMAGE(@"icon_new") forState:UIControlStateNormal];
//    [btn3 setFrame:CGRectMake(0, 0, 40, 40)];
//    [btn3 addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:btn3];
//    [rightBtns addObject:item2];
//    [rightBtns addObject:item3];
//    self.navigationItem.rightBarButtonItems = rightBtns;
    
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.webView];
    
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    //// Date from
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    //// Execute
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        // Done
        
    }];

    if ([self.url hasPrefix:@"http"]) {
        //网络
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else{
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.url]]];
    }
    [self.webView sizeToFit];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

-(UIProgressView *)progress{
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        _progress.trackTintColor = COLOR(@"e5e5e5");
        _progress.progressTintColor = COLOR(@"3acfdf");
        [self.view addSubview:_progress];
    }
    return _progress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载开始");
    self.progress.progress = 0.05;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载成功");

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载失败");
    [self.progress removeFromSuperview];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = BACKGROUNDCOLOR;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
    }
    return _webView;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView){
        if (self.webView.estimatedProgress > 0.999) {
            //从副试图删除
            [self.progress removeFromSuperview];
        }else{
            [self.progress setProgress:self.webView.estimatedProgress animated:YES];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
            self.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}
@end
