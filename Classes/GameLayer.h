
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Player.h"
#import "Cat.h"
#import "MenuScene.h"
#import <math.h>
#import "GameOverLayer.h"

// HelloWorld Layer
@interface GameLayer : CCColorLayer <CCTargetedTouchDelegate>
{
	Player *player;
	NSDate *touchStartedAt;
	BOOL playing;
	int currentPage;
	float currentPageX;
	int currentColumn;	
	CCSpriteSheet *blocks;
	CCSpriteSheet *cats;
	CCSpriteSheet *background;
	int lastUsedBlockIndex;
	int lastUsedCatIndex;
	int gameSpeed;
	int points;
	int enemiesPoints;
  // CCBitmapFontAtlas *pointsLabel;
  // CCBitmapFontAtlas *enemiesPointsLabel;
  // CCBitmapFontAtlas *healthLabel;
	GameOverLayer *gameOverLayer;
}

// returns a Scene that contains the HelloWorld as the only child
+ (id) layer;
- (void) tick:(ccTime) dt;
- (void) gameLoop:(ccTime) dt;
- (void) moveBackground:(ccTime) dt;
- (void) updateWorld:(ccTime) dt;
- (void) moveBlocksAndcheckPlayerCollisionWithBlocksFromPosition:(CGPoint)position_1 toPosition:(CGPoint)position_2 time:(ccTime)dt;
- (void) moveCatsAndcheckPlayerCollisionWithCatsFromPosition:(CGPoint)position_1 toPosition:(CGPoint)position_2 time:(ccTime)dt;
- (BOOL) checkPlayerCollisionWithBlock:(CCSprite*)sprite fromPosition:(CGPoint)position_1 toPosition:(CGPoint)position_2;
- (void) handleGameOver;
- (void) initFirstPageBlocks;
- (void) initBlocks;
- (void) initCats;
- (void) setBlock:(CGPoint)position;
- (void) setCat:(CGPoint)position;
- (void) updatePointsLabel;
- (void) updateEnemiesPointsLabel;
- (void) updateHealthLabel;
-(BOOL) playing;

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) NSDate *touchStartedAt;
@property (nonatomic, retain) CCSpriteSheet *blocks;
@property (nonatomic, retain) CCSpriteSheet *cats;
@property (nonatomic, retain) CCBitmapFontAtlas *pointsLabel;
@property (nonatomic, retain) CCBitmapFontAtlas *enemiesPointsLabel;
@property (nonatomic, retain) CCBitmapFontAtlas *healthLabel;
@property (nonatomic, retain) CCSpriteSheet *background;
@property (nonatomic, retain) GameOverLayer *gameOverLayer;
@end
