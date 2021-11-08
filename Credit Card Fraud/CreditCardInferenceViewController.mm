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

#import "CreditCardInferenceViewController.h"
#import "CreditSampleResultsData.h"
#import "ClientServer/ClientWrapper.h"
#import "ClientServer/ServerWrapper.h"

#include <iostream>

#include "helayers/hebase/hebase.h"
#include "helayers/hebase/helib/HelibCkksContext.h"
#include "helayers/hebase/helib/HelibConfig.h"

using namespace std;
using namespace helayers;

// define names of files to be used for saving and loading of HE contexts and
// encrypted model
string outDir;
string clientContext;
string serverContext;
bool runAll = false;

/*
 * create an HELIB context for both the client and the server, and save contexts
 * into files
 * client context contains a secret key while server context does not
 * */
void createContexts()
{

  cout << "Initalizing HElib . . ." << endl;

  shared_ptr<HeContext> hePtr;
  outDir = getenv("HELAYERS_EXAMPLES_OUTPUT_DIR");
  clientContext = outDir + "/client_context.bin";
    serverContext = outDir + "/server_context.bin";
    cout << outDir << endl;
  // Preset configuration with 512 slots: low security level, but fast, just for
  // the demo
  hePtr = HelibContext::create(HELIB_NOT_SECURE_CKKS_512_FAST);

  // Preset configuration with 16384 slots: mediocre security
  // hePtr = HelibContext::create(HELIB_CKKS_16384);

  // Preset configuration with 32768 slots: high security
  // hePtr = HelibContext::create(HELIB_CKKS_32768);

  // Print details, including security level
  hePtr->printSignature(cout);

  cout << "Clearing " << outDir << endl;
  FileUtils::createCleanDir(outDir);
  cout << "Saving client side context to " << clientContext << endl;
  bool withSecretKey = true;
  hePtr->saveToFile(clientContext, withSecretKey); // save client context

  cout << "Saving server side context to " << serverContext << endl;
  withSecretKey = false;
  hePtr->saveToFile(serverContext, withSecretKey); // save server context
}

@implementation CreditCardInferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)startInference {
    cout << "*** Starting inference demo ***" << endl;

    // creating HELIB context for both client and server, save them to files
    createContexts();
    
    // init client
    ClientWrapper *client = [[ClientWrapper alloc] init];

    // init server
    ServerWrapper *server = [[ServerWrapper alloc] init];

    // go over each batch of samples
    int iterations = runAll ? [client getNumBatches] : min(24, [client getNumBatches]);
    for (int i = 0; i < iterations; ++i) {

        cout << endl
           << "*** Performing inference on batch " << i + 1 << "/" << iterations
           << " ***" << endl;
        // define names of files to be used to save encrypted batch of samples and
        // their correspondent predictions
        NSString *encryptedSamplesFile = [NSString stringWithFormat:@"%s/encrypted_batch_samples_%i.bin", outDir.c_str(), i];
        NSString *encryptedPredictionsFile = [NSString stringWithFormat:@"%s/encrypted_batch_predictions_%i.bin", outDir.c_str(), i];
     
        // encrypt current batch of samples by client, save to file
        [client encrypt:i andSaveSamples:encryptedSamplesFile];
        // load current batch of encrypted samples by server, predict and save
        // encrypted predictions
        [server processEncryptedSamples: encryptedSamplesFile encryptedPredictions: encryptedPredictionsFile];

        // load current batch's predictions by client, decrypt and store
        [client decryptPredictions: encryptedPredictionsFile];
        
        //create a place to store the Sample results so we can display it
        //CreditSampleResults *sampleResults = [[CreditSampleResults alloc] init];
        CreditSampleResults *sampleResults = (CreditSampleResults *) malloc(sizeof(CreditSampleResults));
        sampleResults->totalInferenceCount = iterations;
        sampleResults->inferenceCount = i+1;
        
        // analyze the server's predictions so far with respect to the expected labels
        [client assessResults: sampleResults];
        
        [self.sampleDataArray addObject:[[CreditSampleResultsData alloc] initWithData: sampleResults]];
        // re-load the views with the updated information
        dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self updateView:[self.sampleDataArray objectAtIndex:i]];
        });

    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    //The Scores TableView we default to 4 rows
    NSInteger totalRows = 4;
    //But we check to see which table we have, if its the Inference table then there are 4 rows
    if (tableView.tag == InferenceTableViewType) {
        totalRows = 4;
    }
    return totalRows;
}

/**
    ViewForTableColumn
    - populates the different table rows
    - does nothing if there is no data to use
    - detemines which table to use first, then uses column and row to populate the data
 */
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //Skip if there is no data yet
    if ([self.sampleDataArray count] < 1) {
        return nil;
    }
    //Pull the last object out of the array because that will always be the most recent data
    CreditSampleResultsData *inferenceData = self.sampleDataArray.lastObject;
    //Check which table we have to populate. The first one is the Score Table View
    if (tableView.tag == ScoresTableViewType) {
        //This is the Scores TableView
        NSString *cellTextString = @"";
        NSArray *scoresTitleDataArray = [CreditSampleResultsData titleArrayByType:ScoresTableViewType];
        if ([tableView tableColumns][0] == tableColumn) {
            cellTextString = scoresTitleDataArray[row];
        } else {
            cellTextString = [inferenceData getValueByName: scoresTitleDataArray[row]];
        }
        NSTableCellView *cellResult = [tableView makeViewWithIdentifier:@"ScoresDataCell" owner:self];
        [cellResult.textField setStringValue:cellTextString];
        return cellResult;
    } else {
        //This is the Inference Tableview
        NSString *cellTextString = @"";
        NSArray *inferenceTitleDataArray = [CreditSampleResultsData titleArrayByType:InferenceTableViewType];
        NSDictionary *columnDict = [inferenceTitleDataArray objectAtIndex:row];
        if ([tableView tableColumns][0] == tableColumn) {
            //this is the first column in the inference table which should only hold a title
            cellTextString = [columnDict objectForKey:[NSNumber numberWithLong:0]];
        } else if ([tableView tableColumns][1] == tableColumn) {
            cellTextString = [columnDict objectForKey:[NSNumber numberWithLong:1]];
        } else if ([tableView tableColumns][2] == tableColumn) {
            if (row == 2 || row == 3) {
                cellTextString = [inferenceData getValueByColumn:2 row:row];
            } else {
               cellTextString = [columnDict objectForKey:[NSNumber numberWithLong:2]];
            }
        } else {
            //we know this must be the last column
            if (row == 2 || row == 3) {
                cellTextString = [inferenceData getValueByColumn:3 row:row];
            } else {
               cellTextString = [columnDict objectForKey:[NSNumber numberWithLong:3]];
            }
        }
        NSTableCellView *cellResult = [tableView makeViewWithIdentifier:@"SampleDataCell" owner:self];
        [cellResult.textField setStringValue:cellTextString];
        return cellResult;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    //The Scores TableView we default to 24 height
    NSInteger rowHeight = 26.0;
    //But we check to see which table we have, if its the Inference table then there are 4 rows
    if (tableView.tag == InferenceTableViewType) {
        rowHeight = 31.0;
    }
    return rowHeight;
}

- (void)updateView:(CreditSampleResultsData *)sampleResultsData {
    [self.progressView update:sampleResultsData.sampleData->inferenceCount total:sampleResultsData.sampleData->totalInferenceCount];
    [self.scoresTableView reloadData];
    [self.inferenceTableView reloadData];
}

- (void)setupView {
    self.sampleDataArray = [[NSMutableArray alloc] initWithCapacity:24];
    [self.progressView setup];
    self.scoresTableView.delegate = self;
    self.scoresTableView.dataSource = self;
    self.inferenceTableView.delegate = self;
    self.inferenceTableView.dataSource = self;
}

- (void)triggerInference {
    [self.progressView start];
     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
         [self startInference];
     });
}

- (IBAction) startButtonWasPressed:(id)sender {
    [self triggerInference];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
