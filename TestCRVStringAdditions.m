//
//  TestCRVStringAdditions.m
//  Sprocket
//
//  Created by Stefan Saasen on 16.01.11.
//

#import "TestCRVStringAdditions.h"


@implementation TestCRVStringAdditions

- (void) testToCamelCase {
    
    //STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    STAssertEqualObjects(@"thisIsCorrect", 
				   [@"this_is_correct" stringByConvertingUnderscoreToCamelCase], 
				   @"underscore should be converted to camel case"); 
	
    STAssertEqualObjects(@"unchanged", 
						 [@"unchanged" stringByConvertingUnderscoreToCamelCase], 
						 @"underscore should be converted to camel case"); 
	
    STAssertEqualObjects(@"", 
						 [@"" stringByConvertingUnderscoreToCamelCase], 
						 @"underscore should be converted to camel case"); 
	
    STAssertEqualObjects(@"thisIsCorrect", 
						 [@"thisIsCorrect" stringByConvertingUnderscoreToCamelCase], 
						 @"underscore should be converted to camel case"); 
}

@end
