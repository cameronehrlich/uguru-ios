//
//  PaymentViewController.h
//  Uguru
//
//  Created by Samir Makhani on 7/30/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPView.h"

@interface PaymentViewController : UIViewController <STPViewDelegate>
@property STPView* stripeView;
- (IBAction)submitCreditCard:(id)sender;
@end
