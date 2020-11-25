//
//  MedLiveNetManager.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/27.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveNetManager.h"
#import <AFNetworking.h>

@implementation MedLiveNetManager
{
    AFHTTPSessionManager *afManager;
}
static MedLiveNetManager *manager = nil;
static NSString *BaseUrl = nil;
+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MedLiveNetManager alloc] init];
    });
    return manager;
}

+ (void)setBaseUrl:(NSString *)url{
    BaseUrl = url;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        afManager = [AFHTTPSessionManager manager];
        afManager.requestSerializer = [AFJSONRequestSerializer serializer];
        afManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)settingHeader:(NSDictionary *)header{
    for (NSString *key in header.allKeys) {
        id value = [header valueForKey:key];
        [afManager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

- (void)httpGetRequestWithUrl:(NSString *)url Header:(NSDictionary *)header Success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success Failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError* _Nullable))failure{
    NSString* finalUrl = url;
    if (BaseUrl && BaseUrl.length>0) {
        finalUrl = [BaseUrl stringByAppendingPathComponent:url];
    }
    
    if(header){
        [self settingHeader:header];
    }
   
    [afManager GET:finalUrl
        parameters:nil
          progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)httpPostRequestWithUrl:(NSString *)url Param:(id)param Header:(NSDictionary *)header Success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success Failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError* _Nullable))failure{
    NSString* finalUrl = url;
    if (BaseUrl && BaseUrl.length>0) {
        finalUrl = [BaseUrl stringByAppendingPathComponent:url];
    }
    
    if(header){
        [self settingHeader:header];
    }
    
    [afManager POST:finalUrl
         parameters:param
           progress:nil
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (void)uploadImageWith:(UIImage *)image Url:(NSString *)url Header:(NSDictionary *)header Success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success Failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError* _Nullable))failure{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [self uploadFileWith:imageData FileName:@"image.jpeg" MimeType:@"image/jpeg" Url:url Header:header Success:success Failure:failure];
}


- (void)uploadFileWith:(NSData *)fileData FileName:(NSString*)fileName MimeType:(NSString *)mimeType Url:(NSString *)url Header:(NSDictionary *)header Success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success Failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError* _Nullable))failure{
    NSString* finalUrl = url;
    if (BaseUrl && BaseUrl.length>0) {
        finalUrl = [BaseUrl stringByAppendingPathComponent:url];
    }
    
    if(header){
        [self settingHeader:header];
    }
    
    [afManager POST:finalUrl
              parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
    }           progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    }            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

- (NSString *)getMimeTypeFromUrl:(NSURL *)url{
    __block NSString *mimeType;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        mimeType = response.MIMEType;
        dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return mimeType;
}
@end
