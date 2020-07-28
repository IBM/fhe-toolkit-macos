//
//  CreditSampleResultsData.m
//  Credit Card Fraud
//
//  Created by boland on 7/28/20.
//  Copyright © 2020 IBM. All rights reserved.
//

#import "CreditSampleResultsData.h"

@implementation CreditSampleResultsData

- (id)initWithData:(CreditSampleResults *) sdata {
  self = [super init];
  if(self) {
      _sampleData = sdata;
  }
  return self;
}

- (void)dealloc {
  free(_sampleData);
  //[super dealloc];
}


@end
