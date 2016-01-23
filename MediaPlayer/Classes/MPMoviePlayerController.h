//
//  MPMoviewPlayerController.h
//  MediaPlayer
//
//  Created by Michael Dales on 08/07/2011.
//  Copyright 2011 Digital Flapjack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMediaPlayback.h"

typedef NS_OPTIONS(NSUInteger, MPMovieLoadState) {
    MPMovieLoadStateUnknown        = 0,
    MPMovieLoadStatePlayable       = 1 << 0,
    MPMovieLoadStatePlaythroughOK  = 1 << 1,
    MPMovieLoadStateStalled        = 1 << 2,
};

typedef NS_ENUM(NSInteger, MPMovieControlStyle) {
    MPMovieControlStyleNone,
    MPMovieControlStyleEmbedded,
    MPMovieControlStyleFullscreen,
    MPMovieControlStyleDefault = MPMovieControlStyleFullscreen
};

typedef NS_ENUM(NSInteger, MPMovieFinishReason) {
    MPMovieFinishReasonPlaybackEnded,
    MPMovieFinishReasonPlaybackError,
    MPMovieFinishReasonUserExited
};

typedef NS_ENUM(NSInteger, MPMovieSourceType) {
    MPMovieSourceTypeUnknown,
    MPMovieSourceTypeFile,
    MPMovieSourceTypeStreaming
};

typedef NS_ENUM(NSInteger, MPMovieRepeatMode) {
    MPMovieRepeatModeNone,
    MPMovieRepeatModeOne
};

typedef NS_ENUM(NSInteger, MPMoviePlaybackState) {
    MPMoviePlaybackStateStopped,
    MPMoviePlaybackStatePlaying,
    MPMoviePlaybackStatePaused,
    MPMoviePlaybackStateInterrupted,
    MPMoviePlaybackStateSeekingForward,
    MPMoviePlaybackStateSeekingBackward
};


typedef NS_ENUM(NSInteger, MPMovieScalingMode) {
    MPMovieScalingModeNone,
    MPMovieScalingModeAspectFit,
    MPMovieScalingModeAspectFill,
    MPMovieScalingModeFill
};

extern NSString *const MPMoviePlayerPlaybackDidFinishReasonUserInfoKey;

// notifications
extern NSString *const MPMoviePlayerPlaybackStateDidChangeNotification;
extern NSString *const MPMoviePlayerPlaybackDidFinishNotification;
extern NSString *const MPMoviePlayerLoadStateDidChangeNotification;
extern NSString *const MPMovieDurationAvailableNotification;

@interface MPMoviePlayerController : NSObject <MPMediaPlayback> 

@property (weak, nonatomic, readonly) UIView *view;
@property (nonatomic, readonly) MPMovieLoadState loadState;
@property (nonatomic, copy) NSURL *contentURL;
@property (nonatomic) MPMovieControlStyle controlStyle;
@property (nonatomic) MPMovieSourceType movieSourceType;

// A view for customization which is always displayed behind movie content.
@property(weak, nonatomic, readonly) UIView *backgroundView;

@property (nonatomic, readonly) MPMoviePlaybackState playbackState;
@property (nonatomic) MPMovieRepeatMode repeatMode;

// Indicates if a movie should automatically start playback when it is likely to finish uninterrupted based on e.g. network conditions. Defaults to YES.
@property(nonatomic) BOOL shouldAutoplay;

@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic) MPMovieScalingMode scalingMode;


- (instancetype)initWithContentURL: (NSURL*)url;

@end
