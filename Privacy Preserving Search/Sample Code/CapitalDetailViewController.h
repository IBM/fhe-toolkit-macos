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

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CapitalDisplayLoadingDelegate <NSObject>
- (void)databaseSearchStarted;
- (void)databaseSearchEnded;
@end

@interface CapitalDetailViewController : NSViewController

@property (nonatomic, strong) NSTimer *timeTicker;
@property (nonatomic, weak) IBOutlet NSTextField *timeGone;
@property (nonatomic, weak) IBOutlet NSTextField *logging;
@property (nonatomic, weak) IBOutlet NSTextField *countryLabel;
@property (nonatomic, weak) IBOutlet NSTextField *capitalResultLabel;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressBar;
@property (nonatomic, weak) id <CapitalDisplayLoadingDelegate> delegate;

- (void)createCapitalQuery:(NSString *)countryQuery;

@end

NS_ASSUME_NONNULL_END
