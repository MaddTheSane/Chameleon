/*
 * Copyright (c) 2011, The Iconfactory. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of The Iconfactory nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE ICONFACTORY BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UIImage+UIPrivate.h"
#import "UIImageAppKitIntegration.h"
#import "UIImageRep.h"
#import <AppKit/NSImage.h>
#import <objc/runtime.h>

static const char *UIImageAssociatedNSImageKey = "UIImageAssociatedNSImageKey";

static UIImageRep *UIImageRepFromNSImageRep(NSImageRep *rep, NSRect rect, CGFloat scale)
{
    return [[UIImageRep alloc] initWithCGImage:[rep CGImageForProposedRect:&rect context:nil hints:nil] scale:scale];
}

@implementation UIImage (AppKitIntegration)

+ (instancetype)imageWithNSImage:(NSImage *)theImage
{
    return [[self alloc] initWithNSImage:theImage];
}

- (instancetype)initWithNSImage:(NSImage *)theImage
{
    NSRect rect1X = NSMakeRect(0, 0, theImage.size.width, theImage.size.height);
    NSRect rect2X = NSMakeRect(0, 0, theImage.size.width*2, theImage.size.height*2);
    
    //Retina displays mess up this math...
    NSImageRep *theImageRep1X = [theImage bestRepresentationForRect:rect1X context:nil hints:nil];
    NSImageRep *theImageRep2X = [theImage bestRepresentationForRect:rect2X context:nil hints:nil];
    
    for (NSImageRep *rep in theImage.representations) {
        NSSize bitmapSize = NSMakeSize(rep.pixelsWide, rep.pixelsHigh);
        if (NSEqualSizes(bitmapSize, theImage.size)) {
            theImageRep1X = rep;
            break;
        }
    }
    
    if (theImageRep1X == nil) {
        theImageRep1X = theImageRep2X;
    }
    
    if (theImageRep1X == theImageRep2X) {
        theImageRep2X = nil;
    }
    
    UIImageRep *rep1 = UIImageRepFromNSImageRep(theImageRep1X, rect1X, 1);
    UIImageRep *rep2 = UIImageRepFromNSImageRep(theImageRep2X, rect2X, 2);
    
    NSMutableArray *reps = [NSMutableArray arrayWithCapacity:2];
    
    if (rep1) [reps addObject:rep1];
    if (rep2) [reps addObject:rep2];
    
    return [self _initWithRepresentations:reps];
}

- (NSImage *)NSImage
{
    NSImage *cached = objc_getAssociatedObject(self, UIImageAssociatedNSImageKey);
    
    if (!cached) {
        cached = [[NSImage alloc] initWithSize:NSSizeFromCGSize(self.size)];
        for (UIImageRep *rep in [self _representations]) {
            [cached addRepresentation:[[NSBitmapImageRep alloc] initWithCGImage:rep.CGImage]];
        }
        objc_setAssociatedObject(self, UIImageAssociatedNSImageKey, cached, OBJC_ASSOCIATION_RETAIN);
    }
    
    return cached;
}

+ (instancetype)imageWithScaledImages:(NSArray *)images
{
    return [[self alloc] initWithScaledImages:images];
}

- (instancetype)initWithScaledImages:(NSArray *)images
{
    NSMutableArray *reps = [[NSMutableArray alloc] initWithCapacity:images.count];
    NSMutableSet *scaleFactors = [NSMutableSet setWithCapacity:images.count];
    
    for (UIImage *img in images) {
        NSNumber *scale = @(img.scale);
        assert(CGSizeEqualToSize(img.size, [[images lastObject] size]));
        assert(![scaleFactors containsObject:scale]);
        
        [scaleFactors addObject:scale];
        [reps addObject:[[UIImageRep alloc] initWithCGImage:img.CGImage scale:img.scale]];
    }
    
    return [self _initWithRepresentations:reps];
}

+ (instancetype)imageNamedFromNSImage:(NSString*)named bundle:(NSBundle*)bundle
{
    NSImage *img = [bundle imageForResource:named];
    
    if (!img) {
        return nil;
    }
    return [self imageWithNSImage:img];
}

+ (instancetype)imageNamedFromNSImage:(NSString*)named
{
    NSImage *img = [NSImage imageNamed:named];
    if (!img) {
        return [self imageNamedFromNSImage:named bundle:[NSBundle bundleForClass:[self class]]];
    }
    return [self imageWithNSImage:img];
}

@end
