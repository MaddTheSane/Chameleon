//
//  MPMoviewPlayerController.m
//  MediaPlayer
//
//  Created by Michael Dales on 08/07/2011.
//  Copyright 2011 Digital Flapjack Ltd. All rights reserved.
//

#import "MPMoviePlayerController.h"
#import "UIInternalMovieView.h"
#import <AVFoundation/AVFoundation.h>

NSString *const MPMoviePlayerPlaybackDidFinishReasonUserInfoKey = @"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey";

// notifications
NSString *const MPMoviePlayerPlaybackStateDidChangeNotification = @"MPMoviePlayerPlaybackStateDidChangeNotification";
NSString *const MPMoviePlayerPlaybackDidFinishNotification = @"MPMoviePlayerPlaybackDidFinishNotification";
NSString *const MPMoviePlayerLoadStateDidChangeNotification = @"MPMoviePlayerLoadStateDidChangeNotification";
NSString *const MPMovieDurationAvailableNotification = @"MPMovieDurationAvailableNotification";

@implementation MPMoviePlayerController
{
@private
	UIInternalMovieView *movieView;
	
	//AVMovie *movie;
	AVPlayer *player;

}
@synthesize view=_view;
@synthesize loadState=_loadState;
@synthesize contentURL=_contentURL;
@synthesize controlStyle=_controlStyle;
@synthesize movieSourceType=_movieSourceType;
@synthesize backgroundView;
@synthesize playbackState=_playbackState;
@synthesize repeatMode=_repeatMode;
@synthesize shouldAutoplay;
@synthesize scalingMode=_scalingMode;



///////////////////////////////////////////////////////////////////////////////
//
- (void)setScalingMode:(MPMovieScalingMode)scalingMode
{
    _scalingMode = scalingMode;
    movieView.scalingMode = scalingMode;
}


///////////////////////////////////////////////////////////////////////////////
//
- (NSTimeInterval)duration
{
    CMTime time = [player.currentItem duration];
    NSTimeInterval interval;
	
	interval = CMTimeGetSeconds(time);
	
	if (isnan(interval)) {
		return 0.0;
	}
	
	return interval;
}


///////////////////////////////////////////////////////////////////////////////
//
- (UIView*)view
{
    return movieView;
}



///////////////////////////////////////////////////////////////////////////////
//
- (MPMovieLoadState)loadState
{
#if 0
    NSNumber* loadState = [movie attributeForKey: QTMovieLoadStateAttribute];
    
    switch (movie) {
        case QTMovieLoadStateError:            
        {
            NSLog(@"woo");
            NSNumber *stopCode = [NSNumber numberWithInt: MPMovieFinishReasonPlaybackError];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject: stopCode
                                                                 forKey: MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
            
            // if there's a loading error we generate a stop notification
            [[NSNotificationCenter defaultCenter] postNotificationName: MPMoviePlayerPlaybackDidFinishNotification
                                                                object: self 
                                                              userInfo: userInfo];
            
            
            _loadState = MPMovieLoadStateUnknown;                        
        }
            break;

        
        
        case QTMovieLoadStateLoading:             
            _loadState = MPMovieLoadStateUnknown;            
            break;
            
    
        
        case QTMovieLoadStateLoaded:            
            // we have the meta data, so post the duration available notification
            [[NSNotificationCenter defaultCenter] postNotificationName: MPMovieDurationAvailableNotification
                                                                object: self];
            
            _loadState = MPMovieLoadStateUnknown;            
            break;
            
        case QTMovieLoadStatePlayable:
            _loadState = MPMovieLoadStatePlayable;
            break;
            
        case QTMovieLoadStatePlaythroughOK:
            _loadState = MPMovieLoadStatePlaythroughOK;            
            break;
            
        case QTMovieLoadStateComplete:
            _loadState = MPMovieLoadStatePlaythroughOK;
            
            break;                                
    }
    
    return _loadState;
#else
	return MPMovieLoadStatePlayable;
#endif
}


#pragma mark - notifications



///////////////////////////////////////////////////////////////////////////////
//
- (void)didEndOccurred: (NSNotification*)notification
{
    if (notification.object != player)
        return;

    _playbackState = MPMoviePlaybackStateStopped;
        
    NSNumber *stopCode = @(MPMovieFinishReasonPlaybackEnded);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject: stopCode
                                                         forKey: MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: MPMoviePlayerPlaybackDidFinishNotification
                                                        object: self
                                                      userInfo: userInfo];
	
	if (_repeatMode == MPMovieRepeatModeOne) {
		//player
		[player play];
	}
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)loadStateChangeOccurred: (NSNotification*)notification
{
    if (notification.object != player)
        return;
        
    [[NSNotificationCenter defaultCenter] postNotificationName: MPMoviePlayerLoadStateDidChangeNotification
                                                        object: self];
}

#pragma mark - constructor/destructor

///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithContentURL:(NSURL *)url
{
    self = [super init];
    if (self) 
    {
        _contentURL = url;
        _loadState = MPMovieLoadStateUnknown;
        _controlStyle = MPMovieControlStyleDefault;
        _movieSourceType = MPMovieSourceTypeUnknown;
        _playbackState = MPMoviePlaybackStateStopped;
        _repeatMode = MPMovieRepeatModeNone;
        
		player = [AVPlayer playerWithURL:url];
        
        movieView = [[UIInternalMovieView alloc] initWithPlayer: player];
        
        self.scalingMode = MPMovieScalingModeAspectFit;
		
		//TODO: replacement?
#if 0
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(loadStateChangeOccurred:)
                                                     name: QTMovieLoadStateDidChangeNotification
                                                   object: nil];
#endif
		
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(didEndOccurred:)
                                                     name: AVPlayerItemDidPlayToEndTimeNotification
                                                   object: nil];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


#pragma mark - MPMediaPlayback


///////////////////////////////////////////////////////////////////////////////
//
- (void)play
{
    [player play];
    _playbackState = MPMoviePlaybackStatePlaying;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)pause
{
    [player pause];
    _playbackState = MPMoviePlaybackStatePaused;
}

///////////////////////////////////////////////////////////////////////////////
//
- (void)prepareToPlay {
    // Do nothing
}

///////////////////////////////////////////////////////////////////////////////
//
- (void)stop
{
    [player pause];
    _playbackState = MPMoviePlaybackStateStopped;
}

#pragma mark - Pending

- (void) setShouldAutoplay:(BOOL)shouldAutoplay {
    NSLog(@"[CHAMELEON] MPMoviePlayerController.shouldAutoplay not implemented");
}

- (UIView*) backgroundView {
    NSLog(@"[CHAMELEON] MPMoviePlayerController.backgroundView not implemented");
    return nil;
}


@end
