//
//  MPiTunesMusicPlayerController.m
//  MediaPlayer
//
//  Created by C.W. Betts on 1/25/16.
//
//

#import "MPiTunesMusicPlayerController.h"
#import "iTunes.h"
#import <ScriptingBridge/SBApplication.h>

@implementation MPiTunesMusicPlayerController {
	iTunesApplication *iTunes;
}

- (instancetype)init
{
	if (self = [super init]) {
		iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
		[iTunes run];
	}
	return self;
}

- (MPMusicPlaybackState)playbackState
{
	switch (iTunes.playerState) {
		case iTunesEPlSStopped:
			return MPMusicPlaybackStateStopped;
			break;
			
		case iTunesEPlSPaused:
			return MPMusicPlaybackStatePaused;
			break;
			
		case iTunesEPlSPlaying:
			return MPMusicPlaybackStatePlaying;
			break;
			
		case iTunesEPlSFastForwarding:
			return MPMusicPlaybackStateSeekingForward;
			break;
			
		case iTunesEPlSRewinding:
			return MPMusicPlaybackStateSeekingBackward;
			break;
	}
	return MPMusicPlaybackStateStopped;
}

- (void)play
{
	[iTunes playpause];
}

- (void)pause
{
	[iTunes pause];
}

- (void)prepareToPlay
{
	
}

- (void)stop
{
	[iTunes stop];
}

@end
