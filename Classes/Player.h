//
//  Player.h
//
//  Created by Andrea Franz on 3/14/10.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface Player : CCSprite {
	ccVertex2F vel;
	ccVertex2F acc;
	ccVertex2F gravity;
	NSDate *jumpLoadedAt;
	NSDate *blinkStartedAt;
	BOOL jumping;
	CCAction *runningAction;
	CCAction *jumpingAction;
	CCAction *blinkAction;
	BOOL running;
	int health;
	BOOL blinking;
}

@property (nonatomic, retain) NSDate *jumpLoadedAt;
@property (nonatomic, retain) CCAction *runningAction;
@property (nonatomic, retain) CCAction *jumpingAction;
@property (nonatomic, retain) CCAction *blinkAction;
@property (nonatomic, retain) NSDate *blinkStartedAt;

+ (id) player;
- (id) initPlayer;
- (int) health;
- (void) decrementHealth;
- (void) updatePosition:(ccTime) dt;
- (void) jump;
- (void) setDown;
- (BOOL) isFalling;
- (void) fall;
- (void) loadJump;
- (void) stop;
- (void) startBlinking;
- (void) stopBlinking;
- (BOOL) isBlinking;
- (void) run;
@end
