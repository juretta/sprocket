//
//  CRVActivityView.h
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

#import <UIKit/UIKit.h>

@protocol CRVActivityViewDelegate<NSObject>
@optional
-(void) userDidCancelActivity;
@end

@interface CRVActivityView : UIView {
	@private
	UIActivityIndicatorView *activityIndicator;
	UILabel *label;
	id<CRVActivityViewDelegate> delegate;
	UIView *overlay;
}

@property(nonatomic, assign) id<CRVActivityViewDelegate> delegate;

+ (CRVActivityView *) newDefaultViewForParentView:(UIView *) parentView;

+ (CRVActivityView *) newDefaultViewForParentView:(UIView *) parentView center:(CGPoint) center;

- (void) startAnimating;
- (void) stopAnimating;
- (void) setText:(NSString *) theText;

@end