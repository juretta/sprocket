//
//  CRVFileUpload.m
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

#import "CRVFileUpload.h"


@interface CRVFileUpload(PrivateMethods)
-(id)initWithStream:(NSInputStream *) theInputStream withDelegate:(id<CRVFileUploadDelegate>)theDelegate;
@end


@implementation CRVFileUpload


@synthesize responseData, inputStream, delegate, token;

// init implementieren

-(id)init {
	[self dealloc];
	@throw [NSException exceptionWithName:@"CRVIllegalInitCall" reason:@"Initialize CRVFileUpload with path to the file." userInfo:nil];
	return nil;
}


-(id)initWithFileAtPath:(NSString *) thePath withDelegate:(id<CRVFileUploadDelegate>)theDelegate {
	self = [self initWithStream:[NSInputStream inputStreamWithFileAtPath:thePath] withDelegate:theDelegate];
	if(self) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSError *error;
		NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath: thePath error:&error];
		length = [[fileAttributes objectForKey:NSFileSize] longValue];
	}
	return self;
}

/**
 * This is the designated initializer. Should only be called internally because otherwise we don't have the byte size (length).
 */
-(id)initWithStream:(NSInputStream *) theInputStream withDelegate:(id<CRVFileUploadDelegate>)theDelegate {
	self = [super init];
    if (self) {
		[self setDelegate:theDelegate];
		[self setInputStream:theInputStream];
		[self setToken:@""];
		length = 0;
    }
    return self;	
}

-(id)initWithData:(NSData *) theData withDelegate:(id<CRVFileUploadDelegate>)theDelegate {
	self = [self initWithStream:[NSInputStream inputStreamWithData:theData] withDelegate:theDelegate];
	if(self) {
		length = [theData length];
	}
	return self;
}

-(id)initWithFileAtPath:(NSString *) thePath {
	return [self initWithFileAtPath:thePath withDelegate:nil];
}

-(void) startUploadWithTarget:(NSURL *) theTargetUrl {
	[self startUploadWithTarget:theTargetUrl andToken:@""];
}

-(void) startUploadWithTarget:(NSURL *) theTargetUrl andToken:(NSString *)theToken {	
	// Clients can use this to identify upload requests.
	[self setToken:theToken];
	
	CRVDEBUG(@"uploading data for Token: %@", theToken);
	NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:theTargetUrl];
	[uploadRequest setHTTPMethod: @"POST"];
	
	// InputStream
	[uploadRequest setValue: @"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
	
	// Filesize -> content-length otherwise the transfer-encoding is chunked.
	[uploadRequest setValue: [[NSNumber numberWithLong:length] stringValue] forHTTPHeaderField: @"Content-Length"];	
	[uploadRequest setHTTPBodyStream:[self inputStream]];

	uploadConnection = [[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
	
	[uploadRequest release];
}

#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
	[uploadConnection release];
	uploadConnection = nil;
    [self setResponseData:nil];

    CRVDEBUG(@"Connection failure (didFailWithError)! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	if ( [[self delegate] respondsToSelector:@selector(didFailWithError:withUpload:)] ) {
		[[self delegate] didFailWithError:error	withUpload:self];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	CRVDEBUG(@"connection didReceiveResponse:%@",response);
	CRVDEBUG(@"Response statusCode: %d (%@)", [((NSHTTPURLResponse *)response) statusCode], 
			 [NSHTTPURLResponse localizedStringForStatusCode: [((NSHTTPURLResponse *)response) statusCode]]);
	CRVDEBUG(@"Response URL: %@", [((NSHTTPURLResponse *)response) URL]);
	CRVDEBUG(@"Response: %@", ((NSHTTPURLResponse *)response));
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [responseData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    CRVDEBUG(@"Succeeded! Received %d bytes of data",[responseData length]);
	
	if ([delegate respondsToSelector:@selector(didReceiveData:withUpload:)]) {
		[[self delegate] didReceiveData:[self responseData] withUpload:self];
	}
	
    // release the connection, and the data object
	[uploadConnection release];
	uploadConnection = nil;
    [self setResponseData:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // append the new data to the receivedData
    [responseData appendData:data];
}

-(void) dealloc {
	delegate = nil;
	CRV_RELEASE_SAFELY(token);
	CRV_RELEASE_SAFELY(responseData);
	CRV_RELEASE_SAFELY(uploadConnection);
	CRV_RELEASE_SAFELY(inputStream);
	[super dealloc];
}

@end
