//
//  MedLiveNetManager.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/27.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RequestMethodTypeGET,
    RequestMethodTypePOST,
} RequestMethodType;

@interface MedLiveNetManager : NSObject
+ (instancetype)defaultManager;
+ (void)setBaseUrl:(NSString *)url;
- (void)httpGetRequestWithUrl:(NSString *)url WithBase:(BOOL)withBase Header:(NSDictionary *)header Success:(void(^)(NSURLSessionDataTask * _Nonnull , id  _Nullable)) success  Failure:(void(^)(NSURLSessionDataTask * _Nonnull , NSError*  _Nullable)) failure;
- (void)httpPostRequestWithUrl:(NSString *)url WithBase:(BOOL)withBase Param:(id)param Header:(NSDictionary *)header Success:(void(^)(NSURLSessionDataTask * _Nonnull , id  _Nullable)) success  Failure:(void(^)(NSURLSessionDataTask * _Nonnull , NSError*  _Nullable)) failure;

- (void)uploadImageWith:(UIImage *)image Url:(NSString *)url WithBase:(BOOL)withBase Header:(NSDictionary *)header Success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success Failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError* _Nullable))failure;

- (void)uploadFileWith:(NSData *)fileData FileName:(NSString*)fileName MimeType:(NSString *)mimeType Url:(NSString *)url WithBase:(BOOL)withBase Header:(NSDictionary *)header Success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success Failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError* _Nullable))failure;

- (NSString *)getMimeTypeFromUrl:(NSURL*)urlStr;
@end

NS_ASSUME_NONNULL_END
