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

#import "CountryData.h"

@implementation CountryData

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *capitalData = [self JSONFromFile];
        self.capitalArray = [capitalData objectForKey:@"data"];
    }
    return self;
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSString *)getCountry:(NSInteger)index {
    NSDictionary *countryInfo = [self.capitalArray objectAtIndex:index];
    NSString *countryTitle = [[countryInfo allKeys] objectAtIndex:0];
    return countryTitle;
}

@end
