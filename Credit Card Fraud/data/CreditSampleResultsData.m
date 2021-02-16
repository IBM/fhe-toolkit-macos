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
