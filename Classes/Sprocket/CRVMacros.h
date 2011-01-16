/*
 *  CRVMacros.h
 *
 * Copyright (c) 2007 Stefan Saasen
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

#define CRV_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define MATH_MAX(a, b) ((a >= b) ? a : b)
#define BOOL_TO_STRING(b) (b ? @"YES" : @"NO")


// #define NDEBUG disables assert();
// #define NS_BLOCK_ASSERTIONS disables NSAssert()

// DEBUG
// Project > Get Info > Configuration 'Debug' > Other C FLags '-D DEBUG'
#ifdef DEBUG
#  define CRVDEBUG(...) NSLog(__VA_ARGS__)
#  define CRVDEBUGRECT(rect, msg) NSLog(@"%@. rect size -> width: %f, height: %f. Origin x: %f, y: %f", msg, rect.size.width, rect.size.height, rect.origin.x, rect.origin.y)
#  define CRVDEBUGPOINT(point, msg) NSLog(@"%@ point -> x: %f, y: %f", msg, point.x, point.y)
#  define CRVDEBUGSIZE(size, msg) NSLog(@"%@ size -> width: %f, height: %f", msg, size.width, size.height)
#  define CRVDEBUGTRANSFORM(transform, msg) NSLog(@"CGAffineTransform [%@] a: %f b: %f c: %f d: %f tx: %f ty: %f", msg, transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty)
# else
#  define NDEBUG
#  define CRVDEBUG(...)	/* */
#  define CRVDEBUGRECT(rect, msg) /* */
#  define CRVDEBUGPOINT(point, msg) /* */
#  define CRVDEBUGSIZE(size, msg) /* */
#  define CRVDEBUGTRANSFORM(transform, msg) /* */
#endif



//
#define List(...) ([NSArray arrayWithObjects:__VA_ARGS__])
