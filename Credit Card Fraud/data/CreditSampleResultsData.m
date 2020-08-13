//
//  CreditSampleResultsData.m
//  Credit Card Fraud
//
//  Created by boland on 7/28/20.
//  Copyright © 2020 IBM. All rights reserved.
//

#import "CreditSampleResultsData.h"

@implementation CreditSampleResultsData

- (id)initWithData:(CreditSampleResults *) sdata {
  self = [super init];
  if(self) {
      _sampleData = sdata;
  }
  return self;
}

- (void)dealloc {
  free(_sampleData);
  //[super dealloc];
}

/**
    * GetValueByName
        - returns the value from the sample data that is mapped to it via a key
 */
- (NSString *)getValueByName:(NSString *)keyName {
    if ([keyName isEqual:@"Precision"]) {
        return [NSString stringWithFormat:@"%.3f", _sampleData->precision];
    } else if ([keyName isEqual:@"Recall"]) {
        return [NSString stringWithFormat:@"%.2f", _sampleData->recall];
    } else if ([keyName isEqual:@"F1 Score"]) {
        return [NSString stringWithFormat:@"%.3f", _sampleData->f1Score];
    } else {
        return @"";
    }
}

/**
    * Get Value By Column/Row
        - This is used exclusively for the Inference TableView as when a result is ready it needs to be sorted to fit into the correct column
        - needs column number
        - and row number
 */
- (NSString *)getValueByColumn:(NSInteger)column row:(NSInteger)row{
    switch (row) {
        case 2:
        {
            NSString *resultValue = @"";
            switch (column) {
                case 2:
                    //True Positive Value
                    resultValue = [NSString stringWithFormat:@"%ld", (long)_sampleData->truePositives];
                    break;
                case 3:
                    //False Positive Value
                    resultValue = [NSString stringWithFormat:@"%ld", (long)_sampleData->falsePositives];
                default:
                    break;
            }
            return resultValue;
        }
        case 3:
        {
            NSString *resultValue = @"";
            switch (column) {
                case 2:
                    //False Negative Value
                    resultValue = [NSString stringWithFormat:@"%ld", (long)_sampleData->falseNegatives];
                    break;
                case 3:
                    //True Negative Value
                    resultValue = [NSString stringWithFormat:@"%ld", (long)_sampleData->trueNegatives];
                default:
                    break;
            }
            return resultValue;
        }
        default:
            //0, and 1 should never get called, but if they do default to empty space
            return @"";
            break;
    }
}

+ (NSArray *)titleArrayByType:(ResultsTableViewType)tableType {
    switch (tableType) {
        case ScoresTableViewType:
            return @[@"Scores:", @"Precision", @"Recall", @"F1 Score"];
            break;
        case InferenceTableViewType:
            return  @[@{@0:@"", @1:@"", @2:@"Truth:", @3:@""},
                                               @{@0:@"", @1:@"", @2:@"➕", @3:@"➖"},
                                               @{@0:@"Predict:", @1:@"➕", @2:@"", @3:@""},
                                               @{@0:@"", @1:@"➖", @2:@"", @3:@""}];
    }
}


@end
