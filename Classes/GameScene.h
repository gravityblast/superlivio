//
//  GameScene.h
//
//  Created by Andrea Franz on 3/30/10.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PauseLayer.h"
#import "GameManager.h"

@class GameLayer;

@interface GameScene : CCLayer <GameManagerProtocol> {
	GameLayer *gameLayer;
	PauseLayer *pauseLayer;
	BOOL playing;
}

+(id) scene;
-(void)tick:(ccTime)dt;
-(void)onPause:(id)sender;
	
@property (nonatomic, retain) GameLayer *gameLayer;
@property (nonatomic, retain) PauseLayer *pauseLayer;

@end
