/*
* IBM Confidential
*
*
* Copyright IBM Corporation 2020.
*
* The source code for this program is not published or otherwise divested of
* its trade secrets, irrespective of what has been deposited with the US
* Copyright Office.
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
