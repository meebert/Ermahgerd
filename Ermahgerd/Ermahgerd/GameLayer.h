//
//  GameLayer.h
//  Ermahgerd
//
//  Created by Mitchell Hebert on 3/5/13.
//
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer {
    
}

+(CCScene *) scene:(int)numLives withLevel:(NSString *)theLevel;

@end
