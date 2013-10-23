//
//  Player.m
//
//  Created by Andrea Franz on 3/14/10.
//

#import "Player.h"

#define PLAYER_MAX_JUMP_FORCE	1000
#define GRAVITY					-6000
#define SPRITE_FRAME_SIZE		32

@implementation Player
@synthesize jumpLoadedAt;
@synthesize runningAction;
@synthesize jumpingAction;
@synthesize blinkAction;
@synthesize blinkStartedAt;

+(id)player {
	return [[[self alloc] initPlayer] autorelease];
}

-(id)initPlayer {
	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"player_frames.png"];
	
	if ((self = [self initWithTexture:texture rect:CGRectMake(0, 0, SPRITE_FRAME_SIZE, SPRITE_FRAME_SIZE)])) {
		health = 3;
		running = NO;
		blinking = NO;
		vel.x = 0;
		vel.y = 0;
		vel.x = 0;
		vel.y = 0;
		gravity.x = 0;
		gravity.y = 0;
		jumping = NO;				
		
		CCSpriteFrame *frame1 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(SPRITE_FRAME_SIZE*1, 0, 32, 32) offset:CGPointZero];
		CCSpriteFrame *frame2 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(SPRITE_FRAME_SIZE*2, 0, 32, 32) offset:CGPointZero];
		CCSpriteFrame *frame3 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(SPRITE_FRAME_SIZE*3, 0, 32, 32) offset:CGPointZero];
		
		NSMutableArray *runAnimationFrames = [NSMutableArray array];
		[runAnimationFrames addObject:frame1];
		[runAnimationFrames addObject:frame2];
		[runAnimationFrames addObject:frame3];
		
		CCAnimation *runningAnimation = [CCAnimation animationWithName:@"run" delay:0.08f frames:runAnimationFrames];
		self.runningAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runningAnimation]];	
		
		id blink = [CCBlink actionWithDuration:2 blinks:10];
		id afterBlink = [CCCallFunc actionWithTarget:self selector:@selector(stopBlinking)];
		self.blinkAction = [CCSequence actions:blink, afterBlink, nil];
	}
	
	return self;
}

- (int) health {
	return health;
}

- (void) decrementHealth {
	health--;
}

- (void) startBlinking {
	if (!blinking) {
		blinking = YES;
		[self runAction:blinkAction];
	}	
}

- (void) stopBlinking {
	if (blinking) {
		blinking = NO;
		[self stopAction:blinkAction];
	}	
}

- (BOOL) isBlinking {
	return blinking;
}

-(void)fall {
	gravity.x = 0;
	gravity.y = GRAVITY;	
	jumpLoadedAt = nil;
}

-(void) updatePosition:(ccTime) dt {
	if (!jumping && jumpLoadedAt) {
		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:jumpLoadedAt];
		if (interval > 0.06) {
			[self jump];
		}
	}
	
	CGPoint _position = self.position;	
	vel.x += acc.x * dt;
	vel.y += acc.y * dt;
	
	acc.y += gravity.y * dt;
	acc.x += gravity.x * dt;
	
	if (vel.y != 0) {
		vel.y -= 50;
	}			

	_position.x += vel.x * dt;
	_position.y += vel.y * dt;
		
	self.position = _position;
}

-(BOOL)isFalling {
	return vel.y < 0;
}

-(void)loadJump {
	if (!jumping) {
		self.jumpLoadedAt = [NSDate date];
	}	
}

-(void)jump {
	[self stop];
	[self setTextureRect:CGRectMake(0, 0, SPRITE_FRAME_SIZE, SPRITE_FRAME_SIZE)];
	if (jumpLoadedAt && !jumping && ![self isFalling]) {
		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:jumpLoadedAt];				
		self.jumpLoadedAt = nil;
		acc.x = 0;
		acc.y = 0;
		vel.x = 0;
		if (interval < 0.03) {
			interval = 0.01;
		}
		float force = PLAYER_MAX_JUMP_FORCE / 0.06 * interval;
		force = force > PLAYER_MAX_JUMP_FORCE ? PLAYER_MAX_JUMP_FORCE : force;
		vel.y = force;
		jumping = YES;
	}
}

-(void)stop {
	if (running) {
		[self stopAction:runningAction];
		running = NO;
	}
}

-(void)run {
	if (!running) {
		[self runAction:runningAction];
		running = YES;
	}
}

-(void)setDown {
	acc.x = 0;
	acc.y = 0;
	vel.x = 0;
	vel.y = 0;
	gravity.x = 0;
	gravity.y = 0;
	jumping = NO;
	[self run];	
}


-(void)dealloc {
	[runningAction release];
	[jumpingAction release];
	[blinkAction release];
	[self setBlinkStartedAt:nil];
	[self setJumpLoadedAt:nil];
    [super dealloc];
}


@end
