//
//  ScoreCell.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 20..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ScoreCell.h"
#import "DBPersonnalRecordManager.h"
@interface ScoreCell()
@property (weak,nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *handyImageView;


@end


@implementation ScoreCell{
    DBPersonnalRecordManager *dbManager;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.rowIdx  = 0;
        dbManager = [DBPersonnalRecordManager sharedModeManager];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        dbManager = [DBPersonnalRecordManager sharedModeManager];
    }
    return  self;
}
- (void)setValueWithRowIDX:(NSInteger)inRowIDX withscore:(NSString *)inScore withHandy:(BOOL)inHandy withColor:(UIColor *)inColor{
    self.rowIdx = inRowIDX;
    
    if(inHandy){
        [ self.handyImageView setHidden:NO];
    }else{
        [ self.handyImageView setHidden:YES];
    }
    
    
     self.scoreLabel.text = inScore;
    
    self.backgroundColor = inColor;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 0.5;
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.firstOtherButtonIndex){
        // delete 시킴!
        [dbManager deleteDateWithRowID:self.rowIdx];
        [self setHidden:YES];
    }
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
