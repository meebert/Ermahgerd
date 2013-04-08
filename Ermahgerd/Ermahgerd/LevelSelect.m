//
//  LevelSelect.m
//  Ermahgerd
//
//  Created by Mitchell Hebert on 3/16/13.
//
//

#import "LevelSelect.h"
#import "GameLayer.h"

@implementation LevelSelect

+(id) scene {
    CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
    [scene addChild: layer];
    return scene;
}

-(id) init{
    
    if( (self=[super init] )) {
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Courier" fontSize:32];
        title.position =  ccp(50, 240);
        title.rotation = -90;
        [self addChild: title];
        
        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        [self addChild:menuLayer];
        
        
        CCMenuItemImage *backButton = [CCMenuItemImage
                                       itemFromNormalImage:@"main.png"
                                       selectedImage:@"mainSelect.png"
                                       target:self
                                       selector:@selector(lvl1:)];
        backButton.rotation = -90;
        
        CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
        [menuLayer addChild: menu];
    }
    return self;
}

- (void) lvl1:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
}



@end