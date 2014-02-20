//
//  CalendarViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "CalendarView.h"
#import "DBPersonnalRecordManager.h"
#import "CalendarDateCell.h"
#import "CalendarDayCell.h"
#import "RecordViewController.h"

#define NUMBER_FONT @"Roboto-Medium"

@interface CalendarView ()<UICollectionViewDataSource>{
    NSInteger year;
    NSInteger month;
    NSInteger startDate;
    NSInteger clickedDate;
}

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end

@implementation CalendarView{
    DBPersonnalRecordManager *dbPRManager;
    MonthScore *nowMonthScoreData;
    UIButton *beforeClicked;
}



- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        NSLog(@"Calendar init with coder");
        year = 2014;
        month = 1;
        
        [self setYear:year setMonth:month];
        
        [self.collection reloadData];
        self.monthLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:25.0];
        clickedDate = 0;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        year = 2014;
        month = 1;
        
        [self setYear:year setMonth:month];
        [self.collection reloadData];
        self.monthLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:25.0];
        clickedDate = 0;
        
    }
    return  self;
}


// bar에 년도와 요일 표시하는 부분의 글씨 편집하는 함수.
- (void)setYear:(NSInteger)inYear setMonth:(NSInteger)inMonth{
    // 새로 1일의 시작 날자 설정
 //   NSLog(@"year : %d month : %d",(int)year,(int)month );
    year = inYear;
    month = inMonth;
    startDate = [self calculateDayWithYear:year withMonth:month withDate:1];
    //  startDate++;
    startDate %= 7;
 //   NSLog(@"%d - %d - %d ",(int)year,(int)month, (int)startDate);
    
    self.yearLabel.text = [NSString stringWithFormat:@"%d",(int)year];
    self.monthLabel.text = [NSString stringWithFormat:@"%02d",(int)month];
    
    // 폰트 변경하기
    // TODO
    
    [self setCalendarSetting];
  
    
}
// 달력 한번 호출될때 필요한거 달력 다시 그릴때마다 호출되면서 바뀌어야될것들 하는 함수
- (void)setCalendarSetting{
    // DB에서 해당 월의 정보 얻어옴
    // TODO
    if(dbPRManager == nil){
        dbPRManager = [DBPersonnalRecordManager sharedModeManager];
    }
    nowMonthScoreData = [dbPRManager showDataWithMonth:month withYear:year];
    
    //NSLog(@"Month test : %@",nowMonthScoreData);
    
    [self.collection reloadData];
    
    if((clickedDate != 0)){
        NSLog(@"%d",clickedDate);
        
        NSInteger averageScore = [nowMonthScoreData getDailyAverageScoreWithDate:[NSString stringWithFormat:@"%d",clickedDate]];
        NSInteger highScore = [nowMonthScoreData getDailyHighScoreWithDate:[NSString stringWithFormat:@"%d",clickedDate]];
        NSInteger lowScore = [nowMonthScoreData getDailyLowScoreWithDate:[NSString stringWithFormat:@"%d",clickedDate]];
        NSInteger gameCnt = [nowMonthScoreData getDailyGameCnt:[NSString stringWithFormat:@"%d",clickedDate]];
    [self.recordVC drawBarchartWithAverageScore:averageScore withHighScore:highScore withLowScore:lowScore withGameCnt:gameCnt isMonthly:FALSE];
        NSLog(@"ha?");
    }else{
        [self drawMonthly];
    }
}

- (void)drawMonthly{
    
    [self.recordVC setYear:year withMonth:month withDate:1];
    
    // Bar chart의 위치 설정
    NSInteger averageScore = [nowMonthScoreData getMonthlyAverageScore];
    NSInteger highScore = [nowMonthScoreData getMonthlyHighScore];
    NSInteger lowScore = [nowMonthScoreData getMonthlyLowScore];
    NSInteger gameCnt = [nowMonthScoreData getMonthlyGameCnt];
    // 이건 low는 초기값이 300인거때문에... 발생하는 오류 잡으려고 해둔거
    if(highScore < lowScore){
        lowScore = 0;
    }
    [self.recordVC drawBarchartWithAverageScore:averageScore withHighScore:highScore withLowScore:lowScore withGameCnt:gameCnt isMonthly:TRUE];
}

// 요일을 리턴해주는 함수
// 0 : 일요일 1 : 월요일 2 : 화요일 3: 수요일 4:목요일 5:금요일 6 :토요일
- (NSInteger)calculateDayWithYear:(NSInteger)inYear withMonth:(NSInteger)inMonth withDate:(NSInteger)inDate{
    if (inMonth <= 2){
        --inYear;
        inMonth += 12;
    }
    
    NSInteger resultDay = ( (21*((int)inYear/100)/4) + (5*((int)inYear%100)/4) + (26*((int)inMonth+1)/10) + (int)inDate - 1 ) % 7;
    return resultDay;
}


// 달력 내부에 요일부분 버튼 누른경우
- (IBAction)clickedButton:(id)sender {
    
    beforeClicked.backgroundColor = [UIColor clearColor];
    beforeClicked = (UIButton *)sender;
    beforeClicked.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    
    
    UIButton *tmp = [UIButton alloc];
    tmp = sender;
    NSString *tmpString = [NSString alloc];
    tmpString = [tmp.superview.subviews[1] text];
    NSInteger clickedDate = [tmpString integerValue];
    [self calculateDayWithYear:year withMonth:month withDate:clickedDate];
//    NSLog(@"day is %@",tmpString);
    
    //해당일에 대한 정보 얻어오기
    NSString *clickedDateStr = [NSString stringWithFormat:@"%02d",(int)clickedDate];
    NSInteger highScore = [nowMonthScoreData getDailyHighScoreWithDate:clickedDateStr];
    NSInteger lowScore = [nowMonthScoreData getDailyLowScoreWithDate:clickedDateStr];
    NSInteger averageScore = [nowMonthScoreData getDailyAverageScoreWithDate:clickedDateStr];
    NSInteger gameCnt = [nowMonthScoreData getDailyGameCnt:clickedDateStr];
    [self.recordVC setYear:year withMonth:month withDate:clickedDate];
    
    [self.recordVC drawBarchartWithAverageScore:averageScore withHighScore:highScore withLowScore:lowScore withGameCnt:gameCnt isMonthly:FALSE];
    
    
}


// 이전 달로 이동하는 버튼 누른 경우
- (IBAction)clickedBeforeButton:(id)sender {
    month--;
    if(month == 0){
        year--;
        month = 12;
    }
    
    
    [self setYear:year setMonth:month];
    [self drawMonthly];
    [self.recordVC setYear:year withMonth:month withDate:1];
    [self.collection reloadData];
    
}

// 이 다음 달로 이동하는 버튼 누른 경우
- (IBAction)clickedAfterButton:(id)sender {
    month++;
    if(month == 13){
        year++;
        month = 1;
    }
    [self setYear:year setMonth:month];
    [self drawMonthly];
    [self.recordVC setYear:year withMonth:month withDate:1];
    [self.collection reloadData];
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if((int)indexPath.row < 7){
        // 요일 이름 적을 부분
        CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DAY_CELL" forIndexPath:indexPath];
        [cell setValueWithDay:indexPath.row];
        return cell;
    }
    else{
        
        NSInteger writeDate = indexPath.row - 6 - startDate;
        NSString *writeDateStr = [NSString alloc];
        
       
        // 일단 달력 윗줄에 빈공간 계산하기
        if((writeDate <= 0) || (writeDate > 31)){
            // 여기는 빈공간
            // 달력의 위 공간이나 혹시 모를 아래 공간...
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EMPTY_CELL" forIndexPath:indexPath];
            
            writeDateStr = @" ";
            return cell;
        }
        else{
            CalendarDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DATE_CELL" forIndexPath:indexPath];
            writeDateStr = [NSString stringWithFormat:@"%d",(int)writeDate];
            
            
            //dateLabel.font = [UIFont fontWithName:NUMBER_FONT size:20];
        
            if ([writeDateStr isEqualToString:[NSString stringWithFormat:@"%d",clickedDate]]){
                [cell setValueWithDate:writeDateStr withClicked:YES withDay:(indexPath.row % 7)];
                beforeClicked = cell.backgroundButton;
            }else{
                [cell setValueWithDate:writeDateStr withClicked:NO withDay:(indexPath.row % 7)];
            }
            
            NSMutableDictionary *oneDay = nowMonthScoreData.days[[NSString stringWithFormat:@"%02d",(int)writeDate]];
            if(oneDay != nil){
                [cell hasData];
                
            }else{
                [cell noData];
            }
            
            return cell;
        }
        
        return  nil;
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSLog(@"draw collectionView %d %d",year, month);
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12 )){
        return 7 + startDate + 31;
    }
    else if(month == 2){
        if(((year % 4) == 0) && ((year % 100 ) != 0) ){
            return 7 + startDate + 29;
        }
        else{
            return 7 + startDate + 28;
        }
    }
    else {
        return 7 + startDate + 30;
    }
    return 0;
}




@end
