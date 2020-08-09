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

#import "CapitalDetailViewController.h"
#include <iostream>
#include <helib/helib.h>
#include <helib/EncryptedArray.h>
#include <helib/ArgMap.h>
#include <NTL/BasicThreadPool.h>

@interface CapitalDetailViewController ()

@end

@implementation CapitalDetailViewController

// Note: These parameters have been chosen to provide fast running times as
// opposed to a realistic security level. As well as negligible security,
// these default parameters result in an algebra with only 10 slots which limits
// the size of both the “keys” and “values” to 10 chars. If you try to use
// bigger “keys” or “values” you will need to choose different parameters
// that give you more slots, otherwise the code will throw an
// "helib::OutOfRangeError" exception.
//
// Commented below there is the parameter "m-130" which will result in an algebra
// with 48 slots, thus allowing for “keys” and “values” up to 48 chars.

// Plaintext prime modulus
unsigned long p = 131;
// Cyclotomic polynomial - defines phi(m)
//unsigned long m = 33;  // this will give 20 slots - runs faster
unsigned long m = 130; // this will give 48 slots
// Hensel lifting (default = 1)
unsigned long r = 1;
// Number of bits of the modulus chain
unsigned long bits = 1000;
// Number of columns of Key-Switching matrix (default = 2 or 3)
unsigned long c = 2;
// Size of NTL thread pool (default =1)
unsigned long nthreads = 1;
// debug output (default no debug output)
unsigned long debug = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createCapitalQuery:(NSString *)countryQuery {
    
      helib::ArgMap amap;
      amap.arg("p", p);
      amap.arg("m", m);
      amap.arg("debug", debug);
      amap.arg("nthreads", nthreads);

      // set NTL Thread pool size
      if (nthreads > 1)
        NTL::SetNumThreads(nthreads);
      
       std::cout << "\n*********************************************************";
       std::cout << "\n*           Privacy Preserving Search Example           *";
       std::cout << "\n*           =================================           *";
       std::cout << "\n*                                                       *";
       std::cout << "\n* This is a sample program for education purposes only. *";
       std::cout << "\n* It implements a very simple homomorphic encryption    *";
       std::cout << "\n* based db search algorithm for demonstration purposes. *";
       std::cout << "\n*                                                       *";
       std::cout << "\n*********************************************************";
       std::cout << std::endl;
    
       std::cout << "---Initialising HE Environment ... ";
       // Initialize context
       std::cout << "\n\tContext ... ";
       FHE_NTIMER_START(timer_Context);
       helib::Context context(m, p, r);
       FHE_NTIMER_STOP(timer_Context);
      
     // Modify the context, adding primes to the modulus chain
     std::cout  << "Building modulus chain..." << std::endl;
     dispatch_async(dispatch_get_main_queue(), ^(void){
         [self.logging setStringValue:[NSString stringWithFormat:@"Building modulus chain..."]];
         [self.delegate databaseSearchStarted];
         [self.countryLabel setStringValue:countryQuery];
         [self.capitalResultLabel setStringValue:@"Capital: "];
         [self.progressBar startAnimation:self];
        [self startTimer];
     });
     FHE_NTIMER_START(timer_CHAIN);
     helib::buildModChain(context, bits, c);
     FHE_NTIMER_STOP(timer_CHAIN);

     // Secret key management
     std::cout << "\nCreating Secret Key ...";
     FHE_NTIMER_START(timer_SecKey);
     // Create a secret key associated with the context
     helib::SecKey secret_key = helib::SecKey(context);
     // Generate the secret key
     secret_key.GenSecKey();
     FHE_NTIMER_STOP(timer_SecKey);
     
     dispatch_async(dispatch_get_main_queue(), ^(void){
         [self.logging setStringValue:[NSString stringWithFormat:@"Creating secret key..."]];
     });
     
     std::cout << "Generating key-switching matrices..." << std::endl;
     dispatch_async(dispatch_get_main_queue(), ^(void){
          [self.logging setStringValue:[NSString stringWithFormat:@"Generating key-switching matrices..."]];
     });
     // Compute key-switching matrices that we need
     FHE_NTIMER_START(timer_SKM);
     helib::addSome1DMatrices(secret_key);
     FHE_NTIMER_STOP(timer_SKM);

     
      // Public key management
    // Set the secret key (upcast: FHESecKey is a subclass of FHEPubKey)
    std::cout << "\nCreating Public Key ...";
    FHE_NTIMER_START(timer_PubKey);
    const helib::PubKey& public_key = secret_key;
    FHE_NTIMER_STOP(timer_PubKey);
      
    // Get the EncryptedArray of the context
    const helib::EncryptedArray& ea = *(context.ea);
    
    // Print the context
    std::cout << std::endl;
    if (debug)
        context.zMStar.printout();
    
    // Print the security level
    // Note: This will be negligible to improve performance time.
    std::cout << "\n***Security: " << context.securityLevel()
              << " (Negligible for this example)" << std::endl;
    
     
    
     // Get the number of slot (phi(m))
     long nslots = ea.size();
     std::cout << "\nNumber of slots: " << nslots << std::endl;
     dispatch_async(dispatch_get_main_queue(), ^(void){
         [self.logging setStringValue:[NSString stringWithFormat:@"Number of slots: %ld", nslots]];
     });
    
      /************ Create the database ************/
     
    std::vector<std::pair<std::string, std::string>> country_db = {
         { "Albania", "Tirana" },
         { "Andorra", "Andorra la Vella" },
         { "Austria", "Vienna" },
         { "Belarus", "Minsk" },
         { "Belgium", "Brussels" },
         { "Bosnia and Herzegovina", "Sarajevo" },
         { "Bulgaria", "Sofia" },
         { "Croatia", "Zagreb" },
         { "Czech Republic", "Prague" },
         { "Denmark", "Copenhagen" },
         { "Estonia", "Tallinn" },
         { "Finland", "Helsinki" },
         { "France", "Paris" },
         { "Germany", "Berlin" },
         { "Greece", "Athens" },
         { "Hungary", "Budapest" },
         { "Iceland", "Reykjavík" },
         { "Ireland", "Dublin" },
         { "Italy", "Rome" },
         { "Latvia", "Riga" },
         { "Liechtenstein", "Vaduz" },
         { "Lithuania", "Vilnius" },
         { "Luxembourg", "Luxembourg" },
         { "Malta", "Valletta" },
         { "Moldova", "Chisinau" },
         { "Monaco", "Monaco" },
         { "Montenegro", "Podgorica" },
         { "Netherlands", "Amsterdam" },
         { "Norway", "Oslo" },
         { "Poland", "Warsaw" },
         { "Portugal", "Lisbon" },
         { "Romania", "Bucharest" },
         { "Russia", "Moscow" },
         { "San Marino", "San Marino" },
         { "Serbia", "Belgrade" },
         { "Slovakia", "Bratislava" },
         { "Slovenia", "Ljubljana" },
         { "Spain", "Madrid" },
         { "Sweden", "Stockholm" },
         { "Switzerland", "Bern" },
         { "Turkey", "Ankara" },
         { "Ukraine", "Kiev" },
         { "England", "London" },
         { "Scotland", "Edinburgh" },
         { "Wales", "Cardiff" },
         { "Northern Ireland", "Belfast" }
     };

     // Convert strings into numerical vectors
     std::cout << "\n---Initializing the encrypted key,value pair database ("
               << country_db.size() << " entries)..." << std::endl;
     std::cout
         << "\tConverting strings to numeric representation into Ptxt objects ..."
         << std::endl;

     // Generating the Plain text representation of Country DB
     FHE_NTIMER_START(timer_PtxtCountryDB);
     std::vector<std::pair<helib::Ptxt<helib::BGV>, helib::Ptxt<helib::BGV>>>
         country_db_ptxt;
     for (const auto& country_capital_pair : country_db) {
     if (debug) {
         std::cout << "\t\tname_addr_pair.first size = "
                   << country_capital_pair.first.size() << " (" << country_capital_pair.first
                   << ")"
                   << "\tname_addr_pair.second size = "
                   << country_capital_pair.second.size() << " (" << country_capital_pair.second
                   << ")" << std::endl;
     }

     helib::Ptxt<helib::BGV> country(context);
     // std::cout << "\tname size = " << name.size() << std::endl;
     for (long i = 0; i < country_capital_pair.first.size(); ++i)
         country.at(i) = country_capital_pair.first[i];

     helib::Ptxt<helib::BGV> capital(context);
     for (long i = 0; i < country_capital_pair.second.size(); ++i)
         capital.at(i) = country_capital_pair.second[i];
         country_db_ptxt.emplace_back(std::move(country), std::move(capital));
     }
     FHE_NTIMER_STOP(timer_PtxtCountryDB);

     // Encrypt the Country DB
     std::cout << "Encrypting the database..." << std::endl;
     FHE_NTIMER_START(timer_CtxtCountryDB);
     std::vector<std::pair<helib::Ctxt, helib::Ctxt>> encrypted_country_db;
     for (const auto& country_capital_pair : country_db_ptxt) {
        helib::Ctxt encrypted_country(public_key);
        helib::Ctxt encrypted_capital(public_key);
        public_key.Encrypt(encrypted_country, country_capital_pair.first);
        public_key.Encrypt(encrypted_capital, country_capital_pair.second);
        encrypted_country_db.emplace_back(encrypted_country, encrypted_capital);
     }
    FHE_NTIMER_STOP(timer_CtxtCountryDB);
    
     // Print DB Creation Timers
     if (debug) {
       helib::printNamedTimer(std::cout << std::endl, "timer_Context");
       helib::printNamedTimer(std::cout, "timer_Chain");
       helib::printNamedTimer(std::cout, "timer_SecKey");
       helib::printNamedTimer(std::cout, "timer_SKM");
       helib::printNamedTimer(std::cout, "timer_PubKey");
       helib::printNamedTimer(std::cout, "timer_PtxtCountryDB");
       helib::printNamedTimer(std::cout, "timer_CtxtCountryDB");
     }

     std::cout << "\nInitialization Completed - Ready for Queries" << std::endl;
     std::cout << "--------------------------------------------" << std::endl;

     /** Create the query **/
    
     std::string query_string = std::string([countryQuery UTF8String]);;
     std::cout << "\nQuery in string form: " << query_string << std::endl;
     dispatch_async(dispatch_get_main_queue(), ^(void){
         [self.logging setStringValue:[NSString stringWithFormat:@"Creating Encrypted query"]];
     });
    
     FHE_NTIMER_START(timer_TotalQuery);

     FHE_NTIMER_START(timer_EncryptQuery);
     // Convert query to a numerical vector
     helib::Ptxt<helib::BGV> query_ptxt(context);
     for (long i = 0; i < query_string.size(); ++i)
       query_ptxt[i] = query_string[i];

     // Encrypt the query
     helib::Ctxt query(public_key);
     public_key.Encrypt(query, query_ptxt);
     FHE_NTIMER_STOP(timer_EncryptQuery);

     /************ Perform the database search ************/

     dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.logging setStringValue:[NSString stringWithFormat:@"Looking for the Capital of %@", countryQuery]];
     });
     FHE_NTIMER_START(timer_QuerySearch);
     std::vector<helib::Ctxt> mask;
     mask.reserve(country_db.size());
     for (const auto& encrypted_pair : encrypted_country_db) {
       helib::Ctxt mask_entry = encrypted_pair.first; // Copy of database key
       mask_entry -= query;                           // Calculate the difference
       mask_entry.power(p - 1);                       // Fermat's little theorem
       mask_entry.negate();                           // Negate the ciphertext
       mask_entry.addConstant(NTL::ZZX(1));           // 1 - mask = 0 or 1
       // Create a vector of copies of the mask
       std::vector<helib::Ctxt> rotated_masks(ea.size(), mask_entry);
       for (int i = 1; i < rotated_masks.size(); i++)
         ea.rotate(rotated_masks[i], i);             // Rotate each of the masks
       totalProduct(mask_entry, rotated_masks);      // Multiply each of the masks
       mask_entry.multiplyBy(encrypted_pair.second); // multiply mask with values
       mask.push_back(mask_entry);
     }

    // Aggregate the results into a single ciphertext
    // Note: This code is for educational purposes and thus we try to refrain
    // from using the STL and do not use std::accumulate
    helib::Ctxt value = mask[0];
    for (int i = 1; i < mask.size(); i++)
        value += mask[i];
    
    FHE_NTIMER_STOP(timer_QuerySearch);
    
     /************ Decrypt and print result ************/

     dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.logging setStringValue:[NSString stringWithFormat:@"Decrypting the Result"]];
     });
    
     FHE_NTIMER_START(timer_DecryptQueryResult);
     helib::Ptxt<helib::BGV> plaintext_result(context);
     secret_key.Decrypt(plaintext_result, value);
     FHE_NTIMER_STOP(timer_DecryptQueryResult);

     // Convert from ASCII to a string
     std::string string_result;
     for (long i = 0; i < plaintext_result.size(); ++i)
       string_result.push_back(static_cast<long>(plaintext_result[i]));

     FHE_NTIMER_STOP(timer_TotalQuery);

     std::cout << "\nQuery result: " << plaintext_result << std::endl;
     // Print DB Query Timers
     if (debug) {
       helib::printNamedTimer(std::cout << std::endl, "timer_EncryptQuery");
       helib::printNamedTimer(std::cout, "timer_QuerySearch");
       helib::printNamedTimer(std::cout, "timer_DecryptQueryResult");
       helib::printNamedTimer(std::cout, "timer_TotalQuery");
     }
     dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.logging setStringValue:[NSString stringWithFormat:@"Result:"]];
        [self.capitalResultLabel setStringValue:[NSString stringWithFormat:@"Capital: %s", string_result.c_str()]];
        [self.progressBar stopAnimation:self];
        [self.timeTicker invalidate];
        [self.delegate databaseSearchEnded];
     });
}

- (void)startTimer {
    [self.timeGone setStringValue:[NSString stringWithFormat:@"%.1f", [self convertTime:0.0]]];
    self.timeTicker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimerActivity) userInfo:nil repeats:YES];
}

- (void)showTimerActivity {
    int currentTime = self.timeGone.stringValue.intValue;
    float newTime = [self convertTime:currentTime + 1];
    [self.timeGone setStringValue:[NSString stringWithFormat:@"%.1f", newTime]];
}

- (float)convertTime:(int)newTime {
    return float(newTime);
}

@end
