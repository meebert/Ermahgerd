//
//  MainMenu.m
//  Ermahgerd
//
//  Created by Mitchell Hebert on 3/10/13.
//
//

#import "MainMenu.h"
#import "GameLayer.h"
#import "SettingsMenu.h"



@implementation MainMenu

+(id) scene {
    CCScene *scene = [CCScene node];
    MainMenu *layer = [MainMenu node];
    [scene addChild: layer];
    return scene;
}

BOOL soundSetting; //Same as in GameLayer, will need to initialize based on Settings Menu
BOOL musicSetting;

-(id) init{
    
    if( (self=[super init] )) {
        CCSprite *title =[[CCSprite spriteWithFile:@"ermah.png"] retain];

        title.position =  ccp(50, 240);
        title.rotation = -90;
        [self addChild: title];
        
        [self refreshSettings];
        
        
        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        
        
        [self addChild:menuLayer];
        
        
        CCMenuItemImage *startButton = [CCMenuItemImage
                                        itemFromNormalImage:@"play.png"
                                        selectedImage:@"playSelect.png"
                                        target:self
                                        selector:@selector(startGame:)];
        CCMenuItemImage *tutButton = [CCMenuItemImage
                                        itemFromNormalImage:@"tutorial.png"
                                        selectedImage:@"tutorialSelect.png"
                                        target:self
                                        selector:@selector(tut:)];
        
        
        startButton.rotation = -90;
        tutButton.rotation = -90;
        tutButton.position = ccp(75,-10);
        startButton.position = ccp(0,-10);
        CCMenu *menu = [CCMenu menuWithItems: tutButton, startButton, nil];
       // [menu alignItemsVerticallyWithPadding:75];
        [menuLayer addChild: menu];
        
        if(soundSetting)
            NSLog(@"True");
        else
            NSLog(@"False");
    }
    return self;
}

- (void) startGame:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene:3 withLevel:@"levelOne.tmx"]];
}

- (void) tut:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[SettingsMenu scene]];
}

-(void) refreshSettings{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    soundSetting = [defaults boolForKey:kSoundKey];
    musicSetting = [defaults boolForKey:kMusicKey];
}

@end