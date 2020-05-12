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

#import "CountryTableViewController.h"

@interface CountryTableViewController ()

@end

@implementation CountryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
}

- (void)createData {
    self.dataSource = [[CountryData alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return  [self.dataSource.capitalArray count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSString *countryName = [self.dataSource getCountry:row];
    
    NSTableCellView *cellResult = [tableView makeViewWithIdentifier:@"CountryNameCell" owner:self];
    cellResult.textField.stringValue = countryName;
    return cellResult;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    NSString *countryName = [self.dataSource getCountry:row];
    [self startQuery: countryName];
    
    return YES;
}

- (void)startQuery:(NSString *)countryQuery {
     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
         [self.detailsViewController createCapitalQuery:countryQuery];
     });
}

@end
