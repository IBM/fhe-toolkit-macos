//
//  ClientServerWrapper.m
//  Credit Card Fraud
//
//  Created by boland on 2/11/21.
//  Copyright © 2021 IBM. All rights reserved.
//

#import "ClientServerWrapper.h"
#include "ClientServer.h"
#include <iostream>

@interface ClientServerWrapper () {
    Client *client;
    Server *server;
}
@end

std::string prependBundlePathOnFilePath(const char *fileName) {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String: fileName] ofType: nil];
    char const *filePath = filepath.UTF8String;
    return filePath;
    
}

@implementation ClientServerWrapper

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareClient {
    std::string dataDir = "";
    client = new Client(dataDir);
    client->init();
}

- (void)initServer {
    server = new Server();
    server->init();
}

- (int)getNumBatches {
    return client->getNumBatches();
}

//- (id)initWithSize:(int)size
//{
//  self = [super init];
//  if (self)
//  {
//    std::string dataDir = "";
//    client = Client(dataDir);
//    if (!client) self = nil;
//  }
//  return self;
//}

@end
