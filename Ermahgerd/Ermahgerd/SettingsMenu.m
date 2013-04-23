//
//  SettingsMenu.m
//  Ermahgerd
//
//  Created by Mitchell Hebert on 3/10/13.
//
//

#import "SettingsMenu.h"
#import "MainMenu.h"

@implementation SettingsMenu

+(id) scene {
    CCScene *scene = [CCScene node];
    SettingsMenu *layer = [SettingsMenu node];
    [scene addChild: layer];
    return scene;
}
CCMenuItemImage *backButton;
-(id) init{
    
    if( (self=[super init] )) {
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Courier" fontSize:32];
        title.position =  ccp(50, 240);
        title.rotation = -90;
        [self addChild: title];

        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        [self addChild:menuLayer];
        
        
         CCMenuItemImage *backButton = [CCMenuItemImage
                                        itemFromNormalImage:@"settings1.png"
                                        selectedImage:@"settings1.png"
                                        target:self
                                        selector:@selector(right:)];
        backButton.rotation = -90;
        
        CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
        [menuLayer addChild: menu];
    }
    return self;
}
-(void) left:(id) sender{
    
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Courier" fontSize:32];
    title.position =  ccp(50, 240);
    title.rotation = -90;
    [self addChild: title];
    
    
    CCLayer *menuLayer = [[CCLayer alloc] init];
    [self addChild:menuLayer];
    
    
    backButton = [CCMenuItemImage
                  itemFromNormalImage:@"left.png"
                  selectedImage:@"left.png"
                  target:self
                  selector:@selector(jump:)];
    backButton.rotation = -90;
    
    CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
    [menuLayer addChild: menu];
}

- (void) right:(id)sender{
    
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Courier" fontSize:32];
    title.position =  ccp(50, 240);
    title.rotation = -90;
    [self addChild: title];
    
    
    CCLayer *menuLayer = [[CCLayer alloc] init];
    [self addChild:menuLayer];
    
    
    backButton = [CCMenuItemImage
                  itemFromNormalImage:@"right.png"
                  selectedImage:@"right.png"
                  target:self
                  selector:@selector(left:)];
    backButton.rotation = -90;
    
    CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
    [menuLayer addChild: menu];
    
}

- (void) jump:(id)sender{
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Courier" fontSize:32];
    title.position =  ccp(50, 240);
    title.rotation = -90;
    [self addChild: title];
    
    
    CCLayer *menuLayer = [[CCLayer alloc] init];
    [self addChild:menuLayer];
    
    
    backButton = [CCMenuItemImage
                  itemFromNormalImage:@"jump.png"
                  selectedImage:@"jump.png"
                  target:self
                  selector:@selector(hazards:)];
    backButton.rotation = -90;
    
    CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
    [menuLayer addChild: menu];
    
    
    
    
}
- (void) hazards:(id)sender{
    
    
    CCLayer *menuLayer = [[CCLayer alloc] init];
    [self addChild:menuLayer];
    
    
    backButton = [CCMenuItemImage
                  itemFromNormalImage:@"hazards.png"
                  selectedImage:@"hazards.png"
                  target:self
                  selector:@selector(power:)];
    backButton.rotation = -90;
    
    CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
    [menuLayer addChild: menu];
}
- (void) power:(id)sender{
    CCLayer *menuLayer = [[CCLayer alloc] init];
    [self addChild:menuLayer];
    
    
    backButton = [CCMenuItemImage
                  itemFromNormalImage:@"powerUps.png"
                  selectedImage:@"powerUps.png"
                  target:self
                  selector:@selector(credits:)];
    backButton.rotation = -90;
    
    CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
    [menuLayer addChild: menu];
}
- (void) credits:(id)sender{
    
    CCLayer *menuLayer = [[CCLayer alloc] init];
    [self addChild:menuLayer];
    
    
    backButton = [CCMenuItemImage
                  itemFromNormalImage:@"credits.png"
                  selectedImage:@"credits.png"
                  target:self
                  selector:@selector(mainMenu:)];
    backButton.rotation = -90;
    
    CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
    [menuLayer addChild: menu];
}



-(void)mainMenu:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];

}

@end
