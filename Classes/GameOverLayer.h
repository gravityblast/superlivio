//
//  GameOverScene.h
//
//  Created by Andrea Franz on 4/3/10.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayer {
	CCColorLayer *background;
	
	CCBitmapFontAtlas *pointsLabel;
	CCBitmapFontAtlas *enemiesPointsLabel;
	CCBitmapFontAtlas *totalPointsLabel;		
	
	CCSprite *player;
	CCSprite *cat;
	
	int points;
	int enemiesPoints;
	int totalPoints;
	
	int pointsDecrementStep;
	int enemiesPointsDecrementStep;	
}

@property (nonatomic, retain) CCBitmapFontAtlas *pointsLabel;
@property (nonatomic, retain) CCBitmapFontAtlas *enemiesPointsLabel;
@property (nonatomic, retain) CCBitmapFontAtlas *totalPointsLabel;
@property (nonatomic, retain) CCColorLayer *background;
@property (nonatomic, retain) CCSprite *player;
@property (nonatomic, retain) CCSprite *cat;

+(id)layerWithPoints:(int)points enemiesPoints:(int)enemiesPoints;
-(id)initWithPoints:(int)points enemiesPoints:(int)enemiesPoints;
-(void)decrementPoints;
-(void)decrementEnemiesPoints;
-(void)updatePointsLabel;
-(void)updateEnemiesPointsLabel;
-(void)updateTotalPointsLabel;
- (void) showMenuScene;
- (void) startAnimations;
@end
