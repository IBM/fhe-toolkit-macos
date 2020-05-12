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

#import <Cocoa/Cocoa.h>
#import "CountryData.h"
#import "CapitalDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CountryTableViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) CapitalDetailViewController *detailsViewController;
@property (nonatomic, strong) CountryData *dataSource;

@end

NS_ASSUME_NONNULL_END
