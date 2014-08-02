//
//  UGCalendarCollectionViewController.m
//  Uguru
//
//  Created by Samir Makhani on 7/27/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGCalendarCollectionViewController.h"
#import "UGModel.h"

@interface UGCalendarCollectionViewController ()

@end

@implementation UGCalendarCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.request.calendar.length_of_session = self.request.time_estimate;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"timeCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CGPoint cellCoords = [self getCellCoord:indexPath];
    
    if (cellCoords.x == 0) {
        identifier = @"timeCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = UIColorFromRGB(15658734);
        [self processCalendarDay:&cellCoords cellUILabel: (UILabel *)[cell.contentView viewWithTag:2]];
    } else if (cellCoords.y == 0) {
        identifier = @"dayCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = UIColorFromRGB(15658734);
        [self processCalendarTime:&cellCoords cellUILabel: (UILabel *)[cell.contentView viewWithTag:1]];
    }
    else {
        identifier = @"calendarCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if ([self cellSelectedPreviously:indexPath]) {
            if (self.tutor_accept_flag || self.student_accept_flag) {
                cell.backgroundColor = UIColorFromRGB(11917462);
            } else {
                cell.backgroundColor = UIColorFromRGB(6404685);
            }
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        if ([self cellSelectedPreviouslyByTutor:indexPath]) {
            cell.backgroundColor = UIColorFromRGB(6404685);
        }
        UIColor *lightGreyColor = UIColorFromRGB(15658734);
        [cell.contentView.layer setBorderColor:lightGreyColor.CGColor];
        [cell.contentView.layer setBorderWidth:1.0f];
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return -10; // This is the minimum inter item spacing, can be more
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return -1; // This is the minimum inter item spacing, can be more
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [self.navigationController.view bounds];
    screenRect.size.width = (screenRect.size.width / 7);
    screenRect.size.height = (screenRect.size.width / 24) * 11;
    return screenRect.size;
}

- (IBAction)sendAction:(id)sender {
    if (self.tutor_accept_flag) {
        if (self.request.calendar.num_hours_selected != [self.request.time_estimate intValue]) {
            [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                        message:[NSString stringWithFormat:@"Please select exactly %@ hours", self.request.time_estimate]
                                       delegate:nil
                              cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.student_accept_flag) {
            [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if (self.request.calendar.num_hours_selected < [self.request.time_estimate intValue]) {
            [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                        message:[NSString stringWithFormat:@"Please select at least %@ hours", self.request.time_estimate]
                                       delegate:nil
                              cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    UIColor *studentSelectedColor = UIColorFromRGB(11917462);
    UIColor *selectedColor = UIColorFromRGB(6404685);
    CGPoint cellCoords = [self getCellCoord:indexPath];
    
    NSLog(@"%li, %li", (long)indexPath.row, (long) indexPath.section);
    
    if ([cell.reuseIdentifier isEqual:@"calendarCell"]) {
        if (self.tutor_accept_flag) {
            if ([cell.backgroundColor isEqual:studentSelectedColor]) {
                cell.backgroundColor = UIColorFromRGB(6404685);
                [self formatCoordToUguruAPICalendarRange:&cellCoords];
                self.request.calendar.num_hours_selected++;
                return;
            }
            if ([cell.backgroundColor isEqual:selectedColor]) {
                cell.backgroundColor = studentSelectedColor;
                self.request.calendar.num_hours_selected--;
                return;
            }
            
        }
        //Student Accept --> VIEWING ONLY
        else if (self.student_accept_flag){
            return;
        }
        //Request Form Calendar
        else {
            if ([cell.backgroundColor isEqual:[UIColor whiteColor]] && !self.tutor_accept_flag) {
                cell.backgroundColor = UIColorFromRGB(6404685);
                self.request.calendar.num_hours_selected++;
                [self formatCoordToUguruAPICalendarRange:&cellCoords];
            } else {
                cell.backgroundColor = [UIColor whiteColor];
                self.request.calendar.num_hours_selected--;
            }
        }
    }
    
}

-(void)formatCoordToUguruAPICalendarRange: (CGPoint *)cellCoords {
    NSNumber *column = [NSNumber numberWithFloat: (cellCoords->y - 1)];
    NSNumber *row = [NSNumber numberWithFloat: (cellCoords->x - 1)];
    NSNumber *row_plus_one = [NSNumber numberWithFloat:(cellCoords->x)];
    NSMutableArray *time_range_day = nil;
    if (self.tutor_accept_flag) {
        time_range_day = [self.request.tutorCalendar.time_ranges objectAtIndex:[column intValue]];
    } else {
        time_range_day = [self.request.calendar.time_ranges objectAtIndex:[column intValue]];
    }
    [time_range_day addObject:[NSMutableArray arrayWithObjects: row, row_plus_one, nil]];
    NSLog(@"[%@, %@] added to Column %@", row, row_plus_one, column);
    
}

-(BOOL) isCalendarEmpty: (NSMutableArray *) time_ranges {
    for (int i = 0; i < 7; i++) {
        NSMutableArray *day_column_ranges = [time_ranges objectAtIndex:i];
        if ([day_column_ranges count] != 0) {
            return false;
        }
    }
    return true;
}

-(BOOL) cellSelectedPreviously: (NSIndexPath *) indexPath {
    if ([self isCalendarEmpty:self.request.calendar.time_ranges]) {
        return false;
    } else {
        for (int i = 0; i < [self.request.calendar.time_ranges count]; i++) {
            NSMutableArray *day_column_ranges = [self.request.calendar.time_ranges objectAtIndex:i];
            for (int j = 0; j < [day_column_ranges count]; j++) {
                NSMutableArray *day_range = [day_column_ranges objectAtIndex:j];
                NSInteger cellRow = (((int)[[day_range objectAtIndex:0] intValue] + 1) * 8 + i + 1);
                if (cellRow == indexPath.row) {
                    return true;
                }
                
            }
        }
    }
    return false;
    
}

-(BOOL) cellSelectedPreviouslyByTutor: (NSIndexPath *) indexPath {
    if ([self isCalendarEmpty:self.request.tutorCalendar.time_ranges]) {
        return false;
    } else {
        for (int i = 0; i < [self.request.tutorCalendar.time_ranges count]; i++) {
            NSMutableArray *day_column_ranges = [self.request.tutorCalendar.time_ranges objectAtIndex:i];
            for (int j = 0; j < [day_column_ranges count]; j++) {
                NSMutableArray *day_range = [day_column_ranges objectAtIndex:j];
                NSInteger cellRow = (((int)[[day_range objectAtIndex:0] intValue] + 1) * 8 + i + 1);
                if (cellRow == indexPath.row) {
                    return true;
                }
                
            }
        }
    }
    return false;
    
}



-(CGPoint)getCellCoord: (NSIndexPath *)indexPath {
    float row = (int) indexPath.row;
    int remainder = (int)row % 8 ;
    return CGPointMake(floor(row / 8), (float) remainder);
}

-(void)processCalendarDay: (CGPoint *)cellCoords cellUILabel: (UILabel *) label {
    
    NSArray *DAYS_OF_WEEK = @[@"Sun",@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    
    CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
    CFTimeZoneRef tz = CFTimeZoneCopySystem();
    SInt32 weekdayNum = CFAbsoluteTimeGetDayOfWeek(at, tz);
    
    if ((cellCoords->x == 0) &&  (cellCoords->y == 0)) {
        label.text = @"";
        return;
    } else if (cellCoords->y == 1) {
        label.text =@"Today";
        return;
    } else {
        label.text = [DAYS_OF_WEEK objectAtIndex:(((int) (weekdayNum + cellCoords->y -1) % 7))];
        label.textAlignment = NSTextAlignmentCenter;
    }
}

-(void)processCalendarTime: (CGPoint *)cellCoords cellUILabel: (UILabel *) label {
    
    if (cellCoords->x == 1) {
        label.text = @"12am";
    }else if ((cellCoords->x >= 2) &&  (cellCoords->x < 12)) {
        label.text = [NSString stringWithFormat:@"%iam", (int)cellCoords->x - 1];
    } else if (cellCoords->x == 13) {
        label.text = @"12pm";
    } else {
        label.text = [NSString stringWithFormat:@"%ipm", (int)(cellCoords->x - 1)% 12];
    }
    label.textAlignment = NSTextAlignmentCenter;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
