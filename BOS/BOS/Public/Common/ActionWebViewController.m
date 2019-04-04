////  ActionWebViewController.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "ActionWebViewController.h"
#import "WKScriptDelegate.h"
#define InjectJS @"var parent = document.getElementsByTagName(\"head\").item(0); var script = document.createElement(\"script\"); script.type = \"text/javascript\";script.innerHTML = window.atob(\"%@\");parent.insertBefore(script,parent.firstChild);"

#define JSSCATTERGetIdentity @"getIdentity"
#define JSSCATTERForgetIdentity @"forgetIdentity"
#define JSSCATTERSignatureProvider @"signatureProvider"
#define JSSCATTERSuggestNetwork @"suggestNetwork"
#define JSSCATTERAuthenticate @"authenticate"
#define JSSCATTERGetPublicKey @"getPublicKey"
#define JSSCGetArbitrarySignature @"getArbitrarySignature"
#define JSSCRequestSignature @"requestSignature"
#define JSSCLinkAccount @"linkAccount"
#define JSSCConnect @"connect"

#define JSSCREJECTCODE @"ScatterJSCode.txt"
@interface ActionWebViewController ()
<
WKUIDelegate,
WKNavigationDelegate,
ScriptMessageHandler
>
@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,strong)UIProgressView * progressView;
@property(nonatomic,strong)UIButton * existButton;
@end
static NSString * const webLoadingProgress = @"estimatedProgress";
static NSString * const webNaviTitle = @"title";
@implementation ActionWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
}

#pragma mark  🐷System Delegate🐷
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
    self.progressView.progress = 0.05;
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.progressView.hidden = YES;
}
-(void)BOSUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"js->oc Params---->%@\n%@",message.name,message.body);
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:webLoadingProgress] && object == self.webView){
        if (self.webView.estimatedProgress > 0.999) {
            self.progressView.hidden = YES;
            self.progressView.progress = 0.0;
        }else{
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        }
    }else if ([keyPath isEqualToString:webNaviTitle]){
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}
#pragma mark  🐷Event  Response🐷
-(void)existButtonAction:(UIButton *)button{
    NSLog(@"已经存在账户");
}
#pragma mark  🐷 Private method 🐷
-(NSString *)InjectJSCode{
    NSString * path = [[NSBundle mainBundle] pathForResource:JSSCREJECTCODE ofType:nil];
    NSError * error ;
    NSString * content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    return content;
}
#pragma mark  🐷Setter and getter🐷
-(void)setUrl:(NSString *)url{
    _url = url;
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:_url]];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
    WeakSelf(weakSelf);
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(weakSelf.view);
    }];
    [self.webView addObserver:self forKeyPath:webLoadingProgress options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:webNaviTitle options:NSKeyValueObservingOptionNew context:nil];
    
}
#pragma mark  🐷Lazy loading🐷
-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.minimumFontSize = 5.0;
        configuration.preferences = preferences;
        configuration.allowsInlineMediaPlayback = YES;
        configuration.allowsPictureInPictureMediaPlayback = YES;
        configuration.suppressesIncrementalRendering = NO;
        configuration.processPool = [[WKProcessPool alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        
        NSString * result = [self InjectJSCode];
        WKUserScript * script = [[WKUserScript alloc]initWithSource:result injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [configuration.userContentController addUserScript:script];
        
        WKScriptDelegate * delelgate = [[WKScriptDelegate alloc]init];
        delelgate.messageHandler = self;
        delelgate.delegate = self;
        
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCATTERGetIdentity];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCATTERForgetIdentity];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCATTERSignatureProvider];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCATTERSuggestNetwork];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCATTERAuthenticate];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCATTERGetPublicKey];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCGetArbitrarySignature];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCRequestSignature];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCLinkAccount];
        [configuration.userContentController addScriptMessageHandler:delelgate name:JSSCConnect];

        _webView =  [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        }
    }
    return _webView;
}
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.7)];
        _progressView.trackTintColor = COLOR(@"e5e5e5");
        _progressView.progressTintColor = SUBJECTCOLOR;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}
-(UIButton *)existButton{
    if (!_existButton) {
        _existButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BOS_W(100), 40)];
        _existButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _existButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_existButton setTitleColor:COLOR(@"FFFFFF") forState:UIControlStateNormal];
        [_existButton addTarget:self action:@selector(existButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_existButton setTitle:NSLocalizedString(@"已有账户", nil) forState:UIControlStateNormal];
    }
    return _existButton;
}
#pragma mark  🐷Init SubViews🐷
-(void)loadDefaultsSetting{
    self.view.backgroundColor = BACKGROUNDCOLOR;
}
-(void)initSubViews{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.existButton];
}
-(void)dealloc{
    
    @try {
        [_webView removeObserver:self forKeyPath:webLoadingProgress];
        [_webView removeObserver:self forKeyPath:webNaviTitle];
    } @catch (NSException *exception) {
        NSLog(@"error -- %@",exception);
    } @finally {}
}
@end
