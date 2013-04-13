//
//  GameLayer.m
//  Ermahgerd
//
//  Created by Mitchell Hebert on 3/5/13.
//
//

#import "GameLayer.h"
#import "Player.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"


@interface GameLayer()
{
    Player * player;
    CCTMXTiledMap *map;
    CCTMXLayer *walls;
    CCTMXLayer *powerUp;
    CCTMXLayer *hazards;
    BOOL gameOver;
    BOOL musicSetting;
    BOOL soundSetting;
    
    //Score Variables
    CCLabelTTF *scoreLabel;
    CCLabelTTF *scoreText;
    int score;
    
    //Timer Variable
    CCLabelTTF *timeLabel;
    CCLabelTTF *timeText;
    int time;
    
    //PowerUp Variables
    int counter;
    int previousPos;
    
    //Lives Variables
    CCLabelTTF *livesLabel;
    CCLabelTTF *livesText;

    CGPoint firstTouch;
    int usedPower[1000];
    int powerCount;
    
    
    CCSprite *_movingSpring;
    bool pauseScreenActive;
    CCLayer *pauseLayer;
    CCSprite *pauseScreen;
    CCMenu *pauseScreenMenu;
    
   // CCSprite *_movingSpring;
    bool winScreenActive;
    CCLayer *winLayer;
    CCSprite *winScreen;
    CCMenu *winScreenMenu;
    
    bool retryScreenActive;
    CCLayer *retryLayer;
    CCSprite *retryScreen;
    CCMenu *retryScreenMenu;
    
    bool rScreenActive;
    CCLayer *rLayer;
    CCSprite *rScreen;
    CCMenu *rScreenMenu;
    
}

@end


@implementation GameLayer
int lives;
NSString *level;

+(CCScene *) scene:(int)numLives withLevel:(NSString *)theLevel
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    // [GameLayer setLevel:numLives];
	lives = numLives;
    level = theLevel;
    [[CCDirector sharedDirector] resume];

    
	// return the scene
	return scene;
}

-(void)setLevel:(NSString*) whichLevel{
    level = whichLevel;
}
-(void)setLives:(int) howManyLives{
    lives = howManyLives;
}

-(NSString*)getLevel{
    return level;
}

-(id) init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
       //[self setLevel:level];
       //[self.setLives:lives];
       // NSLog(level);
        
        if(level == @"levelOne.tmx"){
            level = @"levelOne.tmx";
        }
        if(level == @"test2.tmx"){
            level = @"test2.tmx";
        }
       if(level == NULL){
            level = @"levelOne.tmx";
            lives = 3;
        }
        if(lives == 0){
            lives = 3;
        }
     
        
        NSLog(@" init Testststststststststststs");
        musicSetting = true; //Will have to be able to set them here based on the Settings Menu
        soundSetting = true; //Setting them true for now
       
        if(musicSetting){
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Nature_Ambiance.wav" loop:true];
        }

        
        previousPos = player.position.x;
        powerCount = 0;
        //init goes here
        self.isTouchEnabled = true;
        
        CCLayerColor * skyBox = [[CCLayerColor alloc] initWithColor:ccc4(0, 100, 255, 255)];
        [self addChild:skyBox];
        map = [[CCTMXTiledMap alloc]  initWithTMXFile:level];
        [self addChild:map];
        
        
        player = [[Player alloc] initWithFile:@"erman.png"];
        player.position = ccp(100, 200);
        [map addChild:player z:15];
        score = 0;
        time = 180;
        //map.rotation = -45;
        float mapWidth;
        float mapHeight;
        mapWidth = map.mapSize.width * map.tileSize.width;
        mapHeight = map.mapSize.height * map.tileSize.height;
        CGPoint location = ccp((player.position.x/mapWidth ), (player.position.y/mapHeight + 0.59));
        map.anchorPoint = location;
        map.rotation = -90;
        
        scoreLabel = [[CCLabelTTF alloc] initWithString:@"5" fontName:@"Marker Felt" fontSize:20];
        scoreLabel.position = ccp(15, 440);
        scoreLabel.rotation = -90;
        [self addChild:scoreLabel z:1];
        
        scoreText = [[CCLabelTTF alloc] initWithString:@"Score:" fontName:@"Marker Felt" fontSize:20];
        scoreText.position = ccp(15, 380);
        scoreText.rotation = -90;
        [self addChild:scoreText z:1];
        
        timeLabel = [[CCLabelTTF alloc] initWithString:@"180" fontName:@"Marker Felt" fontSize:20];
        timeLabel.position = ccp(30, 440);
        timeLabel.rotation = -90;
        [self addChild:timeLabel z:1];
        
        timeText = [[CCLabelTTF alloc] initWithString:@"Time:" fontName:@"Marker Felt" fontSize:20];
        timeText.position = ccp(30, 380);
        timeText.rotation = -90;
        [self addChild:timeText z:1];
        
        
        NSString* livesString = [NSString stringWithFormat:@"%i", lives];
        
        livesLabel = [[CCLabelTTF alloc] initWithString:livesString fontName:@"Marker Felt" fontSize:20];
        livesLabel.position = ccp(45, 440);
        livesLabel.rotation = -90;
        [self addChild:livesLabel z:1];
        
        livesText = [[CCLabelTTF alloc] initWithString:@"Lives:" fontName:@"Marker Felt" fontSize:20];
        livesText.position = ccp(45, 380);
        livesText.rotation = -90;
        [self addChild:livesText z:1];
        
        
        walls = [map layerNamed:@"walls"];
        hazards = [map layerNamed:@"hazards"];
        powerUp = [map layerNamed:@"powerUp"];
        
        
        
        CCLayer *menuLayer = [[CCLayer alloc] init];
        
        [self addChild:menuLayer];
        
        CCMenuItemImage *pauseButton = [CCMenuItemImage
                                        itemFromNormalImage:@"pauseButton.png"
                                        selectedImage:@"pauseButton.png"
                                        target:self
                                        selector:@selector(pause:)];
        
        pauseButton.rotation = -90;
        pauseButton.position = ccp(-140, -200);
        CCMenu *pauseMenu = [CCMenu menuWithItems: pauseButton, nil];
        [menuLayer addChild:pauseMenu];
        
        [self schedule:@selector(update:)];
        
	}
	return self;
}

-(void)pause:(id)sender{
    if(pauseScreenActive ==FALSE){
        pauseScreenActive=TRUE;
        //if you have music uncomment the line bellow
        //[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        [[CCDirector sharedDirector] pause];
        CGSize s = [[CCDirector sharedDirector] winSize];
        pauseLayer = [CCLayerColor layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
        pauseLayer.position = CGPointZero;
        [self addChild: pauseLayer z:8];
        
        pauseScreen =[[CCSprite spriteWithFile:@"pauseButton.png"] retain];
        pauseScreen.position= ccp(130, 240);
        pauseScreen.rotation = -90;
        [self addChild:pauseScreen z:8];
        
        CCMenuItem *resume = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resumeSelect.png" target:self selector:@selector(ResumeButtonTapped:)];
        resume.position = ccp(250, 190);
        pauseScreenMenu = [CCMenu menuWithItems:resume, nil];
        pauseScreenMenu.position = ccp(0,-90);
        pauseScreenMenu.rotation = -90;
        [self addChild:pauseScreenMenu z:10];
    }
}

-(void)ResumeButtonTapped:(id)sender{
    [self removeChild:pauseScreen cleanup:YES];
    [self removeChild:pauseScreenMenu cleanup:YES];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    pauseScreenActive=FALSE;
}

/*
- (void) pause:(id)sender{
    gameOver = YES;
    CCMenu *menu;
    
    CCLabelTTF *pauseLabel = [[CCLabelTTF alloc] initWithString:@"Paused" fontName:@"Marker Felt" fontSize:40];
    pauseLabel.position = ccp(130, 240);
    pauseLabel.rotation = -90;
    
  
    //CCMoveBy *slideIn = [[CCMoveBy alloc] initWithDuration:1.0 position:ccp(0, 240)];
    CCMenuItemImage *replay = [[CCMenuItemImage alloc] initWithNormalImage:@"resume.png" selectedImage:@"resumeSelect.png" disabledImage:@"resume.png" block:^(id sender) {
        gameOver = NO;
        pauseLabel.visible = NO;
        //menu.visible = NO;
       // [menu setEnabled:NO];
        
    }];
    replay.rotation = -90;
    
    NSArray *menuItems = [NSArray arrayWithObject:replay];
    menu = [[CCMenu alloc] initWithArray:menuItems];
    menu.position = ccp(210,240);
    
    
    [self addChild:pauseLabel];
    [self addChild:menu];
    
}
 */

- (void) timeUpdate:(id)sender{ //Created a method to update the timer by seconds
    if(counter % 60 == 0)
        time--;
    counter++;
}

-(void)update:(ccTime)dt {
    [player update:dt];
    
    if(!gameOver){
        if(player.position.x > (previousPos + 1)){
            score ++;
            previousPos = player.position.x;
            
        }
        [self timeUpdate:player];
    }
    NSString *scoreString = [NSString stringWithFormat:@"%i",score];
    [scoreLabel setString:scoreString];
    
    //Comment
    
    NSString *timeString = [NSString stringWithFormat:@"%i",time];
    [timeLabel setString:timeString];
    
    [self powerUpCollision:player];
    [self handleHazardCollisions:player];
    [self checkForWin];
    [self checkForAndResolveCollisions:player];
    [self setViewpointCenter:player.position];
}


- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    float x = floor(position.x / map.tileSize.width);
    float height = map.mapSize.height * map.tileSize.height;
    float y = floor((height - position.y) / map.tileSize.height);
    return ccp(x, y);
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords
{
    float height = map.mapSize.height * map.tileSize.height;
    CGPoint point = ccp(tileCoords.x * map.tileSize.width, height - ((tileCoords.y + 1) * map.tileSize.height));
    return CGRectMake(point.x, point.y, map.tileSize.width, map.tileSize.height);
}

-(NSArray *)getSurroundingTilesAtPosition:(CGPoint)position forLayer:(CCTMXLayer *)layer {
    
    CGPoint plPos = [self tileCoordForPosition:position];
    NSMutableArray *gids = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        int c = i % 3;
        int r = (int)(i / 3);
        CGPoint pos = ccp(plPos.x + (c - 1), plPos.y + (r - 1));
        //Hole
        if (pos.y > (map.mapSize.height - 1)) {
            [self gameOver:0];
            return nil;
        }
        int tgid = [layer tileGIDAt:pos];
        CGRect rect = [self tileRectFromTileCoords:pos];
        NSDictionary *tileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:tgid], @"gid",
                                  [NSNumber numberWithFloat:rect.origin.x], @"x",
                                  [NSNumber numberWithFloat:rect.origin.y], @"y",
                                  [NSValue valueWithCGPoint:pos],@"tilePos",
                                  nil];
        [gids addObject:tileDict];
    }
    [gids removeObjectAtIndex:4];
    [gids insertObject:[gids objectAtIndex:2] atIndex:6];
    [gids removeObjectAtIndex:2];
    [gids exchangeObjectAtIndex:4 withObjectAtIndex:6];
    [gids exchangeObjectAtIndex:0 withObjectAtIndex:4];
    
    return (NSArray *)gids;
}

-(void)checkForAndResolveCollisions:(Player *)p {
    if (gameOver) {
        return;
    }
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:walls ]; //1
    p.ground = NO;
    for (NSDictionary *dic in tiles){
        CGRect pRect = [p collBox];
        int gid = [[dic objectForKey:@"gid"] intValue];
        if (gid){
            CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width, map.tileSize.height); //5
            if (CGRectIntersectsRect(pRect, tileRect)){
                CGRect intersection = CGRectIntersection(pRect, tileRect);
                int tileIndx = [tiles indexOfObject:dic];
                if (tileIndx == 0){
                    p.desiredPos = ccp(p.desiredPos.x, p.desiredPos.y + intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                    p.ground = YES;
                }else if (tileIndx == 1){
                    p.desiredPos = ccp(p.desiredPos.x, p.desiredPos.y - intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                }else if (tileIndx == 2){
                    p.desiredPos = ccp(p.desiredPos.x + intersection.size.width, p.desiredPos.y);
                }else if (tileIndx == 3){
                    p.desiredPos = ccp(p.desiredPos.x - intersection.size.width, p.desiredPos.y);
                }else{
                    if (intersection.size.width > intersection.size.height) {
                        p.velocity = ccp(p.velocity.x, 0.0);
                        float resolutionHeight;
                        if (tileIndx > 5) {
                            resolutionHeight = intersection.size.height;
                            p.ground = YES;
                        }else{
                            resolutionHeight = -intersection.size.height;
                        }
                        p.desiredPos = ccp(p.desiredPos.x, p.desiredPos.y + resolutionHeight);
                    }else{
                        float resolutionWidth;
                        if (tileIndx == 6 || tileIndx == 4){
                            resolutionWidth = intersection.size.width;
                        }else{
                            resolutionWidth = -intersection.size.width;
                        }
                        p.desiredPos = ccp(p.desiredPos.x + resolutionWidth, p.desiredPos.y);
                    }
                }
            }
        }
    }
    p.position = p.desiredPos;
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
        
        player.jump = NO;
        
        if (touchLocation.y < 200 && touchLocation.y >200) {
            //    player.jump = YES;
        }
        if (touchLocation.y > 240 && touchLocation.x > 200) {
            player.forward = YES;
        }
        if(touchLocation.y < 240 && touchLocation.x > 200){
            player.backward = YES;
        }
        if(touchLocation.x > 200){
            firstTouch = touchLocation;
        }
        firstTouch = touchLocation;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches){
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
        CGPoint previousTouchLocation = [t previousLocationInView:[t view]];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        previousTouchLocation = ccp(previousTouchLocation.x, screenSize.height - previousTouchLocation.y);
        
        float swipeLength = ccpDistance((firstTouch), touchLocation);
        if (firstTouch.x > touchLocation.x && swipeLength > 60) {
            player.jump = YES;
        } else if (firstTouch.x < touchLocation.x && swipeLength > 60){
            player.jump = YES;
        } else {
            player.jump = NO;
        }
        
        if (touchLocation.x < 200 && previousTouchLocation.y <= 240){
            player.forward = NO;
            //player.jump = YES;
        }else if (previousTouchLocation.x < 200 && touchLocation.y <=240){
            player.forward = YES;
            //  player.jump = NO;
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches){
        CGPoint touchLocation = [self convertTouchToNodeSpace:t];
    }
    player.forward = NO;
    player.backward = NO;
    player.jump = NO;
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int y = MAX(position.y, winSize.height / 2);
    int x = MAX(position.x, winSize.width / 2);
    x = MIN(x, (map.mapSize.width * map.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (map.mapSize.height * map.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(y, x);
    
    CGPoint centerOfView = ccp(80,winSize.height/2);
    //CGPoint viewPoint = ccpSub(actualPosition, centerOfView);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    map.position = viewPoint;
}

-(void)handleHazardCollisions:(Player *)p {
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:hazards ];
    for (NSDictionary *dic in tiles){
        CGRect rect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width, map.tileSize.height);
        CGRect pRect = [p collBox];
        if ([[dic objectForKey:@"gid"] intValue] && CGRectIntersectsRect(pRect, rect)){
            [self gameOver:0];
        }
    }
}

-(void)powerUpCollision:(Player *)p{
    if (gameOver) {
        return;
    }
    
    
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:powerUp ]; //1
    p.ground = NO;
    for (NSDictionary *dic in tiles){
        CGRect pRect = [p collBox];
        int gid = [[dic objectForKey:@"gid"] intValue];
        if (gid){
            
            int temp = floor(player.position.x/map.tileSize.width);
            NSLog(@"%i", temp);

            int x = 0;
            BOOL test = NO;
            for(x = 0; x < 1000;x++){
                if(usedPower[x] == temp){
                    test = YES;
                }
            }
            if(test == NO){
                usedPower[powerCount] = temp;
                powerCount++;
                
                usedPower[powerCount] = temp-1;
                powerCount++;
                
                usedPower[powerCount] = temp-2;
                powerCount++;
                
                usedPower[powerCount] = temp+1;
                powerCount++;
                
                usedPower[powerCount] = temp+2;
                powerCount++;
                
                
                score += 1000;

            }
            test = YES;
            
            
            
            CGRect tileRect = CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width, map.tileSize.height); //5
            if (CGRectIntersectsRect(pRect, tileRect)){
                CGRect intersection = CGRectIntersection(pRect, tileRect);
                int tileIndx = [tiles indexOfObject:dic];
                if (tileIndx == 0){
                    p.desiredPos = ccp(p.desiredPos.x, p.desiredPos.y + intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                    p.ground = YES;
                }else if (tileIndx == 1){
                    p.desiredPos = ccp(p.desiredPos.x, p.desiredPos.y - intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                }else if (tileIndx == 2){
                    p.desiredPos = ccp(p.desiredPos.x + intersection.size.width, p.desiredPos.y);
                }else if (tileIndx == 3){
                    p.desiredPos = ccp(p.desiredPos.x - intersection.size.width, p.desiredPos.y);
                }else{
                    if (intersection.size.width > intersection.size.height) {
                        p.velocity = ccp(p.velocity.x, 0.0);
                        float resolutionHeight;
                        if (tileIndx > 5) {
                            resolutionHeight = intersection.size.height;
                            p.ground = YES;
                        }else{
                            resolutionHeight = -intersection.size.height;
                        }
                        p.desiredPos = ccp(p.desiredPos.x, p.desiredPos.y + resolutionHeight);
                    }else{
                        float resolutionWidth;
                        if (tileIndx == 6 || tileIndx == 4){
                            resolutionWidth = intersection.size.width;
                        }else{
                            resolutionWidth = -intersection.size.width;
                        }
                        p.desiredPos = ccp(p.desiredPos.x + resolutionWidth, p.desiredPos.y);
                    }
                }
            }
        }
    }
    p.position = p.desiredPos;
    
    
    
}


-(void)nextLevelPressed:(id)sender{

    level = @"test2.tmx";;

    [self removeChild:winScreen cleanup:YES];
    [self removeChild:winScreenMenu cleanup:YES];
    [self removeChild:winLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    winScreenActive=FALSE;
    [self newGame];
}


-(void)mainMenuPressed:(id)sender{
    level =  @"levelOne.tmx";

    [self removeChild:winScreen cleanup:YES];
    [self removeChild:winScreenMenu cleanup:YES];
    [self removeChild:winLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    winScreenActive=FALSE;
    [self mainMenu];
    
}

-(void)diedMenu:(id)sender{
    [self removeChild:retryScreen cleanup:YES];
    [self removeChild:retryScreenMenu cleanup:YES];
    [self removeChild:retryLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    retryScreenActive=FALSE;
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene:(lives-1) withLevel:level]];
    
}

-(void)mainMenu{
     level =  @"levelOne.tmx";
    NSLog(@"main menu pressed");
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];

}
-(void)newGame{
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene:(lives) withLevel:level]];
}
-(void)gameOver:(BOOL)won {
	gameOver = YES;

	NSString *gameText;
    NSString *winText = @"You Are A Man!"; 
    
	if (won) {
        gameText = winText;
	} else {
		gameText = @"You have Died!";
	}
    
    if(!won){
        if((lives) == 0){
            [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
            [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
        }else{
            
            
            
            retryScreenActive = YES;
            //if you have music uncomment the line bellow
            [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
            //[[CCDirector sharedDirector] pause];
            CGSize s = [[CCDirector sharedDirector] winSize];
            retryLayer = [CCLayerColor layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
            retryLayer.position = CGPointZero;
            [self addChild: retryLayer z:8];
            
            retryScreen =[[CCSprite spriteWithFile:@"dirtrock.png"] retain];
            retryScreen.position= ccp(130, 240);
            retryScreen.rotation = -90;
            [self addChild:retryScreen z:8];
            
            CCMenuItem *retry = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resumeSelect.png" target:self selector:@selector(diedMenu:)];
            retry.position = ccp(250, 190);
            retryScreenMenu = [CCMenu menuWithItems:retry, nil];
            retryScreenMenu.position = ccp(0,-90);
            retryScreenMenu.rotation = -90;
            [self addChild:retryScreenMenu z:10];
            

        }

    }
    if(won && level ==  @"levelOne.tmx"){
        if(winScreenActive == NO){

            
            
            winScreenActive = YES;
            //if you have music uncomment the line bellow
            [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
            //[[CCDirector sharedDirector] pause];
            CGSize s = [[CCDirector sharedDirector] winSize];
            winLayer = [CCLayerColor layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
            winLayer.position = CGPointZero;
            [self addChild: winLayer z:8];

            winScreen =[[CCSprite spriteWithFile:@"dirtrock.png"] retain];
            winScreen.position= ccp(130, 240);
            winScreen.rotation = -90;
            [self addChild:winScreen z:8];
                    
            CCMenuItem *nextLevel = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resumeSelect.png" target:self selector:@selector(nextLevelPressed:)];
            nextLevel.position = ccp(250, 190);
            winScreenMenu = [CCMenu menuWithItems:nextLevel, nil];
            winScreenMenu.position = ccp(0,-90);
            winScreenMenu.rotation = -90;
            [self addChild:winScreenMenu z:10];

        }
     
        
    }else if(gameText != @"You have Died!" && level == @"test2.tmx"){
        if(rScreenActive == NO){
            rScreenActive = YES;
            NSLog(@"dslfjhsdfhdskflhsdflksjhdflksdjhfsldkjhfsdlkfjhsdlfkhjsdlfkhjsdflkjsdhflksjhdflskjdhflskjdhf");
            //if you have music uncomment the line bellow
            [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
            //[[CCDirector sharedDirector] pause];
            CGSize s = [[CCDirector sharedDirector] winSize];
            rLayer = [CCLayerColor layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
            rLayer.position = CGPointZero;
            [self addChild: rLayer z:8];
            
            rScreen =[[CCSprite spriteWithFile:@"dirtrock.png"] retain];
            rScreen.position= ccp(130, 240);
            rScreen.rotation = -90;
            [self addChild:rScreen z:8];
            
            CCMenuItem *main = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resumeSelect.png" target:self selector:@selector(mainMenuPressed:)];
            main.position = ccp(250, 190);
            rScreenMenu = [CCMenu menuWithItems:main, nil];
            rScreenMenu.position = ccp(0,-90);
            rScreenMenu.rotation = -90;
            [self addChild:rScreenMenu z:10];
            
        }
    }

    
    
    
    
    
    /*
    
    
    if( (lives != 0) && (gameText == winText) ){
        
        //level = @"theLevel1.tmx";
        
        CCLabelTTF *diedLabel = [[CCLabelTTF alloc] initWithString:gameText fontName:@"Marker Felt" fontSize:40];
        diedLabel.position = ccp(130, 240);
        diedLabel.rotation = -90;
        
        NSString *scoreString = [NSString stringWithFormat:@"Your score is %i",score];
        CCLabelTTF *endScore = [[CCLabelTTF alloc] initWithString:scoreString fontName:@"Marker Felt" fontSize:20];
        endScore.position = ccp(160, 240);
        endScore.rotation = -90;
        
        //CCMoveBy *slideIn = [[CCMoveBy alloc] initWithDuration:1.0 position:ccp(0, 240)];
        CCMenuItemImage *replay = [[CCMenuItemImage alloc] initWithNormalImage:@"retry.png" selectedImage:@"retrySelected.png" disabledImage:@"retry.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[GameLayer scene:(lives-1) withLevel:level]];
        }];
        replay.rotation = -90;
        
        NSArray *menuItems = [NSArray arrayWithObject:replay];
        CCMenu *menu = [[CCMenu alloc] initWithArray:menuItems];
        menu.position = ccp(210,240);
        
        //[self addChild:menu];
        [self addChild:diedLabel];
        [self addChild:endScore];
        [self addChild:menu];
        
    }else if((gameText == @"You Are A Man!") && (level ==  @"levelOne.tmx")){
        level = @"test2.tmx";
        
        CCLabelTTF *diedLabel = [[CCLabelTTF alloc] initWithString:gameText fontName:@"Marker Felt" fontSize:40];
        diedLabel.position = ccp(130, 240);
        diedLabel.rotation = -90;
        
        NSString *scoreString = [NSString stringWithFormat:@"Your score is %i",score];
        CCLabelTTF *endScore = [[CCLabelTTF alloc] initWithString:scoreString fontName:@"Marker Felt" fontSize:20];
        endScore.position = ccp(160, 240);
        endScore.rotation = -90;
        
        //CCMoveBy *slideIn = [[CCMoveBy alloc] initWithDuration:1.0 position:ccp(0, 240)];
        CCMenuItemImage *replay = [[CCMenuItemImage alloc] initWithNormalImage:@"main.png" selectedImage:@"mainSelect.png" disabledImage:@"replay.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];

            //  [[CCDirector sharedDirector] replaceScene:[GameLayer scene:(lives-1) withLevel:level]];
        }];
        replay.rotation = -90;
        
        NSArray *menuItems = [NSArray arrayWithObject:replay];
        CCMenu *menu = [[CCMenu alloc] initWithArray:menuItems];
        menu.position = ccp(210,240);
        
        //[self addChild:menu];
        [self addChild:diedLabel];
        [self addChild:endScore];
        [self addChild:menu];
        
    }else if(lives == 0){
        
        level = @"levelOne.tmx";
        CCLabelTTF *diedLabel = [[CCLabelTTF alloc] initWithString:gameText fontName:@"Marker Felt" fontSize:40];
        diedLabel.position = ccp(130, 240);
        diedLabel.rotation = -90;
        
        NSString *scoreString = [NSString stringWithFormat:@"Your score is %i",score];
        CCLabelTTF *endScore = [[CCLabelTTF alloc] initWithString:scoreString fontName:@"Marker Felt" fontSize:20];
        endScore.position = ccp(160, 240);
        endScore.rotation = -90;
        
        //CCMoveBy *slideIn = [[CCMoveBy alloc] initWithDuration:1.0 position:ccp(0, 240)];
        CCMenuItemImage *replay = [[CCMenuItemImage alloc] initWithNormalImage:@"main.png" selectedImage:@"mainSelect.png" disabledImage:@"replay.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
        }];
        replay.rotation = -90;
        
        NSArray *menuItems = [NSArray arrayWithObject:replay];
        CCMenu *menu = [[CCMenu alloc] initWithArray:menuItems];
        menu.position = ccp(210,240);
        
        //[self addChild:menu];
        [self addChild:diedLabel];
        [self addChild:endScore];
        [self addChild:menu];
    }
    
    */    
    //[menu runAction:slideIn];
}


-(void)checkForWin {
    //373.0*16
    if (player.position.x > 350) {
        [self gameOver:1];
    }
}




@end
