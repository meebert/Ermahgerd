//
//  Player.m
//  Ermahgerd
//
//  Created by Mitchell Hebert on 3/5/13.
//
//

#import "Player.h"
#import "SimpleAudioEngine.h"
#import "MainMenu.h"


@implementation Player
@synthesize velocity = _velocity;
@synthesize desiredPos = _desiredPos;
@synthesize ground = _ground;
@synthesize forward = _forward;
@synthesize jump = _jump;
@synthesize backward = _backward;

BOOL soundSetting; //Same as in GameLayer, will need to initialize based on Settings Menu
BOOL musicSetting;

-(id)initWithFile:(NSString *)filename
{

    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    
    [self refreshSettings];
    
    return self;
}

-(void) refreshSettings{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    soundSetting = [defaults boolForKey:kSoundKey];
    musicSetting = [defaults boolForKey:kMusicKey];
}

-(void)update:(ccTime)time
{
    CGPoint gravity = ccp(0.0, -300.0);
    CGPoint gravityStep = ccpMult(gravity, time);
    
    CGPoint forwardMove = ccp(600.0, 0.0);
    CGPoint backwardMove = ccp(-600.0, 0.0);
    
    CGPoint forwardStep = ccpMult(forwardMove, time);
    CGPoint backwardStep = ccpMult(backwardMove, time);
    
    self.velocity = ccpAdd(self.velocity, gravityStep);
    self.velocity = ccp(self.velocity.x * 0.90, self.velocity.y);
    
    CGPoint jumpForce = ccp(0.0, 300.0);
    
    float jumpCutoff = 150.0;
    
    if (self.jump && self.ground) {
        self.velocity = ccpAdd(self.velocity, jumpForce);
        if(soundSetting){
            [[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
        }
    } else if (!self.jump && self.velocity.y > jumpCutoff) {
        self.velocity = ccp(self.velocity.x, jumpCutoff);
    }
    
    
    if (self.forward){
        self.velocity = ccpAdd(self.velocity, forwardStep);
    }
    if(self.backward){
        self.velocity = ccpAdd(self.velocity, backwardStep);
    }
    
    CGPoint minMovement = ccp(-450.0, -450.0);
    CGPoint maxMovement = ccp(120.0, 250.0);
    self.velocity = ccpClamp(self.velocity, minMovement, maxMovement);
    
    CGPoint stepVelocity = ccpMult(self.velocity, time);
    
    self.desiredPos = ccpAdd(self.position, stepVelocity);
}

-(CGRect)collBox {
    CGRect collisionBox = CGRectInset(self.boundingBox, 3, 0);
    CGPoint diff = ccpSub(self.desiredPos, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
}




@end
