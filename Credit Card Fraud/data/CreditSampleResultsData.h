//
//  CreditSampleResultsData.h
//  Credit Card Fraud
//
//  Created by boland on 7/28/20.
//  Copyright © 2020 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CreditSampleResults.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ResultsTableViewType) {
    ScoresTableViewType,
    InferenceTableViewType
};


@interface CreditSampleResultsData : NSObject

@property (nonatomic, assign) CreditSampleResults *sampleData;

- (id)initWithData:(CreditSampleResults *)sData;
- (NSString *)getValueByName:(NSString *)keyName;
- (NSString *)getValueByColumn:(NSInteger)column row:(NSInteger)row;
+ (NSArray *)titleArrayByType:(ResultsTableViewType)tableType;

@end


NS_ASSUME_NONNULL_END
