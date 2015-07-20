# SZGWeather
A weather app that imitate Moji.



随笔：
1、To avoid getting the warning:Presenting view controllers on detached view controllers is discouraged , we can directly use :
[self.view.window.rootViewController presentViewController:viewController animated:YES completion:nil]
2、tableView和scrollView手势冲突解决方案：
没滚动就触发不了，要在viewDidAppear方法里，把scrollview的contentSize再设一遍。通过视图给scrollview添加了子视图后，在viewdidload里面设置scrollview的contentsize是不起作用的。 
3、将汉字转换为拼音：
- (NSString *)transformString:(NSString *)sourceString
{
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    [source replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [source length])];
    return source;
}
4、在定位的时候将获取的城市信息由拼音转换为汉字：
在获取地理位置时，根据当前iPhone的默认语言，如为中文，则城市信息为中文，若为英文，则城市信息为英文，所以可以在获取位置之前，将iPhone默认语言强制改为中文，获取以后再将原来的配置信息载入即可。
NSMutableArray *usersDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"zh-hans"] forKey:@"AppleLanguages”];
……获取位置信息
[[NSUserDefaults standardUserDefaults] setObject:usersDefaultLanguages forKey:@"AppleLanguages"];
5、在程序中若想移动某个控件，则可将此控件的某个约束添加至控制器的IBOutLet输出口，动态的修改此约束的属性即可。有时当需隐藏控件时，可对同一属性针对不同控件（父视图或者兄弟视图）都设置约束，将其默认下的约束优先级设为高即可，当想改变控件状态时，动态调整其约束的优先级即可！
