//
//  MyScene+GeneratorWave.h
//  iosGame
//
//  Created by iPPLE on 05/05/2014.
//  Copyright (c) 2014 iPPLE. All rights reserved.
//

#import "MyScene.h"
#import "Banana.h"
#import "CocoNuts.h"
#import "Prune.h"
#import "Shield.h"

@interface MyScene (GeneratorWave)

- (void) addNewWeapon:(CFTimeInterval)currentTime;
- (void) addNewWave:(CFTimeInterval)currentTime;
-(void)addBonus:(CFTimeInterval)currentTime;

@end
