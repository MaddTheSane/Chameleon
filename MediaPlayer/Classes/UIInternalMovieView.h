//
//  UIInternalMovieView.h
//  MediaPlayer
//
//  Created by Michael Dales on 08/07/2011.
//  Copyright 2011 Digital Flapjack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "MPMoviePlayerController.h"


@interface UIInternalMovieView : UIView {
@private
    AVPlayerLayer *movieLayer;
}
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) MPMovieScalingMode scalingMode;

- (instancetype)initWithPlayer:(AVPlayer*)aPlayer;

@end
