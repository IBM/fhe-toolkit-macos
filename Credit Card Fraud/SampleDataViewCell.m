//
//  SampleDataViewCell.m
//  Credit Card Fraud
//
//  Created by boland on 7/29/20.
//  Copyright © 2020 IBM. All rights reserved.
//

#import "SampleDataViewCell.h"

@implementation SampleDataViewCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateWithData:(CreditSampleResultsData *)sampleData {
    [self.truePositivesLabel setStringValue:[NSString stringWithFormat:@"%li", (long)sampleData.sampleData->truePositives]];
    [self.trueNegativesLabel setStringValue:[NSString stringWithFormat:@"%li", (long)sampleData.sampleData->trueNegatives]];
    [self.falseNegativesLabel setStringValue:[NSString stringWithFormat:@"%li", (long)sampleData.sampleData->falseNegatives]];
    [self.falsePositivesLabel setStringValue:[NSString stringWithFormat:@"%li", (long)sampleData.sampleData->falsePositives]];
}

@end
