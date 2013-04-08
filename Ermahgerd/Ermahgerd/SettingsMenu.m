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
                                        selector:@selector(back:)];
        backButton.rotation = -90;
        
        CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
        [menuLayer addChild: menu];
    }
    return self;
}

- (void) back:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
}



@end
