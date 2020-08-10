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
