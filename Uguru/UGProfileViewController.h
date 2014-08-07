//
//  UGProfileViewController.h
//  Uguru
//
//  Created by Samir Makhani on 8/2/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGShowSkillsViewLayout.h"
#import "AMRatingControl.h"

@interface UGProfileViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *major;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *bio_header_text;
@property (strong, nonatomic) IBOutlet UITextView *bio_text;
@property (strong, nonatomic) IBOutlet UILabel *num_ratings;
- (IBAction)editProfileAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) AMRatingControl *colorRatingControl;


@property (strong, nonatomic) IBOutlet UICollectionView *showSkillsCollectionView;
@property (strong, nonatomic) IBOutlet UGShowSkillsViewLayout *showSkillsViewLayout;
@property (strong, nonatomic) IBOutlet UICollectionView *showExperienceCollectionView;

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
