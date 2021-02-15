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

#import "ClientWrapper.h"
#include "ClientServer.h"
#include <iostream>

@interface ClientWrapper () {
    Client *client;
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

- (void)decryptPredictions:(NSString *)encryptedPredictionsFile {
    client->decryptPredictions([encryptedPredictionsFile UTF8String]);
}

- (void)assessResults:(CreditSampleResults *)creditSampleResults {
    client->assessResults(creditSampleResults);
}

@end
