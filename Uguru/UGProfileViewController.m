//
//  UGProfileViewController.m
//  Uguru
//
//  Created by Samir Makhani on 8/2/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import "UGProfileViewController.h"
#import "UGProfileEditViewController.h"
#import "UGSkillCollectionViewCell.h"
#import <UIColor+Hex.h>
#import "AMRatingControl.h"

@interface UGProfileViewController() <UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation UGProfileViewController

User *currentUser;

NSMutableArray *userExperiences;

bool initialized;
UICollectionView *_collectionView;
UICollectionView *_experienceCollectionView;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    initialized = true;
    userExperiences = [[NSMutableArray alloc] init];
    [self userExperiencesToArray];
    
    currentUser = [[UGModel sharedInstance] user];
    NSString *image_url = currentUser.image_url;
    
    if ([image_url rangeOfString:@"http"].location == NSNotFound) {
        [self.photo setImage:[UIImage imageNamed:@"notificationPlaceholder"]];
    }else{
        NSURL * imageURL = [NSURL URLWithString:image_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [self.photo setImage:image];
    };
    
    self.name.text = currentUser.name;
    self.year.text = currentUser.year;
    self.bio_header_text.text = [NSString stringWithFormat:@"%@'s profile", self.name.text];
    self.bio_text.text = currentUser.bio;
    self.major.text = currentUser.major;
    
    if (currentUser.num_ratings) {
        self.num_ratings.text = [NSString stringWithFormat:@"%@", currentUser.num_ratings];
    } else {
        self.num_ratings.hidden = true;
    }

    //Initialize skills collection subview
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:self.showSkillsCollectionView.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SkillCell"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    _collectionView.clipsToBounds = YES;
    
    _collectionView.frame = CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y, _collectionView.frame.size.width, _collectionView.frame.size.height + 50);
    
    [self.view addSubview:_collectionView];
    
    [_collectionView flashScrollIndicators];
    
    //Initialize experiences collection subview
    UICollectionViewFlowLayout *experiencesLayout=[[UICollectionViewFlowLayout alloc] init];
    _experienceCollectionView=[[UICollectionView alloc] initWithFrame:self.showExperienceCollectionView.frame collectionViewLayout:experiencesLayout];
    [_experienceCollectionView setDataSource:self];
    [_experienceCollectionView setDelegate:self];
    
    [_experienceCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SkillCell"];
    [_experienceCollectionView setBackgroundColor:[UIColor whiteColor]];
    _experienceCollectionView.clipsToBounds = YES;
    
    _experienceCollectionView.frame = CGRectMake(_experienceCollectionView.frame.origin.x, _experienceCollectionView.frame.origin.y, _experienceCollectionView.frame.size.width, _experienceCollectionView.frame.size.height);
    
    [self.view addSubview:_experienceCollectionView];
    
    CGPoint ratings_location = CGPointMake(self.photo.frame.origin.x + self.photo.frame.size.width + 5, self.photo.frame.origin.y + self.photo.frame.size.height - 30);
    
    self.colorRatingControl = [[AMRatingControl alloc] initWithLocation:ratings_location
                                                             emptyColor:[UIColor yellowColor]
                                                             solidColor:[UIColor yellowColor]
                                                           andMaxRating:5];
    
    self.colorRatingControl.userInteractionEnabled = NO;
    self.colorRatingControl.rating = 4.5;
    self.colorRatingControl.starFontSize = 26;
    self.colorRatingControl.starSpacing = -10;
    [self.view addSubview:self.colorRatingControl];
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!initialized) {
        currentUser = [[UGModel sharedInstance] user];
        NSString *image_url = currentUser.image_url;
        
        if ([image_url rangeOfString:@"http"].location == NSNotFound) {
            [self.photo setImage:[UIImage imageNamed:@"notificationPlaceholder"]];
        }else{
            NSURL * imageURL = [NSURL URLWithString:image_url];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            [self.photo setImage:image];
        };
        
        self.name.text = currentUser.name;
        self.year.text = currentUser.year;
        self.bio_header_text.text = [NSString stringWithFormat:@"%@'s profile", self.name.text];
        self.bio_text.text = currentUser.bio;
        self.major.text = currentUser.major;
    }
    initialized = false;
    
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
}

- (void)userExperiencesToArray {
    currentUser = [[UGModel sharedInstance] user];
    
    if ([currentUser.slc_tutor boolValue]) {
        [userExperiences addObject:@"SLC Tutor"];
    }
    if ([currentUser.hkn_tutor boolValue]) {
        [userExperiences addObject:@"HKN Tutor"];
    }
    if ([currentUser.ta_tutor boolValue]) {
        [userExperiences addObject:@"TA / GSI"];
    }
    if ([currentUser.res_tutor boolValue]) {
        [userExperiences addObject:@"Residential Hall Tutor"];
    }
    if ([currentUser.la_tutor boolValue]) {
        [userExperiences addObject:@"Lab Assistant"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionView) {
        return [[[UGModel sharedInstance] user].skills count];
    }
    if (collectionView == _experienceCollectionView){
        return [userExperiences count];
    }
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SkillCell" forIndexPath:indexPath];
    
    int row = (int) indexPath.row;
    
    if (collectionView == _collectionView) {
        NSMutableArray *user_skills = [[UGModel sharedInstance] user].skills;
        NSString *skill_string = [user_skills objectAtIndex:row];
        
        cell.backgroundColor= UIColorFromRGB(6404685);
        
        UILabel *skill_label = [[UILabel alloc] initWithFrame:cell.frame];
        skill_label.text = skill_string;
        skill_label.textColor = [UIColor whiteColor];
        
        [skill_label setCenter:cell.contentView.center];
        skill_label.textAlignment = NSTextAlignmentCenter;
        
        [cell.contentView addSubview:skill_label];
    }
    
    if (collectionView == _experienceCollectionView) {
        NSString *experience_string = [userExperiences objectAtIndex:row];
        
        cell.backgroundColor= [UIColor colorWithCSS:@"29ADE3"];
        
        UILabel *skill_label = [[UILabel alloc] initWithFrame:cell.frame];
        skill_label.text = experience_string;
        skill_label.textColor = [UIColor whiteColor];
        
        [skill_label setCenter:cell.contentView.center];
        skill_label.textAlignment = NSTextAlignmentCenter;
        
        [cell.contentView addSubview:skill_label];
    }
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int) indexPath.row;
    if (collectionView == _collectionView) {
        NSString *skill_string = [[[UGModel sharedInstance] user].skills objectAtIndex:row];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:24]};
        CGSize stringSize = [skill_string sizeWithAttributes:attributes];
        return stringSize;
    }
    if (collectionView == _experienceCollectionView){
        NSString *skill_string = [userExperiences objectAtIndex:row];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:24]};
        CGSize stringSize = [skill_string sizeWithAttributes:attributes];
        return stringSize;
    }
    return CGSizeMake(50, 50);
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

- (IBAction)editProfileAction:(id)sender {
    [self performSegueWithIdentifier:@"profileToProfileEdit" sender:self];
}

@end
