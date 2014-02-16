//
//  WriteScoreView.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 16..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "WriteScoreView.h"

@implementation WriteScoreView{
    UILabel *scoreLabel;
    UIImageView *handyImageView;
    NSInteger rowIdx;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        rowIdx  = 0;
        
        UIImage *handyImage = [UIImage imageNamed:@"record_insert_handyicon.png"];
        
        handyImageView = [[UIImageView alloc]initWithImage:handyImage];
        handyImageView.frame = CGRectMake(30, 0, 30, 15);
        
        scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, 60, 30)];
        scoreLabel.text = @"000";
        scoreLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:handyImageView];
        [self addSubview:scoreLabel];
        
    }
    return self;
}

- (void)setValueWithRowIDX:(NSInteger)inRowIDX withscore:(NSString *)inScore withHandy:(BOOL)inHandy withColor:(UIColor *)inColor{
    rowIdx = inRowIDX;
    
    if(inHandy){
        [handyImageView setHidden:NO];
    }else{
        [handyImageView setHidden:YES];
    }
    
    
    scoreLabel.text = inScore;
    
    self.backgroundColor = inColor;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"score touch");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Do you want to delete this score?" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Delete", nil];
    
    [alert show];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
