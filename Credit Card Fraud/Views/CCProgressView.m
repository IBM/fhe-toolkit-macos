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


#import "CCProgressView.h"

@implementation CCProgressView

- (void)drawRect:(NSRect)dirtyRect {
//    [[NSColor whiteColor] setFill];
//    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

- (void)setup {
    [self.progressBar stopAnimation:self];
    [self.progressBar setDoubleValue:0.0];
    [self.progressAmountLabel setStringValue: [NSString stringWithFormat:@"%li / %li", (long)0, (long)0]];
    [self.doneCheckmark setHidden: YES];
}

- (void)start {
    self.currentTimeTick = 0;
    [self.spinningBar startAnimation:self];
    [self.spinningBar setHidden:NO];
    [self.progressBar startAnimation:self];
    [self.timeElapsed setHidden:NO];
    [self.startButton setHidden:YES];
    [self startTimer];
    
}

- (void)stop {
    [self.progressBar stopAnimation:self];
    [self.timeTicker invalidate];
    [self.spinningBar stopAnimation:self];
    [self.spinningBar setHidden:YES];
    [self.doneCheckmark setHidden: NO];
}

- (void) update:(NSInteger)currentAmount total:(NSInteger)totalAmount {
    if (currentAmount == 1) {
        [self.progressBar startAnimation:self];
    } else if (currentAmount == totalAmount) {
        [self.progressBar stopAnimation:self];
    }
    double percent = (double)currentAmount/(double)totalAmount*100.0;
    [self.progressBar setDoubleValue:percent];
    [self.progressAmountLabel setStringValue: [NSString stringWithFormat:@"%li / %li", (long)currentAmount, (long)totalAmount]];
    if (currentAmount == 24) {
        [self stop];
    }
}

- (void)startTimer {
    [self.timeElapsed setStringValue:[NSString stringWithFormat:@"%.1f", [self convertTime:0.0]]];
    self.timeTicker = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimerActivity) userInfo:nil repeats:YES];
}

- (void)showTimerActivity {
    int currentTime = self.currentTimeTick;
    float newTime = [self convertTime:currentTime + 1];
    self.currentTimeTick = newTime;
    int minutes = (int)newTime / 60;
    int seconds = (int)newTime % 60;
    [self.timeElapsed setStringValue:[NSString stringWithFormat:@"%i:%.2i", minutes, seconds]];
}

- (float)convertTime:(int)newTime {
    return (float)newTime;
}

@end
