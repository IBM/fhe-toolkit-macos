//
//  HDF5DatasetExample.m
//  Credit Card Fraud
//
//  Created by boland on 7/22/20.
//  Copyright © 2020 IBM. All rights reserved.
//

#import "HDF5DatasetExample.h"

#include <iostream>

#include "HelibCkksContext.h"
#include "HelibConfig.h"
#include "FileUtils.h"
#include "SimpleNeuralNetPlain.h"
#include "SimpleNeuralNet.h"
#include "SimpleTrainingSet.h"
#include "CipherMatrixEncoder.h"

#include "H5Cpp.h"
#include "h5Dumper.h"

using namespace H5;

const H5std_string    FILE_NAME("h5tutr_dset.h5");
const H5std_string    DATASET_NAME("dset");
const int     NX = 4;                     // dataset dimensions
const int     NY = 6;
const int     RANK = 2;

@implementation HDF5DatasetExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
