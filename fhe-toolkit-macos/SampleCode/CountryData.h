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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountryData : NSObject

@property (nonatomic, copy) NSArray *capitalArray;

- (NSDictionary *)JSONFromFile;
- (NSString *)getCountry:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
