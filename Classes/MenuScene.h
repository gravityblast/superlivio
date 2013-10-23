//
//  MenuScene.h
//
//  Created by Andrea Franz on 3/16/10.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"
#import "GameLayer.h"
#import <MessageUI/MessageUI.h>

typedef enum {
	kAppStateAudioManagerInitialising,	//Audio manager is being initialised
	kAppStateSoundBuffersLoading,		//Sound buffers are loading
	kAppStateReady						//Everything is loaded
} tAppState;


@interface MenuScene : CCColorLayer <MFMailComposeViewControllerDelegate> {
	GameLayer *gameLayer;
	MFMailComposeViewController *picker;
}

@property (nonatomic, retain) GameLayer *gameLayer;

+ (id) scene;
- (id) init;
- (void) tick:(ccTime)dt;
- (void)onPlay:(id)sender;
- (void)onScores:(id)sender;
- (void)onInvite:(id)sender;

@end
