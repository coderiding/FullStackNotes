小帮货车选时间遇到问题

问题描述：20201230选时间时，不能选明天

原因分析：代码中定义的获取endate字段，默认是当前天数加2，如果遇到30时，就会加成32，最后拼数据32得到nil，看下面代码

### 尝试方案1（不靠谱，时间算的不对）

```objectivec
+ (NSArray *)daysFromNowToDeadLine:(NSString *)deadLine
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMMdd"];
    
    NSDate *startDate = [f dateFromString:[self summaryTimeUsingDate:[NSDate date]]];
    NSDateComponents *curDate = [self dateComponents];

    NSString *month,*day;
    
    month = [NSString stringWithFormat:@"%ld",curDate.month];
    day = [NSString stringWithFormat:@"%ld",curDate.day+2];
    
    if (curDate.month<10) {
        // MX：给前面加0
        month = [NSString stringWithFormat:@"0%ld",curDate.month];
    }
    
    if (curDate.day+2<10) {
        day = [NSString stringWithFormat:@"0%ld",curDate.day+2];
    }
    
// MX：修复的代码块
    if (curDate.day+2 > 31) {
        day = [NSString stringWithFormat:@"%d",31];
    }
// MX：修复的代码块
    
    deadLine = [NSString stringWithFormat:@"%ld%@%@",curDate.year,month,day];
    NSDate *endDate = [f dateFromString:deadLine];
    NSLog(@"%@\n%@",deadLine,endDate);
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    NSInteger diffDays = components.day;
    if(diffDays==0) return @[[self summaryTimeUsingDate:[NSDate date]]];
    
    NSMutableArray *dayArray = [NSMutableArray array];
    if(diffDays > MAXCOUNTDAYS) diffDays = MAXCOUNTDAYS;
    
    for (int i = 0; i <= diffDays; i++) {
        NSTimeInterval  iDay = 24*60*60*i;  //1天的长度
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:iDay];
        [dayArray addObject:[self summaryTimeUsingDate:date]];
    }
    
    return dayArray;
}
```

### 尝试方案2

```objectivec
+(NSArray *)daysFromNowToDeadLine:(NSString *)deadLine{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMMdd"];
    NSDate *startDate = [f dateFromString:[self summaryTimeUsingDate:[NSDate date]]];
// MX:获取当前时间加多一天的Date，利用MarsTool里面的分类方法
    NSDate *endDate = [startDate dateByAddingDays:1];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    int diffDays = components.day;
    if(diffDays==0) return @[[self summaryTimeUsingDate:[NSDate date]]];
    NSMutableArray *dayArray = [NSMutableArray array];
    if(diffDays > MAXCOUNTDAYS) diffDays = MAXCOUNTDAYS;
    for (int i = 0; i <= diffDays; i++) {
        NSTimeInterval  iDay = 24*60*60*i;  //1天的长度
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:iDay];
        [dayArray addObject:[self summaryTimeUsingDate:date]];
    }
    return dayArray;
}
```