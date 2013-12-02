//
//  NSString+RegularExpressionKit.h
//  Fountain
//
//  Created by Thomas Harte on 01/12/2013.
//  Copyright (c) 2013 Nima Yousefi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*

	This category duplicates as much of the functionality of the old RegExKit as
	Fountain needs, using Apple's NSRegularExpression.

*/

#define RKLCaseless NSRegularExpressionCaseInsensitive

@interface NSString (RegularExpressionKit)

- (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)regex withString:(NSString *)string;

- (BOOL)isMatchedByRegex:(NSString *)regex;
- (BOOL)isMatchedByRegex:(NSString *)regex options:(NSRegularExpressionOptions)options inRange:(NSRange)range error:(NSError *)error;

- (NSString *)stringByMatching:(NSString *)regex capture:(NSInteger)capture;
- (NSString *)stringByMatching:(NSString *)regex options:(NSRegularExpressionOptions)options inRange:(NSRange)range capture:(NSInteger)capture error:(NSError *)error;
- (NSRange)rangeOfRegex:(NSString *)regex;

- (NSArray *)componentsMatchedByRegex:(NSString *)regex capture:(NSInteger)capture;

@end

@interface NSMutableString (RegularExpressionKit)

- (void)replaceOccurrencesOfRegex:(NSString *)regex withString:(NSString *)string;

@end
