//
//  MedLiveAppUtilies.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/5.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveAppUtilies.h"
#import "MedLiveLoginController.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MedLiveAppUtilies
//提示器

+ (void)load{
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setBackgroundColor:[UIColor ColorWithRGB:0 Green:0 Blue:0 Alpha:0.4]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, kScreenHeight/2-100)];
    [SVProgressHUD setMaximumDismissTimeInterval:2.5];
}

+ (void)showErrorTip:(NSString *) tip{
    [SVProgressHUD showInfoWithStatus:tip];
}

+ (id)stringToJsonDic:(NSString *)jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
      //解析出错
        obj = nil;
        NSLog(@"图片解析出错");
    }
    return obj;
}

+ (void)checkForm:(NSArray <NSString *> *)formAry Aleart:(NSArray <NSString *>*)alearAry Complate:(void(^)(BOOL, NSString * _Nullable))result{
    if (formAry.count != alearAry.count) {
        result(NO,@"参数有误，有nil");
        return;
    }
    __block BOOL res = YES;
    __block NSString *emptyStr = nil;
    [formAry enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        if (KIsBlankString(obj)) {
            emptyStr = alearAry[idx];
            res = NO;
            *stop = YES;
            return;
        }
    }];
    result(res,emptyStr);
}

#pragma 正则匹配手机号
+ (BOOL) checkTelNumber:(NSString *)telNumber
{
    NSString *pattern = @"^[1](([3][0-9])|([4][5-9])|([5][0-3,5-9])|([6][5,6])|([7][0-8])|([8][0-9])|([9][1,8,9]))[0-9]{8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return telNumber && telNumber.length>0 && isMatch;
}

#pragma 正则验证身份证
+ (BOOL) checkUserID:(NSString *)userID
{
    //长度不为18的都排除掉
    if (userID.length!=18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}


+(NSString*) md5HexDigest:(NSString *)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];//%02意思是不足两位将用0补齐，如果多于两位则不影响,小写x表示输出小写，大写X表示输出大写
    }
    return ret;
}

//是否包含中文
+(BOOL) isabc:(NSString *)str{

    NSInteger alength = [str length];

    for (int i = 0; i<alength; i++) {
        
        NSString *temp = [str substringWithRange:NSMakeRange(i,1)];
        
        const char *u8Temp = [temp UTF8String];
        
        if (3==strlen(u8Temp)){
            return YES;
        }
    }
    return NO;
}

+ (BOOL)needLogin{
    AppCommondCenter *center = [AppCommondCenter sharedCenter];
    if (!center.hasLogin) {
        MedLiveLoginController *logVC = [[MedLiveLoginController alloc] init];
        [[self topViewController].navigationController pushViewController:logVC animated:YES];
        return YES;
    }
    return NO;
}

+ (UIViewController *)topViewController {
  UIViewController *resultVC;
  resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
  while (resultVC.presentedViewController) {
    resultVC = [self _topViewController:resultVC.presentedViewController];
  }
   return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
  if ([vc isKindOfClass:[UINavigationController class]]) {
    return [self _topViewController:[(UINavigationController *)vc topViewController]];
  }else if ([vc isKindOfClass:[UITabBarController class]]) {
     return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
  } else {
     return vc;
  }
 return nil;
}

@end

@implementation NSString(ex)

+ (BOOL)isBlankString:(NSString *)str {
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end

