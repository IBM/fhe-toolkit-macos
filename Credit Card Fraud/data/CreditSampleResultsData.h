//
//  CreditSampleResultsData.h
//  Credit Card Fraud
//
//  Created by boland on 7/28/20.
//  Copyright © 2020 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    NSInteger inferenceCount;
    NSInteger totalInferenceCount;
    NSInteger truePositives;
    NSInteger trueNegatives;
    NSInteger falsePositives;
    NSInteger falseNegatives;
    double precision;
    double recall;
    double f1Score;
} CreditSampleResults;

@interface CreditSampleResultsData : NSObject

@property (nonatomic, assign) CreditSampleResults *sampleData;

- (id)initWithData:(CreditSampleResults *)sData;

@end


NS_ASSUME_NONNULL_END
