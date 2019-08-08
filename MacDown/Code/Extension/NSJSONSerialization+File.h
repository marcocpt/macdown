//
//  NSJSONSerialization+File.h
//  MacDown
//
//  Created by Tzu-ping Chung on 15/3.
//  Copyright (c) 2015 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (File)
/// ✅ 获取 url 文件中的对象
+ (id)JSONObjectWithFileAtURL:(NSURL *)url options:(NSJSONReadingOptions)opt
                        error:(NSError *__autoreleasing *)error;

@end
