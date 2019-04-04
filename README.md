# BOS ToolKit

### 项目介绍
BOS 工具箱


### 第三方APP通过本工具箱调起账户

**示例：**

>调用

```objectivec
    NSDictionary * dict = @{
                            @"blockchain" : @"eosio",
                            @"appName" : 第三方app名称
                            @"callback" :  @"第三方scheme://",
                            @"action" : @"getAccount",
                            @"param" : @{}
                            };
    NSString * paramstr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",@"bostool://bos?param=",paramstr];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL * url = [NSURL URLWithString: urlString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {

            }];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
```

>结果


```objective
    {
        action = getAccount;
        data =     {
            keys = 5Jxxxxxxxxxxxxx;//私钥
        };
    }

```
