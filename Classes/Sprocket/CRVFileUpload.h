//
//  CRVFileUpload.h
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

#import <Foundation/Foundation.h>


@class CRVFileUpload;

@protocol CRVFileUploadDelegate<NSObject>

@optional
- (void) didFailWithError:(NSError *)error withUpload:(CRVFileUpload *)upload;
- (void) didReceiveData:(NSData *)data withUpload:(CRVFileUpload *)upload;
@end

@interface CRVFileUpload : NSObject {
	NSInputStream *inputStream;
	NSURLConnection *uploadConnection;
	NSMutableData *responseData;
	id<CRVFileUploadDelegate> delegate;
	NSString *token;
	
	@private
	long length;
}

@property(nonatomic, retain) NSInputStream *inputStream;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, assign) id<CRVFileUploadDelegate> delegate;

-(id)initWithFileAtPath:(NSString *) thePath withDelegate:(id<CRVFileUploadDelegate>)theDelegate;
-(id)initWithData:(NSData *) theData withDelegate:(id<CRVFileUploadDelegate>)theDelegate;

-(void) startUploadWithTarget:(NSURL *) theTargetUrl andToken:(NSString *)theToken;
-(void) startUploadWithTarget:(NSURL *) theTargetUrl;



@end
