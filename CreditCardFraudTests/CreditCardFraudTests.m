/*
* MIT License
*
* Copyright (c) 2020 International Business Machines
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

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
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:45.0];
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
