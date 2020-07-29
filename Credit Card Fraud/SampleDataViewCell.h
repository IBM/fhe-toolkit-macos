//
//  SampleDataViewCell.h
//  Credit Card Fraud
//
//  Created by boland on 7/29/20.
//  Copyright © 2020 IBM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CreditSampleResultsData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SampleDataViewCell : NSView

@property (nonatomic, weak) IBOutlet NSTextField *truePositivesLabel;
@property (nonatomic, weak) IBOutlet NSTextField *trueNegativesLabel;
@property (nonatomic, weak) IBOutlet NSTextField *falsePositivesLabel;
@property (nonatomic, weak) IBOutlet NSTextField *falseNegativesLabel;
@property (nonatomic, weak) IBOutlet NSTextField *precisionLabel;
@property (nonatomic, weak) IBOutlet NSTextField *recallLabel;
@property (nonatomic, weak) IBOutlet NSTextField *f1ScoreLabel;
@property (nonatomic, weak) IBOutlet NSGridView  *gridView;



- (void)updateWithData:(CreditSampleResultsData *)sampleData;

@end

NS_ASSUME_NONNULL_END
