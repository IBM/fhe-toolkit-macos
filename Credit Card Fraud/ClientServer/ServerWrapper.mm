//
//  ServerWrapper.m
//  Credit Card Fraud
//
//  Created by boland on 2/11/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#import "ServerWrapper.h"
#include "ClientServer.h"
#include <iostream>

@interface ServerWrapper () {
    Server *server;
}
@end


@implementation ServerWrapper

- (instancetype)init
{
    self = [super init];
    if (self) {
        server = new Server();
        server->init();
    }
    return self;
}

- (void)processEncryptedSamples: (NSString*)encryptedSamplesFile encryptedPredictions: (NSString *)encryptedPredictionsFile {
    server->processEncryptedSamples([encryptedSamplesFile UTF8String],[encryptedPredictionsFile UTF8String]);
}


@end
