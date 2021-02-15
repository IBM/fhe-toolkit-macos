//
//  CreditSampleResults.h
//  Credit Card Fraud
//
//  Created by boland on 2/15/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#ifndef CreditSampleResults_h
#define CreditSampleResults_h

typedef struct {
    int inferenceCount;
    int totalInferenceCount;
    int truePositives;
    int trueNegatives;
    int falsePositives;
    int falseNegatives;
    double precision;
    double recall;
    double f1Score;
} CreditSampleResults;

#endif /* CreditSampleResults_h */
