//
//  Cat.m
//
//  Created by Andrea Franz on 3/14/10.
//

#import "Cat.h"

#define CAT_MIN_VEL 20
#define CAT_MAX_VEL 250

float CAT_SPEEDS[6][2] = {
	{0.1, 1.0},
	{1.0, 0.1},
	{0.5, 0.5},
	{0.3, 0.7},
	{0.3, 1.0},
	{1.0, 0.3}	
};

@implementation Cat

+(id)catWithSpriteSheet:(CCSpriteSheet*)sheet rect:(CGRect)rect {
	return [[[self alloc] initCatWithSpriteSheet:sheet rect:rect] autorelease];
}

-(id) initCatWithSpriteSheet:(CCSpriteSheet*)sheet rect:(CGRect)rect {
	if ((self = [self initWithSpriteSheet:sheet rect:rect])) {		
		[self reset];	
	}
	
	return self;
}

-(void)reset {
	live = YES;
	[self setVisible:YES];
	acc.x = 0;
	acc.y = 0;	
	speedLeft = -(CAT_MIN_VEL + (rand() % (CAT_MAX_VEL - CAT_MIN_VEL)));
	speedRight = CAT_MIN_VEL + (rand() % (CAT_MAX_VEL - CAT_MIN_VEL));
	step = 0;
	vel.x = speedLeft;
	vel.y = 0;
}

-(void) updatePosition:(ccTime) dt {
	if (!live) return;
	CGPoint _position = self.position;	
	vel.y += acc.y;
	float x = vel.x * dt;
	step += x;	
	_position.x += x;	
	_position.y += vel.y * dt;		
	self.position = _position;
		
	if ((step > 0 && step > 96) || (step < 0 && step < -96)) {
		step = 0;
		vel.x = vel.x > 0 ? speedLeft : speedRight;
	}
}

-(void) die {
	live = NO;		
	self.scale = 0.5;
	id jump = [CCMoveTo actionWithDuration:0.2 position:ccp(490, 360)];	
	id call = [CCCallFunc actionWithTarget:self selector:@selector(afterDyingJump)];
	id sequence = [CCSequence actions:jump, call, nil];
	[self runAction:sequence];
}

-(BOOL) alive {
	return live == YES;
}

-(void) afterDyingJump {
	[self setVisible:NO];
	self.scale = 1;
	self.position = ccp(-20, -20);
	live = YES;
}


-(void)dealloc {
    [super dealloc];
}


@end
