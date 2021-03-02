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
