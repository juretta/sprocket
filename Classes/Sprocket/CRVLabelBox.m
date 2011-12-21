//
//  CRVLabelBox.m
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

#import "CRVLabelBox.h"


@interface CRVLabelBox()
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, assign) float radius;
@end


@implementation CRVLabelBox

@synthesize label, badgeColor;
@synthesize radius;

-(id) initWithFrame:(CGRect)frame {
	CRVDEBUG(@"CRVLabelBox#initWithFrame");
    if (self = [super initWithFrame:frame]) {
		style = CRVLabelStyleDefault;
		[self setRadius: 5.0f];
        // Initialization code
		// the view
		[self setOpaque:YES];
		[self setBackgroundColor:[UIColor whiteColor]];

		// The text
		UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
		UIColor *whiteColor = [UIColor whiteColor];
		[lbl setTextColor:whiteColor];
		[lbl setBackgroundColor:[UIColor clearColor]];
		lbl.adjustsFontSizeToFitWidth = NO;
		lbl.highlightedTextColor = whiteColor;
		lbl.numberOfLines = 1;
		lbl.textAlignment = UITextAlignmentRight;
		[self setLabel: lbl];
		[lbl release];
		[self addSubview:lbl];
    }
    return self;
}

-(id) initWithStyle:(CRVLabelStyle) theStyle {
	if(self = [self initWithFrame:CGRectZero]) {
		switch (theStyle) {
			case CRVLabelStyleEmailBadge:
				self.radius = 10.0;
				break;
			default:
				break;
		}
		style = theStyle;
	}
	return self;
}


-(void) setText:(NSString *) theText {
	[[self label] setText:theText];
}

-(void) setTextColor:(UIColor *) theColor {
	[[self label] setTextColor:theColor];
}

-(void) setFont:(UIFont *) theFont {
	[[self label] setFont:theFont];
}

-(void) fillRoundedRect:(CGRect)rect inContext:(CGContextRef)context {   
	float r = [self radius];
    CGContextBeginPath(context);
	if([self badgeColor]) {
		CGContextSetFillColorWithColor(context, [[self badgeColor] CGColor]);
	} else {
		CGContextSetGrayFillColor(context, 0.3, 0.75);
	}
	CGContextMoveToPoint(context, CGRectGetMinX(rect) + r, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - r, CGRectGetMinY(rect) + r, r, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - r, CGRectGetMaxY(rect) - r, r, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + r, CGRectGetMaxY(rect) - r, r, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + r, CGRectGetMinY(rect) + r, r, M_PI, 3 * M_PI / 2, 0);
	
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)drawRect:(CGRect)rect {
	NSString *text = [[self label] text];
	if(!text || [@"" isEqual:text]) {
		return;
	}
	
	// draw a box with rounded corners to fill the view
    CGContextRef ctxt = UIGraphicsGetCurrentContext();	
	// Rect for text
	CGSize rectSize = [text sizeWithFont: [[self label] font]];
	CGFloat x = self.bounds.size.width - rectSize.width - 12.;
	
	// The rounded corner box
	CGRect boxRect;
	CGRect labelRect;
	switch (style) {
		case CRVLabelStyleEmailBadge:
		{
			boxRect = CGRectMake(x-12.0, 0, rectSize.width + 24., rectSize.height + 4.);
			labelRect = CGRectMake(x, 2., rectSize.width, rectSize.height);
		}
			break;
		default:
		{
			boxRect = CGRectMake(x, 0, rectSize.width + 12., rectSize.height + 4.);
			labelRect = CGRectMake(6. + x, 2., rectSize.width, rectSize.height);			
		}
			break;
	}
	[[self label] setFrame:labelRect];
	boxRect = CGRectInset(boxRect, 1.0f, 1.0f);
    [self fillRoundedRect:boxRect inContext:ctxt];
}

- (void)dealloc {
	CRV_RELEASE_SAFELY(badgeColor);
	CRV_RELEASE_SAFELY(label);
    [super dealloc];
}


@end
