//
//  CRVGestureDetection.m
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

#import "CRVGestureDetection.h"

#define kAccelerometerFrequency			15.0 // Hz
#define kFilteringFactor				0.1

@interface CRVGestureDetection(PrivateMethods)
- (BOOL) accelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold;
@end


@implementation CRVGestureDetection

@synthesize delegate, lastAcceleration;

- (id) init {
	if((self = [super init])) {
		//Configure and start accelerometer
		[self startDetection];
	}
	return self;
}

- (void) startDetection {
	if(isDetecting) {
		return;
	}
	
	CRVDEBUG(@"CRVGestureDetection#startDetection");
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];	
	isDetecting = YES;
}


- (void) stopDetection {
	CRVDEBUG(@"CRVGestureDetection#stopDetection");
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];	
	isDetecting = NO;
}


- (void) dealloc {
	// setDelegate retains the object that is passed as an argument. We need to deregister!
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];	
	[lastAcceleration release];
	[super dealloc];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if ([self lastAcceleration]) {
        if ([self accelerationIsShakingLast:[self lastAcceleration] current:acceleration threshold:0.7] && shakeCount >= 9) {
			
			if([delegate respondsToSelector:@selector(onShake)]) {
				[delegate onShake];
			}
			
			shakeCount = 0;
        } else if ([self accelerationIsShakingLast:[self lastAcceleration] current:acceleration threshold:0.7]) {
			shakeCount = shakeCount + 5;
        }else if (![self accelerationIsShakingLast:[self lastAcceleration] current:acceleration threshold:0.2]) {
			if (shakeCount > 0) {
				shakeCount--;
			}
        }
    }
	[self setLastAcceleration:acceleration];
}

- (BOOL) accelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold {
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y), 
	deltaZ = fabs(last.z - current.z);
    return (deltaX > threshold && deltaY > threshold) || (deltaX > threshold && deltaZ > threshold) || (deltaY > threshold && deltaZ > threshold);
}

@end
