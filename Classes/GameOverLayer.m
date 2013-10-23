//
//  GameOverScene.m
//
//  Created by Andrea Franz on 4/3/10.
//

#import "GameOverLayer.h"
#import "MenuScene.h"

#define POINTS_PER_ENEMY 50

@implementation GameOverLayer
@synthesize pointsLabel;
@synthesize enemiesPointsLabel;
@synthesize totalPointsLabel;
@synthesize background;
@synthesize player;
@synthesize cat;

+(id)layerWithPoints:(int)points enemiesPoints:(int)enemiesPoints {
	return [[[GameOverLayer alloc] initWithPoints:points enemiesPoints:enemiesPoints] autorelease];
}

-(id)initWithPoints:(int)_points enemiesPoints:(int)_enemiesPoints {
	if ((self=[super init])) {
		points = _points;
		enemiesPoints = _enemiesPoints;
		totalPoints = 0;
		
		pointsDecrementStep = points <= 20 ? 1 : ceil(points / 20);
		enemiesPointsDecrementStep = enemiesPoints <= 20 ? 1 : ceil(enemiesPoints / 20);
		
		self.background = [CCColorLayer layerWithColor:ccc4(0, 0, 0, 230)];
		background.scale = 0.2;
		[self addChild:background];
		
		self.pointsLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"font-game-over.fnt"];
		pointsLabel.anchorPoint = ccp(0, 0);
		pointsLabel.position = ccp(230, 180);
		[pointsLabel setVisible:NO];
		[self addChild:pointsLabel];
		
		self.player = [CCSprite spriteWithFile:@"player_frame_1.png"];
		player.position = ccp(190, 202);
		[player setVisible:NO];
		[self addChild:player];
		
		self.enemiesPointsLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"font-game-over.fnt"];
		enemiesPointsLabel.anchorPoint = ccp(0, 0);
		enemiesPointsLabel.position = ccp(230, 140);		
		[enemiesPointsLabel setVisible:NO];
		[self addChild:enemiesPointsLabel];
		
		self.cat = [CCSprite spriteWithFile:@"cat.png"];
		cat.position = ccp(190, 162);
		[cat setVisible:NO];
		[self addChild:cat];
		
		self.totalPointsLabel = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"0" fntFile:@"font-game-over.fnt"];
		totalPointsLabel.anchorPoint = ccp(0, 0);
		totalPointsLabel.position = ccp(230, 100);
		[totalPointsLabel setVisible:NO];
		[self addChild:totalPointsLabel];
		
		[self updatePointsLabel];
		[self updateEnemiesPointsLabel];
		[self updateTotalPointsLabel];
	}
	
	return self;
}

-(void)onEnter {
	[super onEnter];
	
	id scale	= [CCScaleTo actionWithDuration:0.7 scale:0.55];
	id scale_bounce = [CCEaseBounceOut actionWithAction:[[scale copy] autorelease]];
	
	id notify	= [CCCallFunc actionWithTarget:self selector:@selector(startAnimations)];
	id seq		= [CCSequence actions:scale_bounce, notify, nil];
	[background runAction:seq];
}

- (void) startAnimations {
	[player setVisible:YES];
	[pointsLabel setVisible:YES];
	[cat setVisible:YES];
	[enemiesPointsLabel setVisible:YES];
	[totalPointsLabel setVisible:YES];
	[self decrementPoints];
}

-(void)decrementPoints {
	if (points > 0) {		
		int decrement = points > pointsDecrementStep ? pointsDecrementStep : points;		
		points -= decrement;
		totalPoints += decrement;		
		[self updatePointsLabel];
		[self updateTotalPointsLabel];
		
		id delay	= [CCDelayTime actionWithDuration:0.1];
		id callback = [CCCallFunc actionWithTarget:self selector:@selector(decrementPoints)];
		id sequence = [CCSequence actions:delay, callback, nil];
		[self runAction:sequence];
	} else {
		[self decrementEnemiesPoints];
	}

}

-(void)decrementEnemiesPoints {
	if (enemiesPoints > 0) {
		int decrement = enemiesPoints > enemiesPointsDecrementStep ? enemiesPointsDecrementStep : enemiesPoints;				
		enemiesPoints -= decrement;
		totalPoints += decrement * 50;
		[self updateEnemiesPointsLabel];
		[self updateTotalPointsLabel];
		
		id delay	= [CCDelayTime actionWithDuration:0.1];
		id callback = [CCCallFunc actionWithTarget:self selector:@selector(decrementEnemiesPoints)];
		id sequence = [CCSequence actions:delay, callback, nil];
		[self runAction:sequence];
	} else {
		id delay	= [CCDelayTime actionWithDuration:2];
		id callback = [CCCallFunc actionWithTarget:self selector:@selector(showMenuScene)];
		id sequence = [CCSequence actions:delay, callback, nil];
		[self runAction:sequence];
	}
}

-(void)updatePointsLabel {
	[pointsLabel setString:[NSString stringWithFormat:@"%d", points]];	
}

-(void)updateEnemiesPointsLabel {
	[enemiesPointsLabel setString:[NSString stringWithFormat:@"%d", enemiesPoints]];	
}

-(void)updateTotalPointsLabel {
	[totalPointsLabel setString:[NSString stringWithFormat:@"%d", totalPoints]];
}

-(void)showMenuScene {
	[[CCDirector sharedDirector] replaceScene:[MenuScene scene]];
}

-(void)dealloc {
	[player release];
	[cat release];
	[background release];
	[pointsLabel release];
	[enemiesPointsLabel release];
	[totalPointsLabel release];
	[super dealloc];
}

@end
