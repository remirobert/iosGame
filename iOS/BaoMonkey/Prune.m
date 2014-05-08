//
//  Prune.m
//  iosGame
//
//  Created by iPPLE on 06/05/2014.
//  Copyright (c) 2014 iPPLE. All rights reserved.
//

#import "Prune.h"

@implementation Prune

- (instancetype) initWithPosition:(CGPoint)position {
    if ((self = [super initWithPosition:position]) != nil) {
        [self.node setTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"prune"]]];
        self.action = @selector(actionPrune);
        self.node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.node.size.width / 3];
        self.node.physicsBody.mass = 10.0;
    }
    return (self);
}

- (void) actionPrune {
    SKAction *move = [SKAction moveTo:CGPointMake(self.node.position.x, 200) duration:0];
    SKAction *sound = [SKAction playSoundFileNamed:@"splash.mp3" waitForCompletion:NO];
    SKAction *action = [SKAction resizeToWidth:640 height:512 duration:0.2];
    SKAction *wait = [SKAction waitForDuration:1.0];
    
    [self.timerHide invalidate];
    self.timerHide = nil;
    self.isTaken = YES;
    self.node.physicsBody = nil;
    
    SKAction *actionPrune = [SKAction group:@[move, sound, action, wait]];
    
    [self.node setTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"splash-prune"]]];
    
    self.node.zPosition = 10000;
    
    [self.node runAction:actionPrune completion:^{
        self.isOver = YES;
        [self.node removeFromParent];
    }];
}

@end
