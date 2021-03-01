//
//  CreditCardFraudTests.m
//  CreditCardFraudTests
//
//  Created by boland on 3/1/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CreditCardInferenceViewController.h"

@interface CreditCardFraudTests : XCTestCase

@end

@implementation CreditCardFraudTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInference {
    CreditCardInferenceViewController *view = [[CreditCardInferenceViewController alloc] init];
    [view viewDidLoad];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Cred Card Inference test Results"];
    [view triggerInference];
    
    XCTWaiterResult *result = [XCTWaiter waitForExpectations:expectation timeout:30.0];
    if (result == XCTWaiterResultTimedOut) {
        NSArray *resultsArray = view.sampleDataArray;
        BOOL result = NO;
        if ([resultsArray count] > 0) {
            result = YES;
        }
        [expectation fulfill];
        XCTAssertTrue(result);
    }
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
