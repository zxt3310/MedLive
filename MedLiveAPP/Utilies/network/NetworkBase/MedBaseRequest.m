//
//  MedBaseRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/28.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

@implementation MedBaseRequest

- (id)requestArgument{
    return nil;
}

- (NSString *)requestUrl{
    return nil;
}

- (RequestMethodType)requestMethod{
    return RequestMethodTypeGET;
}

- (NSDictionary *)requestHeader{
    return nil;
}

- (void)startRequestCompletionWithSuccess:(MLRequestCompletionBlock) success failure:(MLRequestCompletionBlock) failure{
    NSParameterAssert([self requestUrl]);
    MedLiveNetManager* manager = [MedLiveNetManager defaultManager];
    if ([self requestMethod] == RequestMethodTypeGET) {
        [manager httpGetRequestWithUrl:[self requestUrl]
                                Header:[self requestHeader]
                               Success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            [self loadTask:task res:responseObject error:nil];
            if (responseObject && [[responseObject valueForKey:@"err"] integerValue] != 0) {
                failure(self);
                return;;
            }
            success(self);
        }
                               Failure:^(NSURLSessionDataTask * _Nonnull task, NSError* _Nullable error) {
            [self loadTask:task res:nil error:error];
            
            [MedBaseRequest commonFailure:self];
            
            failure(self);
        }];
    }
    else if([self requestMethod] == RequestMethodTypePOST){
        [manager httpPostRequestWithUrl:[self requestUrl]
                                  Param:[self requestArgument]
                                 Header:[self requestHeader]
                                Success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            [self loadTask:task res:responseObject error:nil];
            if (responseObject && [[responseObject valueForKey:@"err"] integerValue] != 0) {
                [MedBaseRequest commonFailure:self];
                failure(self);
                return;;
            }
            success(self);
         }
                                Failure:^(NSURLSessionDataTask * _Nonnull task, NSError* _Nullable error) {
            [self loadTask:task res:nil error:error];
            
            [MedBaseRequest commonFailure:self];
            
            failure(self);
         }];
    }
}

- (void)startUploadImage:(UIImage *)image success:(MLRequestCompletionBlock) success failure:(MLRequestCompletionBlock) failure{
    NSParameterAssert([self requestUrl]);
    MedLiveNetManager *manager = [MedLiveNetManager defaultManager];
    [manager uploadImageWith:image
                         Url:[self requestUrl]
                      Header:[self requestHeader]
                     Success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [self loadTask:task res:responseObject error:nil];
        if (responseObject && [[responseObject valueForKey:@"err"] integerValue] != 0) {
            [MedBaseRequest commonFailure:self];
            failure(self);
            return;
        }
        success(self);
    } Failure:^(NSURLSessionDataTask * _Nonnull task, NSError* _Nullable error) {
        [self loadTask:task res:nil error:error];
        
        [MedBaseRequest commonFailure:self];
        
        failure(self);
    }];
}

- (void)startUploadFile:(NSURL *)fileUrl Data:(NSData *)fileData FileName:(NSString *)fileName success:(MLRequestCompletionBlock) success failure:(MLRequestCompletionBlock) failure{
    NSParameterAssert([self requestUrl]);
    MedLiveNetManager *manager = [MedLiveNetManager defaultManager];
    NSString *mimeType = [manager getMimeTypeFromUrl:fileUrl];
    
    [manager uploadFileWith:fileData
                   FileName:fileName
                   MimeType:mimeType
                        Url:[self requestUrl]
                     Header:[self requestHeader]
                     Success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [self loadTask:task res:responseObject error:nil];
        if (responseObject && [[responseObject valueForKey:@"err"] integerValue] != 0) {
            [MedBaseRequest commonFailure:self];
            failure(self);
            return;
        }
        success(self);
    } Failure:^(NSURLSessionDataTask * _Nonnull task, NSError* _Nullable error) {
        [self loadTask:task res:nil error:error];
        
        [MedBaseRequest commonFailure:self];
        
        failure(self);
    }];
}

- (void)loadTask:(NSURLSessionDataTask *)task res:(id)responseObj error:(NSError *)error{
    _requestTask = task;
    _currentRequest = task.currentRequest;
    _originalRequest = task.originalRequest;
    _response = (NSHTTPURLResponse *)task.response;
    _responseStatusCode = _response.statusCode;
    _responseHeaders = _response.allHeaderFields;
    _responseObject = responseObj;
    _error = error;
}

+ (void)commonFailure:(__kindof MedBaseRequest *)request{
    NSString *errStr;
    if (request.responseObject) {
        errStr = [request.responseObject valueForKey:@"msg"];
    }else{
        errStr = request.error.description;
    }
    NSLog(@"%@",errStr);
}
@end
