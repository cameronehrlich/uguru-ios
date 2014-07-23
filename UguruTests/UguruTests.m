//
//  UguruTests.m
//  UguruTests
//
//  Created by Cameron Ehrlich on 7/15/14.
//  Copyright (c) 2014 Uguru. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCTestAsync.h>

@interface UguruTests : XCTestCase

@property (nonatomic, strong) UGModel *model;

@end

@implementation UguruTests

- (void)setUp
{
    [super setUp];
    self.model = [[UGModel alloc] init];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSignUpAsync
{
    User *newUser = [User new];
    newUser.name = @"Samir";
    newUser.email = [NSString stringWithFormat:@"%f%@", NSDate.date.timeIntervalSince1970, @"@uguruintegrationtesting.com"];
    newUser.password = @"Password123";
    
    [self.model signUp:newUser success:^(id responseObject) {
        
        // Test returned object
        User *returnedUser = responseObject;
        
        XCTAssert([[returnedUser name] isEqualToString:@"Samir"], @"Incorrect response info.");
        
        // Test Token
        NSString *auth_token = [[[[self.model requestManager] requestSerializer] HTTPRequestHeaders] objectForKey:UGURU_AUTH_TOKEN];
        XCTAssertNotNil(auth_token, @"No Auth token");
        XCTAssertNotNil([SSKeychain passwordForService:UGURU_KEYCHAIN_SERVICE account:UGURU_KEYCHAIN_ACCOUNT], @"Keychain item not set");
        
        XCAsyncSuccess();
    } fail:^(NSDictionary *errors) {
        
        XCAsyncFailAfter(0, @"Failed to signup user.");
    }];
}


- (void)testLoginAsync
{
    User *newUser = [User new];
    newUser.name = @"Samir";
    newUser.email = [NSString stringWithFormat:@"%f%@", NSDate.date.timeIntervalSince1970, @"@uguruintegrationtesting.com"];
    newUser.password = @"Password123";
    
    [self.model signUp:newUser success:^(id responseObject) {
        [self.model login:newUser success:^(id responseObject) { 
            // TODO : Do more checks on the status of the actual retured object
            XCAsyncSuccess();
        } fail:^(NSDictionary *errors) {
            XCAsyncFailAfter(0, @"Failed to login user");
        }];
        XCAsyncSuccess();
    } fail:^(NSDictionary *errors) {
        XCAsyncFailAfter(0, @"Failed to signup user.");
    }];
}

- (void)testGetUserAsync
{
    User *newUser = [User new];
    newUser.name = @"Samir";
    newUser.email = [NSString stringWithFormat:@"%f%@", NSDate.date.timeIntervalSince1970, @"@uguruintegrationtesting.com"];
    newUser.password = @"Password123";
    
    [self.model signUp:newUser success:^(id responseObject) {
        [self.model getUserWithSuccess:^(id responseObject) {
            XCTAssert([self.model.user.name isEqualToString:@"Samir"], @"Returned user is wrong");
            XCAsyncSuccess();
        } fail:^(NSDictionary *errors) {
            XCAsyncFailAfter(0, @"");
        }];
    } fail:^(NSDictionary *errors) {
        XCAsyncFailAfter(0, @"");
    }];
}

- (void)testUpdateUserAsync
{
    User *newUser = [User new];
    newUser.name = @"Samir";
    newUser.email = [NSString stringWithFormat:@"%f%@", NSDate.date.timeIntervalSince1970, @"@uguruintegrationtesting.com"];
    newUser.password = @"Password123";
    
    [self.model signUp:newUser success:^(id responseObject) {
        XCAsyncSuccess();
    } fail:^(NSDictionary *errors) {
        XCAsyncFailAfter(0, @"");
    }];
}

@end
