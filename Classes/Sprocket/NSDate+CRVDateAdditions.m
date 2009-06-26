//
//  NSDate+CRVDateAdditions.m
//
//
// Copyright (c) 2009 Stefan Saasen
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#import "NSDate+CRVDateAdditions.h"


@implementation NSDate(CRVDateAdditions)

-(NSString *) humanReadable {
	NSArray *periods = [[NSArray alloc] initWithObjects: 
						@"second", @"minute", @"hour", @"day", @"week", @"month", @"year", @"decade", nil];
	NSUInteger lengths[] = {60, 60, 24, 7, 4.35, 12, 10};
	NSString *tense = @"";
	NSTimeInterval interval;
	NSDate *currentDate = [NSDate date];
	if([currentDate isEqualToDate:[currentDate laterDate:self]]) {
		interval = [currentDate timeIntervalSinceDate:self];
		tense  = @"ago";
	} else {
		interval = [self timeIntervalSinceDate:currentDate];
		tense  = @"from now";
	}
	int i;
	for(int j = 0; interval >= lengths[j] && j < sizeof(lengths); j++) {
		interval = interval/lengths[j];
		i = j;
	}
	interval = (int) round(interval);
	NSString *period = [periods objectAtIndex:(i+1)];
	if(interval != 1) {
		period = [period stringByAppendingFormat:@"s"];
	}
	[periods release];
	return [NSString stringWithFormat: @"%d %@ %@", (int)interval, period, tense];
}

@end
