//
//  FMFunctions.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//
#import "FMFunctions.h"
#import "ThemeColor.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD.h"
#import "FMStrings.h"
#import <CommonCrypto/CommonDigest.h>

#define kHUITimeIntervalSecond          1.00
#define kHUITimeIntervalMinute          60.00
#define kHUITimeIntervalHour            3600.00
#define kHUITimeIntervalDay             (3600.00 * 24.00)
#define kHUITimeIntervalYear            (kHUITimeIntervalDay * 365.00)



#pragma mark - JSON
void AddObjectForKeyIntoDictionary(id object, id key, NSMutableDictionary *dic)
{
    if (object == nil || key == nil || dic == nil
        || ![dic isKindOfClass:[NSDictionary class]]
        || ([object isKindOfClass:[NSString class]] && [object isEqualToString:@""])) 
        return;
    
    [dic setObject:object forKey:key];
}

id ObjForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    if (unserializedJSONDic == nil || key == nil || ![unserializedJSONDic isKindOfClass:[NSDictionary class]])
        return nil;
    
    id obj = [unserializedJSONDic objectForKey:key];
    if (obj == [NSNull null])
        return nil;
    else if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""])
        return nil;
    else
        return obj;
}
NSString* StringForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return  [NSString stringWithFormat:@"%@",obj];
}
CGFloat FloatForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  0.0;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj floatValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj floatValue];
    }
    return  0.0;
}
double DoubleForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  0.0;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj doubleValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj doubleValue];
    }
    return  0.0;
}
int IntForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  0;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj intValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj intValue];
    }
    return  0;
}
Boolean BoolForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  NO;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj boolValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj boolValue];
    }
    return  NO;
}

#pragma mark -MD5加密
NSString* EncryptPassword(NSString *str)
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark -判断是否为空
Boolean IsStringEmptyOrNull(NSString * str)
{
    if (!str) {
        // null object
        return true;
    } else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return true;
        } else if([trimedString isEqualToString:@"null"]){
            // is neither empty nor null
            return true;
        }
        else if([trimedString isEqualToString:@"(null)"]){
            // is neither empty nor null
            return true;
        }else {
            return false;
        }
    }
}
extern Boolean IsNormalUserName(NSString *UserName)
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:UserName];
    return B;
    
}
extern Boolean IsNormalIdCard(NSString  *userIdCard)
{
    BOOL flag;
    if (userIdCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:userIdCard];
}

Boolean IsNormalMobileNum(NSString  *userMobileNum){
    if ([userMobileNum length] != 11) {
        return NO;
    }
    NSString *patternStr = [NSString stringWithFormat:@"^(0?1[3578]\\d{9})$|^((0(10|2[1-3]|[3-9]\\d{2}))?[1-9]\\d{6,7})$"];
    NSRegularExpression *regularexpression=[[NSRegularExpression alloc]initWithPattern:patternStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSUInteger numberOfMatch = [regularexpression numberOfMatchesInString:userMobileNum
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, userMobileNum.length)];
    if (numberOfMatch > 0) {
        return YES;
    }
    return NO;

}


void ShowImportErrorAlertView(NSString *errorString){
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:errorString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}


#pragma mark -Image TOOL
UIImage* createImageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

UIColor* colorAddAlpha(UIColor* color,CGFloat alpha)
{
    if (CGColorGetNumberOfComponents([color CGColor]) == 2) {
        const CGFloat *colorComponents = CGColorGetComponents([color CGColor]);
        return [UIColor colorWithRed:colorComponents[0]
                               green:colorComponents[0]
                                blue:colorComponents[0]
                               alpha:alpha];
    }
    else if (CGColorGetNumberOfComponents([color CGColor]) == 4) {
        const CGFloat * colorComponents = CGColorGetComponents([color CGColor]);
        return [UIColor colorWithRed:colorComponents[0]
                               green:colorComponents[1]
                                blue:colorComponents[2]
                               alpha:alpha];
    }
    return color;
}

#pragma mark -dateFormat
NSDateFormatter* dateLocalShortStyleFormatter()
{
    NSDateFormatter *dateFormatter = dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
}

#pragma mark -MBProgressHUD
MBProgressHUD* CreateCustomColorHUDOnView(UIView *onView)
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:onView];
    //hud.color = kColorBorderColorClay;
    //hud.labelColor = kColorTextColorDarkClay;
    return hud;
}

void ShowAutoHideMBProgressHUD(UIView *onView, NSString *labelText)
{
    if (!onView || [labelText length] <= 0)
        return;
    
    MBProgressHUD *hud = CreateCustomColorHUDOnView(onView);
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = labelText;
    hud.completionBlock = nil;
    [hud hide:YES afterDelay:2.0];
    [onView addSubview:hud];
    [hud show:YES];
}

void ShowIMAutoHideMBProgressHUD(UIView *onView, NSString *labelText)
{
    if (!onView || [labelText length] <= 0)
        return;
    
    MBProgressHUD *hud = CreateCustomColorHUDOnView(onView);
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = labelText;
    hud.completionBlock = nil;
    [hud hide:YES afterDelay:1.0];
    [onView addSubview:hud];
    [hud show:YES];
}

void WaittingMBProgressHUD(UIView *onView, NSString *labelText)
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil) {
        hud = CreateCustomColorHUDOnView(onView);
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = labelText;
    hud.completionBlock = nil;
    [onView addSubview:hud];
    [hud show:YES];
}
void SuccessMBProgressHUD(UIView *onView, NSString *labelText)
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil) {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_tips_ok.png"]];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = labelText;
    hud.completionBlock = nil;
    [onView addSubview:hud];
    [onView bringSubviewToFront:hud];
    [hud hide:YES afterDelay:2.0];
}
void FailedMBProgressHUD(UIView *onView, NSString *labelText)
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil) {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_tips_error.png"]];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = labelText;
    hud.completionBlock = nil;
    [onView addSubview:hud];
    [onView bringSubviewToFront:hud];
    [hud hide:YES afterDelay:2.0];
}
void FinishMBProgressHUD(UIView *onView)
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil) {
        return;
    }
    [hud hide:YES];
}
#pragma mark -PullToRefreshView
void UpdateLastRefreshDataForPullToRefreshViewOnView(UIScrollView *view)
{
    if (![view respondsToSelector:@selector(pullToRefreshView)])
        return;
    NSString *lastUpdateString = [NSString stringWithFormat:@"上次更新:%@",
                                  [dateLocalShortStyleFormatter() stringFromDate:[NSDate date]]];
    [view.pullToRefreshView setSubtitle:lastUpdateString forState:SVPullToRefreshStateAll];
}

void ConfiguratePullToRefreshViewAppearanceForScrollView(UIScrollView *view)
{
    if (![view respondsToSelector:@selector(pullToRefreshView)]
        || view.pullToRefreshView == nil)
        return;
    [view.pullToRefreshView setArrowColor:kColorTextColorClay];
    [view.pullToRefreshView setTextColor:kColorTextColorClay];
    [view.pullToRefreshView.subtitleLabel setTextColor:kColorTextColorClay];
    [view.pullToRefreshView setTitle:@"下拉即可刷新..." forState:SVPullToRefreshStateStopped];
    [view.pullToRefreshView setTitle:@"松开即可刷新..." forState:SVPullToRefreshStateTriggered];
    [view.pullToRefreshView setTitle:@"刷新中..." forState:SVPullToRefreshStateLoading];
    UpdateLastRefreshDataForPullToRefreshViewOnView(view);
}

#pragma mark -LoadMoreCell
HUILoadMoreCell* CreateLoadMoreCell()
{
    HUILoadMoreCell *cell = [[HUILoadMoreCell alloc] initWithReuseIdentifier:kHUILoadMoreCellIdentifier];
    cell.textLabel.textAlignment    =  NSTextAlignmentCenter;
    cell.textLabel.textColor        = [UIColor grayColor];//[FMThemeManager.skin textColor];
    cell.textLabel.font             = [UIFont systemFontOfSize:12.0];
    cell.textLabel.text             = LOADMORE_LOADING;
    return cell;
}

NSString* StringFromLV(PLV plv)
{
    static char Byte0[2] = {0};
    char *str = LV_DATA(plv);
    short len = ntohs(plv->len);
    if(len < 1) {
        return nil;
    }
    NSMutableData * strData = [NSMutableData dataWithBytes:str length:len];
    [strData appendBytes:Byte0 length:1];
    return [NSString stringWithUTF8String:[strData bytes]];
}
#pragma mark -时间函数
NSString *timeShortDesc(double localAddTime)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;

    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:localAddTime];
    
    // 年月日获得
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitWeekOfYear)
                        fromDate:timeDate];
    
    NSInteger year0 = [comps year];
    NSInteger day0 = [comps day];
    NSInteger weak0 = [comps weekOfYear];
    
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitWeekOfYear)
                        fromDate:[NSDate date]];
    
    NSInteger year1 = [comps year];
    NSInteger day1 = [comps day];
    NSInteger weak1 = [comps weekOfYear];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    if (year1 > year0)
    {
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        return [dateformatter stringFromDate:timeDate];
    }
    NSUInteger day = day1 - day0;
    if (day == 0)
    {
        [dateformatter setDateFormat:@"HH:mm"];
        return [dateformatter stringFromDate:timeDate];
    }
    
    if (day == 1)
    {
        [dateformatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@",[dateformatter stringFromDate:timeDate]];
    }
    if (day == 2)
    {
        [dateformatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"前天 %@",[dateformatter stringFromDate:timeDate]];
    }
    
    //本周
    if (weak0 == weak1) {
        [dateformatter setDateFormat:@"EEEE HH:mm"];
        return [dateformatter stringFromDate:timeDate];
    }
    
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    return [dateformatter stringFromDate:timeDate];
}

#pragma mark -加偏为火星坐标
static const double EARTH_A = 6378245.0;
static const double EARTH_EE = 0.00669342162296594323;
static double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

static double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}
CLLocationCoordinate2D WGS84toGCJ(CLLocationCoordinate2D coord)
{
    CLLocationCoordinate2D mar;
    double dLat = transformLat(coord.longitude - 105.0, coord.latitude - 35.0);
    double dLon = transformLon(coord.longitude - 105.0, coord.latitude - 35.0);
    double radLat = coord.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - EARTH_EE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((EARTH_A * (1 - EARTH_EE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (EARTH_A / sqrtMagic * cos(radLat) * M_PI);
    mar.latitude = coord.latitude + dLat;
    mar.longitude = coord.longitude + dLon;
    return mar;
}