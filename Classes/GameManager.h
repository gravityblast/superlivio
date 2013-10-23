//
//  GameManager.h
//
//  Created by Andrea Franz on 4/18/10.
//

#import <Foundation/Foundation.h>


@protocol GameManagerProtocol
- (void) gameDidPause;
- (void) gameDidPlay;
- (void) gameDidOver;
@end

@interface GameManager : NSObject {
	id delegate;
}

@property (nonatomic, assign) id delegate;
+ (GameManager*) sharedManager;
- (void) pause;
- (void) play;
- (void) over;
@end
