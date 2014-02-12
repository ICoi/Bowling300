//
//  CalendarViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "CalendarViewController.h"
#import "DBPersonnalRecordManager.h"
#define DAY_CELL_TAG_NUM 21             // 요일 적는 부분 태그
#define DATE_CELL_TAG_NUM 22            // 날짜 적는 부분 태그

#define NUMBER_FONT @"Roboto-Medium"

@interface CalendarViewController ()<UICollectionViewDataSource>{
    NSInteger year;
    NSInteger month;
    NSInteger startDate;
}

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end

@implementation CalendarViewController{
    DBPersonnalRecordManager *dbPRManager;
    MonthScore *nowMonthScoreData;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    year = 2014;
    month = 1;
    [self setYear:year setMonth:month];
    
    
    // 돋보기 기능을 위한 Notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvCalNoti:) name:@"CalendarSearchNoti" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [self setCalendarSetting];
}



// notification

- (void)recvCalNoti:(NSNotification*)notification{
    if ([[notification name] isEqualToString:@"CalendarSearchNoti"]){
        NSDictionary *userInfo = notification.userInfo;
        NSString *tmpYear = [userInfo objectForKey:@"year"];
        NSString *tmpMonth = [userInfo objectForKey:@"month"];
        
        NSInteger setYear;
        NSInteger setMonth;
        if( tmpYear != nil) {
//            NSLog(@"yearyear %@",tmpYear);
            setYear = [tmpYear integerValue];
        }else{
            setYear = year;
        }
        if( tmpMonth != nil){
//            NSLog(@"monthmonth %@",tmpMonth);
            setMonth = [tmpMonth integerValue];
        }else{
            setMonth = month;
        }
        
        [self setYear:setYear setMonth:setMonth];
        [self.collection reloadData];
    }
}


// 해당 숫자에 맞는 요일을 리턴해주는 함수
// 0 : 일요일 1: 월요일 2: 화요일 3: 수요일 4: 목요일 5: 금요일 6: 토요일
- (NSString *)showDayString:(NSInteger)inNum{
    NSString *tmpString = [NSString stringWithFormat:@""];
    switch ((int)inNum) {
        case 0:
            tmpString = [tmpString stringByAppendingString:@"S"];
            break;
        case 1:
            tmpString = [tmpString stringByAppendingString:@"M"];
            break;
        case 2:
            tmpString = [tmpString stringByAppendingString:@"T"];
            break;
        case 3:
            tmpString = [tmpString stringByAppendingString:@"W"];
            break;
        case 4:
            tmpString = [tmpString stringByAppendingString:@"T"];
            break;
        case 5:
            tmpString = [tmpString stringByAppendingString:@"F"];
            break;
        case 6:
            tmpString = [tmpString stringByAppendingString:@"S"];
            break;
        default:
            break;
    }
    return tmpString;
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
    self.yearLabel.font = [UIFont fontWithName:NUMBER_FONT size:self.yearLabel.font.pointSize];
    self.monthLabel.font = [UIFont fontWithName:NUMBER_FONT size:self.monthLabel.font.pointSize];
    
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
    
    // Bar chart의 위치 설정
    // Notification을 보냅니다. -> 월 데이터에 따른걸로
    NSInteger averageScore = [nowMonthScoreData getMonthlyAverageScore];
    NSInteger highScore = [nowMonthScoreData getMonthlyHighScore];
    NSInteger lowScore = [nowMonthScoreData getMonthlyLowScore];
    
    // 이건 low는 초기값이 300인거때문에... 발생하는 오류 잡으려고 해둔거
    if(highScore < lowScore){
        lowScore = 0;
    }
    
    NSDictionary *sendDic = @{@"type":@"Monthly", @"averageScore":[NSString stringWithFormat:@"%d",(int)averageScore],
                              @"highScore":[NSString stringWithFormat:@"%d",(int)highScore],
                              @"lowScore":[NSString stringWithFormat:@"%d",(int)lowScore]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"BarChartNoti"
     object:nil userInfo:sendDic];
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
    UIButton *tmp = [UIButton alloc];
    tmp = sender;
    NSString *tmpString = [NSString alloc];
    tmpString = [tmp.superview.subviews[1] text];
    NSInteger clickedDate = [tmpString integerValue];
    [self calculateDayWithYear:year withMonth:month withDate:clickedDate];
//    NSLog(@"day is %@",tmpString);
    
    //해당일에 대한 정보 얻어오기
    //TODO
    NSString *clickedDateStr = [NSString stringWithFormat:@"%02d",(int)clickedDate];
    NSInteger highScore = [nowMonthScoreData getDailyHighScoreWithDate:clickedDateStr];
    NSInteger lowScore = [nowMonthScoreData getDailyLowScoreWithDate:clickedDateStr];
    NSInteger averageScore = [nowMonthScoreData getDailyAverageScoreWithDate:clickedDateStr];
    
    // Notification을 보냅니다. -> 일 데이터에 따른걸로
    NSDictionary *sendDic = @{@"type":@"Daily", @"averageScore":[NSString stringWithFormat:@"%d",(int)averageScore],
        @"highScore":[NSString stringWithFormat:@"%d",(int)highScore],
        @"lowScore":[NSString stringWithFormat:@"%d",(int)lowScore]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"BarChartNoti"
     object:nil userInfo:sendDic];
 //   NSLog(@"Send notification : %@",sendDic);
    
    // 이거 보다 큰 화면으로 요일 정보 보내는 noti
    NSDictionary *sendDateDic = @{@"year":[NSString stringWithFormat:@"%d",(int)year],
                              @"month":[NSString stringWithFormat:@"%d",(int)month],
                              @"date":[NSString stringWithFormat:@"%d",(int)clickedDate]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"DateNoti"
     object:nil userInfo:sendDateDic];
//    NSLog(@"Send notification : %@",sendDic);
    
}

/*
 [NSDictionary dictionaryWithObjectsAndKeys:
 [NSNumber numberWithInt:13], @"Mercedes-Benz SLK250",
 [NSNumber numberWithInt:22], @"Mercedes-Benz E350",
 [NSNumber numberWithInt:19], @"BMW M3 Coupe",
 [NSNumber numberWithInt:16], @"BMW X6", nil];
 */
// 이전 달로 이동하는 버튼 누른 경우
- (IBAction)clickedBeforeButton:(id)sender {
    month--;
    if(month == 0){
        year--;
        month = 12;
    }
    
    
    [self setYear:year setMonth:month];
    [self.collection reloadData];
    
    // 해당 월에 해당하는 Notification을 보냅니다.
    // TODO
}

// 이 다음 달로 이동하는 버튼 누른 경우
- (IBAction)clickedAfterButton:(id)sender {
    month++;
    if(month == 13){
        year++;
        month = 1;
    }
    [self setYear:year setMonth:month];
    [self.collection reloadData];
    
    
    // 해당 월에 해당하는 Notification을 보냅니다.
    // TODO
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if((int)indexPath.row < 7){
        // 요일 이름 적을 부분
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DAY_CELL" forIndexPath:indexPath];
        UILabel *dayLabel = (UILabel *)[cell viewWithTag:DAY_CELL_TAG_NUM];
        dayLabel.text = [self showDayString:indexPath.row];
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
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DATE_CELL" forIndexPath:indexPath];
            UILabel *dateLabel = (UILabel *)[cell viewWithTag:DATE_CELL_TAG_NUM];
            
            
            
            writeDateStr = [NSString stringWithFormat:@"%d",(int)writeDate];
            dateLabel.text = writeDateStr;
            
            // 폰트 바꾸기
            dateLabel.font = [UIFont fontWithName:NUMBER_FONT size:20];
            
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
