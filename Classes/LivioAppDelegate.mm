//
//  LivioAppDelegate.m
//
//  Created by Andrea Franz on 3/14/10.
//

#import "LivioAppDelegate.h"
#import "cocos2d.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "GameManager.h"

@implementation LivioAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{	
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
	
	// Openfeint
	NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight], OpenFeintSettingDashboardOrientation,
							  @"livio-test", OpenFeintSettingShortDisplayName,
							  [NSNumber numberWithBool:YES], OpenFeintSettingDisableUserGeneratedContent,
							  [NSNumber numberWithBool:NO], OpenFeintSettingEnablePushNotifications,
							  window, OpenFeintSettingPresentationWindow,
							  nil
							  ];
	//OFDelegatesContainer* delegates = [OFDelegatesContainer containerWithOpenFeintDelegate:self andChallengeDelegate:nil andNotificationDelegate:self];
	//[OpenFeint initializeWithProductKey:@"XYZ" andSecret:@"XYZ" 
	//					 andDisplayName:@"LivioTest OpenFeint" andSettings:settings andDelegates:delegates];
	
	//CCNotifications delegate
	//[[CCNotifications sharedManager] setDelegate:self];
	//[[CCNotifications sharedManager] setPosition:kCCNotificationPositionTop];
	
	// Main Scene	
	[[CCDirector sharedDirector] runWithScene: [MenuScene scene]];
}

- (BOOL) isOpenFeintNotificationAllowed:(OFNotificationData*)notificationData{
	return NO;	
}

- (void)handleDisallowedNotification:(OFNotificationData*)notificationData{
	[[CCNotifications sharedManager] addNotificationTitle:@"Openfeint:" message:[notificationData notificationText] image:@"openfeint_logo.png" tag:1 animate:YES];
}

- (void)dashboardWillAppear {
	[[GameManager sharedManager] pause];
}

- (void)userLoggedIn:(NSString*)userId {
	NSLog(@"===========> userLoggedIn: %@", userId);
}

- (BOOL) showCustomOpenFeintApprovalScreen {
	return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
	[OpenFeint applicationWillResignActive];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
	[OpenFeint applicationDidBecomeActive];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[OpenFeint shutdown];
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) notificationChangeState:(char)state tag:(int)tag {
	if(state == kCCNotificationStateShowing){
		//Play sound
	}
}

- (BOOL) touched:(int)tag{
	//Example
	/*
	 if(tag==kTagOpenfeint) {
	 [OpenFeint launchDashboard];
	 }
	 */
	return NO;
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
