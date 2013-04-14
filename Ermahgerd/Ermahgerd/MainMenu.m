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
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"ERMAHGERD" fontName:@"Courier" fontSize:32];
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
        CCMenuItemImage *settingsButton = [CCMenuItemImage
                                        itemFromNormalImage:@"settings.png"
                                        selectedImage:@"settingsSelect.png"
                                        target:self
                                        selector:@selector(settings:)];
        
        
        startButton.rotation = -90;
        settingsButton.rotation = -90;
        
        CCMenu *menu = [CCMenu menuWithItems: startButton,settingsButton, nil];
        [menu alignItemsVerticallyWithPadding:150];
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

- (void) settings:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[SettingsMenu scene]];
}

-(void) refreshSettings{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    soundSetting = [defaults boolForKey:kSoundKey];
    musicSetting = [defaults boolForKey:kMusicKey];
}

@end