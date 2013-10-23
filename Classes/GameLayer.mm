//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "GameLayer.h"
#import "levels.h"
#import "OFAchievementService.h"

#define MIN_GAME_SPEED			150
#define MAX_GAME_SPEED			200

#define PLAYER_X			100
#define TILE_SIZE			32

#define SPRITE_TAG_PLAYER		1
#define SPRITE_TAG_CAT			2
#define SPRITE_TAG_BLOCK		3
#define SPRITE_TAG_MOUNTAINS	4
#define SPRITE_TAG_CLOUDS		5

#define	BACKGROUND_SPEED 30

// HelloWorld implementation
@implementation GameLayer

@synthesize player;
@synthesize touchStartedAt;
@synthesize blocks;
@synthesize cats;
// @synthesize pointsLabel;
// @synthesize enemiesPointsLabel;
// @synthesize healthLabel;
@synthesize background;
@synthesize gameOverLayer;


+(id) layer
{	
	return [GameLayer node];
}

-(id) init
{					
//	if( (self=[super initWithColor:(CCColorLayer)ccc4(21, 169, 255, 255)] )) {
    if( (self=[super init] )) {
		points = 0;
		enemiesPoints = 0;
		
		gameSpeed = MIN_GAME_SPEED;		
		
		self.background = [CCSpriteSheet spriteSheetWithFile:@"background2.png" capacity:2];
		CCSprite *back = [CCSprite spriteWithSpriteSheet:background rect:CGRectMake(0, 0, 960, 251)];		
		back.anchorPoint = ccp(0, 0);
		back.position = ccp(0, 0);
		[background addChild:back z:1 tag:1];
//		CCSprite *fore = [CCSprite spriteWithSpriteSheet:background rect:CGRectMake(0, 252, 960, 251)];		
//		[background addChild:fore z:2 tag:2];
//		fore.anchorPoint = ccp(0, 0);
//		fore.position = ccp(0, 0);
		[self addChild:background];
		
//		self.background = [CCSprite spriteWithFile:@"clouds.png"];
//		background.anchorPoint = ccp(0, 0);
//		background.position = ccp(0, 0);
//		[self addChild:background];
//		
//		self.foreground = [CCSprite spriteWithFile:@"mountains.png"];
//		foreground.anchorPoint = ccp(0, 0);
//		foreground.position = ccp(0, 0);
//		[self addChild:foreground];
		
		[self initBlocks];
		[self initCats];
		
		currentPage = 0;
		currentPageX = 0;
		currentColumn = -1;
		playing = YES;
		[self initFirstPageBlocks];		
		
		self.player = [Player player];
		player.position = ccp(PLAYER_X, 300);
		[self addChild:player z:2 tag:SPRITE_TAG_PLAYER];						
		
    // self.healthLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"font-points.fnt"];
    // healthLabel.anchorPoint = ccp(1, 1);
    // self.healthLabel.position = ccp(50, 313);
    // [self addChild:healthLabel];
    // [self updateHealthLabel];
    // 
    // self.pointsLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"font-points.fnt"];
    // pointsLabel.anchorPoint = ccp(1, 1);
    // self.pointsLabel.position = ccp(450, 313);
    // [self addChild:pointsLabel];
    // 
    // self.enemiesPointsLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"font-points.fnt"];
    // enemiesPointsLabel.anchorPoint = ccp(1, 1);
    // self.enemiesPointsLabel.position = ccp(475, 313);
    // [self addChild:enemiesPointsLabel];        
	}
	return self;
}

- (void)initBlocks {
	lastUsedBlockIndex = -1;
	self.blocks = [CCSpriteSheet spriteSheetWithFile:@"cloud.png" capacity:20];
	for(int i = 0; i < 20; i++) {
		CCSprite *block = [CCSprite spriteWithSpriteSheet:blocks rect:CGRectMake(0, 0, 32, 32)];
		block.position = ccp(-(TILE_SIZE / 2), -(TILE_SIZE / 2));
		[block setVisible:NO];
		[blocks addChild:block];
	}
	blocks.anchorPoint = ccp(0, 0);
	[self addChild:blocks z:0];
}

- (void)initCats {
	lastUsedCatIndex = -1;
	self.cats = [CCSpriteSheet spriteSheetWithFile:@"cat.png" capacity:4];
	for(int i = 0; i < 4; i++) {
		Cat *cat = [Cat catWithSpriteSheet:cats rect:CGRectMake(0, 0, 32, 32)];
		cat.position = ccp(-(TILE_SIZE / 2), -(TILE_SIZE / 2));		
		[cat setVisible:NO];
		[cats addChild:cat];
	}
	cats.anchorPoint = ccp(0, 0);
	[self addChild:cats z:1];
}

- (void)setBlock:(CGPoint)position {
	lastUsedBlockIndex = (lastUsedBlockIndex + 1) % 20;
	CCSprite *block = [[blocks children] objectAtIndex:lastUsedBlockIndex];
	[block setVisible:YES];
	[block setPosition:position];
}

- (void)setCat:(CGPoint)position {
	lastUsedCatIndex = (lastUsedCatIndex + 1) % 4;
	Cat *cat = [[cats children] objectAtIndex:lastUsedCatIndex];
	[cat setPosition:position];
	[cat reset];
}


- (void)initFirstPageBlocks {		
	for (int i = 0; i < 15; i++) {
		[self setBlock:ccp(i * TILE_SIZE + TILE_SIZE / 2, 16)];
	}
}

-(void) onEnter {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark game loop

- (void)tick:(ccTime) dt {	
	if (playing) {
		[self gameLoop:dt];
	}
}

- (void)gameLoop:(ccTime) dt {
	if (dt > 0.08)
		dt = 0.08;		
	
	[self moveBackground:dt];
	[self updateWorld:dt];
	
	CGPoint position_1 = player.position;
	[player updatePosition:dt];
	CGPoint position_2 = player.position;		
	
	[self moveBlocksAndcheckPlayerCollisionWithBlocksFromPosition:position_1 toPosition:position_2 time:dt];
	[self moveCatsAndcheckPlayerCollisionWithCatsFromPosition:position_1 toPosition:position_2 time:dt];
	
	if (player.position.y + TILE_SIZE/2 < 0) {
		[self handleGameOver];
		return;
	}
}

- (void)moveBackground:(ccTime) dt {
	for (CCSprite *sprite in [background children]) {
		CGPoint background_position = ccp(sprite.position.x, sprite.position.y);	
		background_position.x -= BACKGROUND_SPEED * dt;
		if (background_position.x <= -480) {
			background_position.x += 480;
		}
		sprite.position = background_position;
	}		
}

- (void)moveBlocksAndcheckPlayerCollisionWithBlocksFromPosition:(CGPoint)position_1 toPosition:(CGPoint)position_2 time:(ccTime)dt {				
	BOOL platformCollisionFound = NO;
	for (CCSprite *sprite in blocks.children) {
		CGPoint spos = ccp(sprite.position.x - gameSpeed * dt, sprite.position.y);
		sprite.position = spos;
		if (spos.x + 16 <= 0) {	
			[sprite setVisible:NO];
			continue;
		}		
		if (!platformCollisionFound && [self checkPlayerCollisionWithBlock:sprite fromPosition:position_1 toPosition:position_2]){			
			platformCollisionFound = YES;
			player.position = ccp(player.position.x, sprite.position.y + TILE_SIZE);
			[player setDown];
		}
	}
	if (!platformCollisionFound) {
		[player fall];
	}	
}

- (BOOL) checkPlayerCollisionWithBlock:(CCSprite*)sprite fromPosition:(CGPoint)position_1 toPosition:(CGPoint)position_2 {
	return (
			sprite.position.x >= player.position.x - TILE_SIZE && 
			sprite.position.x <= player.position.x + TILE_SIZE &&			
			position_1.y - TILE_SIZE/2 >= sprite.position.y+TILE_SIZE/2 &&
			position_2.y - TILE_SIZE/2 <= sprite.position.y+TILE_SIZE/2
	);
}

- (void)moveCatsAndcheckPlayerCollisionWithCatsFromPosition:(CGPoint)position_1 toPosition:(CGPoint)position_2 time:(ccTime)dt {			
	for (Cat *sprite in cats.children) {				
		if (!sprite.alive) continue;
		CGPoint spos = ccp(sprite.position.x - gameSpeed * dt, sprite.position.y);
		sprite.position = spos;
		if (spos.x + 16 <= 0) {				
			continue;
		}						
		[sprite updatePosition:dt];				
		
		if ((sprite.position.x >= player.position.x - TILE_SIZE && sprite.position.x <= player.position.x + TILE_SIZE) &&
			(sprite.position.y >= player.position.y - TILE_SIZE && sprite.position.y <= player.position.y + TILE_SIZE)) {
			if (position_1.y > position_2.y && position_1.y >= sprite.position.y + TILE_SIZE) {
				enemiesPoints += 1;
				[self updateEnemiesPointsLabel];
				[sprite die];												
			} else {
				if (![player isBlinking]) {
					if ([player health] > 0) {
						[player decrementHealth];
						[player startBlinking];
						[self updateHealthLabel];
					} else {
						[self handleGameOver];
					}
				}
			}
	
		}
	}	
}

- (void)updateWorld:(ccTime) dt {
	currentPageX += gameSpeed * dt;
	if (currentPageX >= 480) {
		currentPageX -= 480;
		currentPage = (currentPage + 1) % LEVELS_COUNT;
		if (gameSpeed < MAX_GAME_SPEED) {
			gameSpeed += 1;			
		}
	}
	int column = floor(currentPageX / 32);
	if (column != currentColumn) {
		points += 5;		
		[self updatePointsLabel];
		currentColumn = column;				
		for(int i = 0; i < 10; i++) {
			float x = 480 - currentPageX + 15 + TILE_SIZE * currentColumn;
			float y = (10 - i) * TILE_SIZE - TILE_SIZE / 2;
			
			if (LEVELS[currentPage][i][currentColumn] == 1) {
				[self setBlock:ccp(x, y)];
			} else if (LEVELS[currentPage][i][currentColumn] == 2) {
				[self setCat:ccp(x, y)];
			}
		}
	}
}

- (void) updatePointsLabel {
  // [pointsLabel setString:[NSString stringWithFormat:@"%d", points]];
}

- (void) updateEnemiesPointsLabel {
  // [enemiesPointsLabel setString:[NSString stringWithFormat:@"%d", enemiesPoints]];
}

- (void) updateHealthLabel {
  // [healthLabel setString:[NSString stringWithFormat:@"%d", [player health]]];
}

-(void) handleGameOver {
	playing = NO;
	[player stop];	
	id jump = [CCJumpBy actionWithDuration:1 position:player.position height:340 jumps:1];
	[player runAction:jump];
	self.gameOverLayer = [GameOverLayer layerWithPoints:points enemiesPoints:enemiesPoints];
	[self addChild:gameOverLayer z:20];
}

-(BOOL)playing {
	return playing;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if (playing) {
		[player loadJump];
		return YES;
	} else {
		return NO;		
	}

}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	[player jump];
}

- (void) dealloc {
	[gameOverLayer release];
	[blocks release];
	[cats release];
	[touchStartedAt release];
	[player release];
	//[pointsLabel release];
	//[healthLabel release];
	//[enemiesPointsLabel release];
	[background release];
	[super dealloc];
}
@end
