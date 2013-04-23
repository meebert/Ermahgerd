//
//  Player.h
//  Ermahgerd
//
//  Created by Mitchell Hebert on 3/5/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



@interface Player : CCSprite 
  
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPos;
@property (nonatomic, assign) BOOL ground;
-(void)update:(ccTime)time;
-(CGRect)collBox;
@property (nonatomic, assign) BOOL forward;
@property (nonatomic, assign) BOOL backward;
@property (nonatomic, assign) BOOL jump;

@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *jumpAction;
@property (nonatomic, strong) CCSprite *emanWalk;
@property (nonatomic, strong) CCSprite *emanJump;

//@property (nonatomic, assign) CCSpriteSheet *emanSheet;
    
@end
