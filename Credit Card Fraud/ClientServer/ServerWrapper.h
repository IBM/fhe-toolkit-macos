//
//  ServerWrapper.h
//  Credit Card Fraud
//
//  Created by boland on 2/11/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerWrapper : NSObject

- (void)processEncryptedSamples: (NSString*)encryptedSamplesFile encryptedPredictions: (NSString *)encryptedPredictionsFile;

@end

NS_ASSUME_NONNULL_END
