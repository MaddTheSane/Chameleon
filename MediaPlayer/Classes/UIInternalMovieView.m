//
//  UIInternalMovieView.m
//  MediaPlayer
//
//  Created by Michael Dales on 08/07/2011.
//  Copyright 2011 Digital Flapjack Ltd. All rights reserved.
//

#import "UIInternalMovieView.h"


@implementation UIInternalMovieView {
	AVPlayer *_player;
}

@synthesize player=_player;
@synthesize scalingMode=_scalingMode;


///////////////////////////////////////////////////////////////////////////////
//
- (void)setScalingMode:(MPMovieScalingMode)scalingMode
{
    _scalingMode = scalingMode;
    
    switch (scalingMode)
    {
        case MPMovieScalingModeNone:
            movieLayer.contentsGravity = kCAGravityCenter;
            break;
            
        case MPMovieScalingModeAspectFit:
            movieLayer.contentsGravity = kCAGravityResizeAspect;
            break;
            
        case MPMovieScalingModeAspectFill:
            movieLayer.contentsGravity = kCAGravityResizeAspectFill;
            break;
            
        case MPMovieScalingModeFill:
            movieLayer.contentsGravity = kCAGravityResize;
            break;
            
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (instancetype)initWithPlayer:(AVPlayer*)aPlayer
{
	if (self = [super init]) {
		_player = aPlayer;
		movieLayer = [AVPlayerLayer playerLayerWithPlayer: _player];
		
		[self.layer addSublayer: movieLayer];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////
//
- (void)setFrame:(CGRect)frame
{
    [super setFrame: frame];
    [movieLayer setFrame: frame];
}

@end
