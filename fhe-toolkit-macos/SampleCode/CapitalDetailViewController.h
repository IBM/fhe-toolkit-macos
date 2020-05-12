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
