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

#import "CountryData.h"

@implementation CountryData

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *capitalData = [self CSVFromFile];
        self.capitalArray = [[capitalData allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }
    return self;
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSDictionary *)CSVFromFile {
    //Create the path to the CSV file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countries_dataset" ofType:@"csv"];
    //Load the CSV file into memory as a String
    NSString *csvContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //Parse through the CSV file by \n (newline) character creating an array of rows with (country, capital) pairs
    NSArray* csvRows = [csvContent componentsSeparatedByString:@"\n"];
    //Parse through individual rows creating a dictionary entry
    NSMutableDictionary *countryCSVData = [[NSMutableDictionary alloc] initWithCapacity:csvRows.count-1];
    // For each row create a new dictionary entry with a key and a value
    for (NSString *countryRow in csvRows) {
        NSArray *csvValues = [countryRow componentsSeparatedByString:@","];
        if (csvValues.count >= 2) {
            [countryCSVData setValue:csvValues[1] forKey:csvValues[0]];
        }
       
    }
    NSLog(@"%@", countryCSVData);
    return  countryCSVData;
    
}

- (NSString *)getCountry:(NSInteger)index {
    NSString *countryTitle = [self.capitalArray objectAtIndex:index];
    return countryTitle;
}

@end
