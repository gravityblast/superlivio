//
//  PauseLayer.m
//
//  Created by Andrea Franz on 4/14/10.
//

#import "PauseLayer.h"
#import "GameScene.h"
#import "GameManager.h"

@implementation PauseLayer

- (id) init {
	if ((self=[super init])) {
		CCColorLayer *backgroundLayer = [CCColorLayer layerWithColor:ccc4(0, 0, 0, 220)];
		[self addChild:backgroundLayer];
		CCLabel *label = [CCLabel labelWithString:@"RESUME" fontName:@"Marker Felt" fontSize:60];
		label.position = ccp(240, 160);
		[self addChild:label];
	}
	
	return self;
}

-(void) onEnter {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	[[GameManager sharedManager] play];
}

- (void) dealloc {
	[super dealloc];
}

@end
