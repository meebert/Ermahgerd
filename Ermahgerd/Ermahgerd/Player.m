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
#import "cocos2d.h"


@implementation Player

@synthesize velocity = _velocity;
@synthesize desiredPos = _desiredPos;
@synthesize ground = _ground;
@synthesize forward = _forward;
@synthesize jump = _jump;
@synthesize backward = _backward;
CCSpriteBatchNode *spriteSheet;
CCSpriteBatchNode *spriteJump;

BOOL soundSetting; //Same as in GameLayer, will need to initialize based on Settings Menu
BOOL musicSetting;
BOOL rotated = NO;

-(id)initWithFile:(NSString *)filename
{

    if (self = [super initWithFile:filename]) {
        self.velocity = ccp(0.0, 0.0);
    }
    
    [self refreshSettings];
    
    if (self) {
        
        spriteSheet = [[CCSpriteBatchNode batchNodeWithFile:@"emanSpriteSheet2.png"] retain];
        spriteJump = [[CCSpriteBatchNode batchNodeWithFile:@"emanJumpSheet.png"] retain];
        
        [self addChild:spriteSheet];
        [self addChild:spriteJump];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"emanSpriteSheet2.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"emanJumpSheet.plist"];
        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        NSMutableArray *jumpAnimFrames = [NSMutableArray array];
        for (int i = 1; i < 6; i++) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"emanrun%d.png",i]]];
        }
        
        for(int j = 1; j < 2; j++){
            [jumpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"emanjump%d.png",j]]];
        }
        CCAnimation *walkAnim = [CCAnimation
                                 animationWithSpriteFrames:walkAnimFrames delay:0.1f];
        CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpAnimFrames delay:0.5f];
        
        
        _emanWalk = [[CCSprite spriteWithSpriteFrameName:@"emanrun1.png"] retain];
        CGPoint offset = ccp(9.0,13.0);
        _emanWalk.position = ccpAdd(self.position, offset);
        _walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim]];
        _jumpAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:jumpAnim]];
        
        _emanJump = [[CCSprite spriteWithSpriteFrameName:@"emanjump1.png"] retain];
        _emanJump.position = ccpAdd(self.position, offset);
        [spriteJump addChild:_emanJump];
        [spriteSheet addChild:_emanWalk];
        
        [_emanJump runAction:_jumpAction];
        [_emanWalk runAction:_walkAction];

        
	}
    
	return self;

}

-(void) refreshSettings{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    soundSetting = [defaults boolForKey:kSoundKey];
    musicSetting = [defaults boolForKey:kMusicKey];
}

-(void)update:(ccTime)time
{
    [self refreshSettings];
    
    if(self.ground){
        _emanWalk.visible = YES;
        _emanJump.visible = NO;
    }
    else{
        _emanWalk.visible = NO;
        _emanJump.visible = YES;
    }
    
    if(!self.forward && !self.backward && !self.jump && self.ground){
        [_emanWalk pauseSchedulerAndActions];
    }
    else
        [_emanWalk resumeSchedulerAndActions];
    
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
    
    if (self.jump && self.ground) { //If hes jumping then start jumping animation
        self.velocity = ccpAdd(self.velocity, jumpForce);
        if(soundSetting){
            [[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"]; //Play jump sound effect
        }
        if(!_emanJump.isRunning) //For each action there needs to be a isRunnning check
            [_emanJump runAction:_jumpAction];
        
    } else if (!self.jump && self.velocity.y > jumpCutoff) {
        self.velocity = ccp(self.velocity.x, jumpCutoff);
    }
    
    if (self.forward){
        if(rotated){
            _emanWalk.flipX = 0; //If Eman is facing left then face him right
            _emanJump.flipX = 0;
            rotated = NO;
        }
        self.velocity = ccpAdd(self.velocity, forwardStep); //Start up the walking
        if(self.ground){
            if(!_emanWalk.isRunning) //Run the actions
                [_emanWalk runAction:_walkAction];
        }
        else{
            if(!_emanJump.isRunning)
                [_emanJump runAction:_jumpAction];
        }
        
    }
    
    if(self.backward){
        if(!rotated){
            _emanWalk.flipX = 90; //If Eman is right then face left
            _emanJump.flipX = 90;
            rotated = YES;
        }
        self.velocity = ccpAdd(self.velocity, backwardStep); //Start up the walking
        if(self.ground){
            if(!_emanWalk.isRunning) //More checks and actions
                [_emanWalk runAction:_walkAction];
        }
        else{
            if(!_emanJump.isRunning)
                [_emanJump runAction:_jumpAction];
        }
    }
    
    CGPoint minMovement = ccp(-450.0, -450.0); //Blah
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
