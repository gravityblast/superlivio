//
//  MenuScene.m
//
//  Created by Andrea Franz on 3/16/10.
//

#import "MenuScene.h"
#import "GameLayer.h"
#import "OpenFeint.h"

@implementation MenuScene
@synthesize gameLayer;

+ (id) scene {
	CCScene *scene = [CCScene node];
	MenuScene *layer = [MenuScene node];	
	[scene addChild: layer];
	return scene;
}

- (id) init {
//	if ((self = [super initWithColor:ccc4(21, 169, 255, 255)])) {
    if ((self = [super init])) {
		self.gameLayer = [GameLayer node];
		[self addChild:gameLayer];
		//[self schedule:@selector(tick:)];
		
		CCMenuItem *menuItem1 = [CCMenuItemFont itemFromString:@"Play"	target:self selector:@selector(onPlay:)];
		menuItem1.anchorPoint = ccp(1, 1);
		
		CCMenuItem *menuItem2 = [CCMenuItemFont itemFromString:@"Scores"	target:self selector:@selector(onScores:)];
		menuItem2.anchorPoint = ccp(1, 1);
		
		CCMenuItem *menuItem3 = [CCMenuItemFont itemFromString:@"Invite"	target:self selector:@selector(onInvite:)];
		menuItem3.anchorPoint = ccp(1, 1);
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
		[menu alignItemsVertically];
		
		menu.position = ccp(350, 180);
		
		[self addChild:menu];
	}			
	
	return self;
}

-(void)tick:(ccTime)dt {
}

-(void)onEnter {
	[super onEnter];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu.mp3"];
}

- (void)onPlay:(id)sender {	
	[[CCDirector sharedDirector] replaceScene:[GameScene scene]];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"level.mp3"];
}

- (void)onScores:(id)sender {
	[OpenFeint launchDashboard];
}

- (void)onInvite:(id)sender {
	[[CCDirector sharedDirector] pause];
	
	picker = [[MFMailComposeViewController alloc] init];	
	picker.mailComposeDelegate = self; 
	
	[picker setSubject:@"Test email"];
	[picker setMessageBody:@"Hello" isHTML:YES];	
//	picker.navigationBar.barStyle = UIBarStyleBlack;
	
	[[[CCDirector sharedDirector] openGLView] addSubview:picker.view];
	
	[picker presentModalViewController:picker animated:YES];
	[picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[[CCDirector sharedDirector] resume];		
	[picker.view removeFromSuperview];
	[picker dismissModalViewControllerAnimated:YES];
}

-(void) dealloc {
	[gameLayer release];
	[super dealloc];
}

@end
