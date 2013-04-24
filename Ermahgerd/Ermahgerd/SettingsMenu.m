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
BOOL musicOn;
BOOL soundsOn;
CCLabelTTF *musicToggle;
CCLabelTTF *soundsToggle;

-(id) init{
    
    if( (self=[super init] )) {
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"" fontName:@"Courier" fontSize:32];
        title.position =  ccp(50, 240);
        title.rotation = -90;
        [self addChild: title];

        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        [self addChild:menuLayer];
        
        musicOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"music"] boolValue ];
        soundsOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sounds"] boolValue ];
        
        
        musicToggle = [CCLabelTTF labelWithString:@"MUSIC" fontName:@"Courier" fontSize:32];
        soundsToggle = [CCLabelTTF labelWithString:@"MUSIC" fontName:@"Courier" fontSize:32];
        
        if(musicOn){
            musicToggle = [CCLabelTTF labelWithString:@"Music is On" fontName:@"Courier" fontSize:32];
        }else{
            musicToggle = [CCLabelTTF labelWithString:@"Music is Off" fontName:@"Courier" fontSize:32];
        }
        if(soundsOn){
            soundsToggle = [CCLabelTTF labelWithString:@"Sounds are On" fontName:@"Courier" fontSize:32];
        }else{
            soundsToggle = [CCLabelTTF labelWithString:@"Sounds are Off" fontName:@"Courier" fontSize:32];

        }
  
        musicToggle.position =  ccp(50, 240);
        musicToggle.rotation = -90;
        [self addChild: musicToggle];
        
        soundsToggle.position =  ccp(80, 240);
        soundsToggle.rotation = -90;
        [self addChild: soundsToggle];
       
        CCMenuItemImage *tutorial = [CCMenuItemImage
                                       itemFromNormalImage:@"tutorial.png"
                                       selectedImage:@"tutorialSelect.png"
                                       target:self
                                       selector:@selector(tut:)];
        
        CCMenuItemImage *resetHigh = [CCMenuItemImage
                                     itemFromNormalImage:@"tutorial.png"
                                     selectedImage:@"tutorialSelect.png"
                                     target:self
                                     selector:@selector(reset:)];
        
        CCMenuItemImage *musicButton = [CCMenuItemImage
                                      itemFromNormalImage:@"dirtrock.png"
                                      selectedImage:@"dirtrock.png"
                                      target:self
                                      selector:@selector(musicChange:)];
        CCMenuItemImage *soundsButton = [CCMenuItemImage
                                      itemFromNormalImage:@"tutorial.png"
                                      selectedImage:@"tutorialSelect.png"
                                      target:self
                                      selector:@selector(soundsChange:)];
        
        CCMenuItemImage *mainMenu = [CCMenuItemImage
                                         itemFromNormalImage:@"main.png"
                                         selectedImage:@"mainSelect.png"
                                         target:self
                                         selector:@selector(reset:)];
        
        
  
        tutorial.rotation = -90;
        resetHigh.rotation = -90;
        musicButton.rotation = -90;
        soundsButton.rotation = -90;
        mainMenu.rotation = -90;
        
        tutorial.position = ccp(75,-30);
        resetHigh.position = ccp(40,-30);
        
        musicButton.position = ccp(-100,-150);
        soundsButton.position = ccp(-70,-150);
        
        mainMenu.position = ccp(100,30);

        
        
         CCMenu *menu = [CCMenu menuWithItems: tutorial, resetHigh, musicButton,soundsButton,mainMenu, nil];
    
        [menuLayer addChild: menu];
    }
    return self;
}

-(void) musicChange:(id) sender{
    musicOn = !musicOn;
    
    [[NSUserDefaults standardUserDefaults] setBool:musicOn forKey:@"music"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *musicString;
    
    if(musicOn){
        musicString = [NSString stringWithFormat:@"Music is On"];
    }else{
        musicString = [NSString stringWithFormat:@"Music is Off"];
    }
    
    [musicToggle setString:musicString];
}
-(void) soundsChange:(id) sender{
    soundsOn = !soundsOn;
    
    [[NSUserDefaults standardUserDefaults] setBool:soundsOn forKey:@"sounds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *soundsString;
    
    if(musicOn){
        soundsString = [NSString stringWithFormat:@"Sounds are On"];
    }else{
        soundsString = [NSString stringWithFormat:@"Sounds are Off"];
    }
    
    [soundsToggle setString:soundsString];
    
}

-(void) reset:(id) sender{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"highScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void) tut:(id) sender{
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
                  selector:@selector(right:)];
    
    backButton.rotation = -90;
    backButton.rotation = -90;
    
    CCMenu *menu = [CCMenu menuWithItems: backButton, nil];
    [menuLayer addChild: menu];
    
    
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
