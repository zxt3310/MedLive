//
//  MedBaseRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/28.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MedLiveNetManager.h"

NS_ASSUME_NONNULL_BEGIN
@class MedBaseRequest;
typedef void(^MLRequestCompletionBlock)(__kindof MedBaseRequest* request);
@interface MedBaseRequest : NSObject
#pragma mark - Request and Response Information
///=============================================================================
/// @name Request and Response Information
///=============================================================================

///  The underlying NSURLSessionTask.
///
///  @warning This value is actually nil and should not be accessed before the request starts.
@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;

///  Shortcut for `requestTask.currentRequest`.
@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;

///  Shortcut for `requestTask.originalRequest`.
@property (nonatomic, strong, readonly) NSURLRequest *originalRequest;

///  Shortcut for `requestTask.response`.
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;

///  The response status code.
@property (nonatomic, readonly) NSInteger responseStatusCode;

///  The response header fields.
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

///  This serialized response object. The actual type of this object is determined by
///  `YTKResponseSerializerType`. Note this value can be nil if request failed.
///
///  @discussion If `resumableDownloadPath` and DownloadTask is using, this value will
///              be the path to which file is successfully saved (NSURL), or nil if request failed.
@property (nonatomic, strong, readonly, nullable) id responseObject;
///  This error can be either serialization error or network error. If nothing wrong happens
///  this value will be nil.
@property (nonatomic, strong, readonly, nullable) NSError *error;


- (id)requestArgument;
- (NSString *)requestUrl;
- (RequestMethodType)requestMethod;
- (NSDictionary *)requestHeader;
- (BOOL)withBaseUrl;
- (void)startRequestCompletionWithSuccess:(MLRequestCompletionBlock) success failure:(MLRequestCompletionBlock) failure;
//图片专用
- (void)startUploadImage:(UIImage *)image success:(MLRequestCompletionBlock) success failure:(MLRequestCompletionBlock) failure;
//文件
- (void)startUploadFile:(NSURL *)fileUrl Data:(NSData *)fileData FileName:(NSString *)fileName success:(MLRequestCompletionBlock) success failure:(MLRequestCompletionBlock) failure;
//基础错误处理
+ (void)commonFailure:(__kindof MedBaseRequest *)request;
@end

NS_ASSUME_NONNULL_END
