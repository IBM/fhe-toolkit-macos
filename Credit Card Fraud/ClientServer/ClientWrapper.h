//
//  ClientServerWrapper.h
//  Credit Card Fraud
//
//  Created by boland on 2/11/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditSampleResultsData.h"
#import "CreditSampleResults.h"

NS_ASSUME_NONNULL_BEGIN


@interface ClientWrapper : NSObject

- (int)getNumBatches;
- (void)encrypt:(int)batch andSaveSamples:(NSString *)encryptedSamplesFile;
- (void)decryptPredictions:(NSString *)encryptedPredictionsFile;
- (void)assessResults:(CreditSampleResults *)creditSampleResults;

@end

NS_ASSUME_NONNULL_END
