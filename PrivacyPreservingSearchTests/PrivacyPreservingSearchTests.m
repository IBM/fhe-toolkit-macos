//
//  PrivacyPreservingSearchTests.m
//  PrivacyPreservingSearchTests
//
//  Created by boland on 3/1/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CapitalDetailViewController.h"

@interface CapitalDelegate : XCTestCase <CapitalDisplayLoadingDelegate>

@property (nonatomic, assign) Boolean result;
@property (nonatomic, copy) NSString *expectedResult;
@property (nonatomic, strong) XCTestExpectation *asyncExpectation;

- (void)databaseSearchStarted;
- (void)databaseSearchEnded: (NSString *)stringResult;


@end

@implementation CapitalDelegate

- (void)databaseSearchStarted {
    NSLog(@"search started");
}

- (void)databaseSearchEnded: (NSString *)stringResult {
    NSLog(@"search ended %@", stringResult);
    //DO the check here
    if ([stringResult isEqual:self.expectedResult]) {
        self.result = YES;
    } else {
        self.result = NO;
    }
    [self.asyncExpectation fulfill];
}

@end

@interface PrivacyPreservingSearchTests : XCTestCase

@end

@implementation PrivacyPreservingSearchTests 

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCapitalQueryZambia {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    CapitalDetailViewController *view = [[CapitalDetailViewController alloc] init];
    CapitalDelegate *delegateAndWait = [[CapitalDelegate alloc] init];
    delegateAndWait.expectedResult = @" Lusaka";
    
    delegateAndWait.asyncExpectation = [self expectationWithDescription:@"Waiting for the Capital Result"];
    view.delegate = delegateAndWait;
    [view createCapitalQuery:@"Zambia"];
    
    [self waitForExpectationsWithTimeout:45.0 handler:^(NSError * _Nullable error) {
        
        XCTAssertTrue(delegateAndWait.result);
    }];
}

- (void)testCapitalQuerySweden {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    CapitalDetailViewController *view = [[CapitalDetailViewController alloc] init];
    CapitalDelegate *delegateAndWait = [[CapitalDelegate alloc] init];
    delegateAndWait.expectedResult = @" Stockholm";
    
    delegateAndWait.asyncExpectation = [self expectationWithDescription:@"Waiting for the Capital Result"];
    view.delegate = delegateAndWait;
    [view createCapitalQuery:@"Sweden"];
    
    [self waitForExpectationsWithTimeout:45.0 handler:^(NSError * _Nullable error) {
        
        XCTAssertTrue(delegateAndWait.result);
    }];
}



//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
