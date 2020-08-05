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

#import "CountryDisplaySplitViewController.h"

@interface CountryDisplaySplitViewController () {
    NSProgressIndicator *loadingSpinner;
}

@end

@implementation CountryDisplaySplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSViewController* vc in self.childViewControllers)
    {
        if ([vc isKindOfClass:CountryTableViewController.class]) {
            self.masterController = (CountryTableViewController *)vc;
        }
        if ([vc isKindOfClass:CapitalDetailViewController.class]) {
            CapitalDetailViewController *detailsController = (CapitalDetailViewController *)vc;
            self.masterController.detailsViewController = detailsController;
            detailsController.delegate = self;
        }
        NSLog(@"%@", vc);
    }
    
}

- (void)databaseSearchStarted {
    NSProgressIndicator *indicator = [[NSProgressIndicator alloc] init];
    [indicator setStyle: NSProgressIndicatorStyleSpinning];
   // [indicator setBounds: NSMakeRect(0, 0, 100, 50)];
    CGFloat x = (NSWidth(self.view.bounds) - 100) * 0.5;
    CGFloat y = (NSHeight(self.view.bounds) - 50) * 0.5;
    CGRect f = CGRectMake(x, y, 100, 50);
    [indicator setFrame:f];
    indicator.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin;
    
    [indicator startAnimation:self];
    [self.view addSubview:indicator];
    loadingSpinner = indicator;
}

- (void)databaseSearchEnded {
    if (loadingSpinner) {
        [loadingSpinner removeFromSuperview];
        loadingSpinner = nil;
    }
}

@end
