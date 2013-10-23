//
//  Player.h
//
//  Created by Andrea Franz on 3/14/10.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface Cat : CCSprite {
	ccVertex2F vel;
	ccVertex2F acc;
	int speedLeft;
	int speedRight;
	float step;
	BOOL live;
}

+(id) catWithSpriteSheet:(CCSpriteSheet*)sheet rect:(CGRect)rect;
-(id) initCatWithSpriteSheet:(CCSpriteSheet*)sheet rect:(CGRect)rect;
-(void) reset;
-(void) die;
-(BOOL) alive;
-(void) afterDyingJump;
-(void) updatePosition:(ccTime) dt;
@end
