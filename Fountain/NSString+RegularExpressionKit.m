//
//  NSString+RegularExpressionKit.m
//  Fountain
//
//  Created by Thomas Harte on 01/12/2013.
//  Copyright (c) 2013 Nima Yousefi. All rights reserved.
//

#import "NSString+RegularExpressionKit.h"

@implementation NSString (RegularExpressionKit)

+ (NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern
{
	@synchronized(self)
	{
		// create a cache for NSRegularExpressions if we don't have one
		static NSCache *expressionCache = nil;
		if(!expressionCache)
			expressionCache = [[NSCache alloc] init];

		// if there's already an expression in the cache, return it
		NSRegularExpression *expression = [expressionCache objectForKey:pattern];
		if(expression) return expression;

		// make a new expression, and if that fails return nil
		expression = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
		if(!expression) return nil;

		// put the expression into the cache and then return it
		[expressionCache setObject:expression forKey:pattern];
		return expression;
	}
}

/*
	Most of these involve trivially passing the request on to NSRegularExpression...
*/
- (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)regex withString:(NSString *)string
{
	NSRegularExpression *expression = [[self class] regularExpressionWithPattern:regex];
	return [expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:string];
}

- (BOOL)isMatchedByRegex:(NSString *)regex
{
	NSRegularExpression *expression = [[self class] regularExpressionWithPattern:regex];
	return !![expression firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
}

- (BOOL)isMatchedByRegex:(NSString *)regex options:(NSRegularExpressionOptions)options inRange:(NSRange)range error:(NSError *)error
{
	NSRegularExpression *expression = [[self class] regularExpressionWithPattern:regex];
	return !![expression firstMatchInString:self options:options range:range];
}

- (NSRange)rangeOfRegex:(NSString *)regex
{
	NSRegularExpression *expression = [[self class] regularExpressionWithPattern:regex];
	return [expression firstMatchInString:self options:0 range:NSMakeRange(0, self.length)].range;
}

/*
	For these two, obey the capture parameter by inspecting NSTextCheckingResult's
	list of captured ranges
*/
- (NSString *)stringByMatching:(NSString *)regex capture:(NSInteger)capture
{
	NSRegularExpression *expression = [[self class] regularExpressionWithPattern:regex];
	NSTextCheckingResult *result = [expression firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];

	if([result numberOfRanges] <= capture) return nil;
	return [self substringWithRange:[result rangeAtIndex:capture]];
}

- (NSString *)stringByMatching:(NSString *)regex options:(NSRegularExpressionOptions)options inRange:(NSRange)range capture:(NSInteger)capture error:(NSError *)error
{
	NSRegularExpression *expression = [[self class] regularExpressionWithPattern:regex];
	NSTextCheckingResult *result = [expression firstMatchInString:self options:options range:range];

	if([result numberOfRanges] <= capture) return nil;
	return [self substringWithRange:[result rangeAtIndex:capture]];
}

/*
	To get matching components, enumerate all matches
*/
- (NSArray *)componentsMatchedByRegex:(NSString *)regex capture:(NSInteger)capture
{
	NSRegularExpression *expression = [[self class] regularExpressionWithPattern:regex];

	NSMutableArray *components = [NSMutableArray array];

	[expression
		enumerateMatchesInString:self
		options:0
		range:NSMakeRange(0, self.length)
		usingBlock:
			^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
			{
				[components addObject:[self substringWithRange:result.range]];
			}];

	return components;
}

@end

@implementation NSMutableString (RegularExpressionKit)

/*
	Another one we can just pass along
*/
- (void)replaceOccurrencesOfRegex:(NSString *)regex withString:(NSString *)string
{
	NSRegularExpression *expression = [[self class] regularExpressionWithPattern:regex];
	[expression replaceMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:string];
}

@end
