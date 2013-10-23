//
//  GameScene.m
//
//  Created by Andrea Franz on 3/30/10.
//

#import "GameScene.h"
#import "GameLayer.h"

@implementation GameScene
@synthesize gameLayer;
@synthesize pauseLayer;

+(id) scene
{			
	CCScene *scene = [CCScene node];	
	GameScene *layer = [GameScene node];
	[scene addChild: layer];	
	return scene;
}

-(id) init {					
	if( (self=[super init] )) {
		[[GameManager sharedManager] setDelegate:self];
		playing = NO;
		self.gameLayer = [GameLayer layer];
		[self addChild:gameLayer];
		[self schedule:@selector(tick:)];
		
		CCMenuItemImage *pauseButton = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(onPause:)];
		CCMenu *pauseMenu = [CCMenu menuWithItems:pauseButton, nil];	
		pauseMenu.position = ccp(15, 305);
		[self addChild:pauseMenu];
	}
	
	return self;
}

-(void)onEnter {
	[super onEnter];
	playing = YES;	
}

-(void)onPause:(id)sender {
	[[GameManager sharedManager] pause];		
}

-(void)tick:(ccTime)dt {
	if (playing) {
		[gameLayer tick:dt];
	}
}

#pragma mark GameManagerProtocol methods

- (void) gameDidPause {
	if (playing && gameLayer.playing) {
		playing = NO;
		self.pauseLayer = [PauseLayer node];
		[self addChild:pauseLayer];
	}
}

- (void) gameDidPlay {
	if (pauseLayer) {
		[self removeChild:pauseLayer cleanup:YES];
		self.pauseLayer = nil;
	}
	playing = YES;
}

- (void) gameDidOver {

}

-(void) dealloc {
	[[GameManager sharedManager] setDelegate:nil];
	[gameLayer release];
	[super dealloc];
}
@end
