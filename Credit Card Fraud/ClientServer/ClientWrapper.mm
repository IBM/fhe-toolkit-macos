//
//  ClientServerWrapper.m
//  Credit Card Fraud
//
//  Created by boland on 2/11/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#import "ClientWrapper.h"
#include "ClientServer.h"
#include <iostream>

@interface ClientWrapper () {
    Client *client;
    Server *server;
}
@end

std::string prependBundlePathOnFilePath(const char *fileName) {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String: fileName] ofType: nil];
    char const *filePath = filepath.UTF8String;
    return filePath;
    
}

@implementation ClientWrapper

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] resourcePath];
        std::string dataDir = [path UTF8String];
        client = new Client(dataDir);
        client->init();
    }
    return self;
}

- (int)getNumBatches {
    return client->getNumBatches();
}

- (void)encrypt:(int)batch andSaveSamples:(NSString *)encryptedSamplesFile {
    client->encryptAndSaveSamples(batch, [encryptedSamplesFile UTF8String]);
}

- (void)assessResults {
    
}

@end
