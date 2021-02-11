//
//  ClientServerWrapper.h
//  Credit Card Fraud
//
//  Created by boland on 2/11/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClientServerWrapper : NSObject

- (void)initClient;
- (void)initServer;
- (int)getNumBatches;

@end

NS_ASSUME_NONNULL_END
