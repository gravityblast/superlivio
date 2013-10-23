//
//  GameManager.m
//
//  Created by Andrea Franz on 4/18/10.
//

#import "GameManager.h"


@implementation GameManager
@synthesize delegate;

static GameManager *sharedGameManager = NULL;

+ (GameManager*) sharedManager {	
	if (sharedGameManager == NULL) {
		sharedGameManager = [[GameManager alloc] init];
	}
	
	return sharedGameManager;
}

- (id) init {
	if ((self=[super init])) {
		self.delegate = nil;
	}
	
	return self;
}

- (void) pause {
	if ([delegate respondsToSelector:@selector(gameDidPause)]) {
		[delegate gameDidPause];
	}
}

- (void) play {
	if ([delegate respondsToSelector:@selector(gameDidPlay)]) {
		[delegate gameDidPlay];
	}
}

- (void) over {
	if ([delegate respondsToSelector:@selector(gameDidOver)]) {
		[delegate gameDidOver];
	}
}

- (void) dealloc {
	sharedGameManager = nil;
	[super dealloc];
}

@end
