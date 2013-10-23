//
//  LivioAppDelegate.h
//
//  Created by Andrea Franz on 3/14/10.
//

#import <UIKit/UIKit.h>
#import "OpenFeint.h"
#import "CCNotifications.h"

@interface LivioAppDelegate : NSObject <UIApplicationDelegate, OpenFeintDelegate, OFNotificationDelegate, CCNotificationsDelegate> {
	UIWindow *window;	
}

@property (nonatomic, retain) UIWindow *window;

@end
