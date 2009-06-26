//
//  CRVLoadingTableCell.h
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

#import "CRVLoadingTableCell.h"

//#define DEBUG_CELL

@implementation CRVLoadingTableCell

@synthesize activity;

+(CGFloat) defaultRowHeight {
	return 60.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	// We use UITableViewCellStyleSubtitle and adjust the text and detail text labels.
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		
		self.textLabel.text = @"Loading..."; // TODO i18n
				
		[self addSubview:activity];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Configure the view for the selected state
	
#ifdef DEBUG_CELL
	self.textLabel.backgroundColor = [UIColor redColor];
	self.detailTextLabel.backgroundColor = [UIColor greenColor];
#endif
	
	[activity startAnimating];
	
	CGRect baseRect = CGRectInset(self.contentView.bounds, 10, 10);
	
	NSUInteger marginLeft = 30;
	NSUInteger padding = 24; // between activity view and label
	
	CGRect original;
	// Main label
	original = self.textLabel.frame;	
	activity.frame = CGRectMake(marginLeft, original.origin.y + 2, activity.frame.size.width, activity.frame.size.height);
	self.textLabel.frame = CGRectMake(original.origin.x + padding + marginLeft, 
									  original.origin.y, 
									  baseRect.size.width - padding * 2 - marginLeft, 
									  original.size.height);
	
	original = self.detailTextLabel.frame;
	self.detailTextLabel.frame = CGRectMake(original.origin.x + padding + marginLeft, 
											original.origin.y, 
											baseRect.size.width - padding * 2 - marginLeft, 
											original.size.height);
}

-(NSString *) description {
	return [NSString stringWithFormat:@"<CRVLoadingTableCell activity: '%@', headline: '%@', subline: '%@'>", [self activity], 
			[[self textLabel] text], 
			[[self detailTextLabel] text]];
}


- (void)dealloc {
	CRV_RELEASE_SAFELY(activity);
    [super dealloc];
}


@end
