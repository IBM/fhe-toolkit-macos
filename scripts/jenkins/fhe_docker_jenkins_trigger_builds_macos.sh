#/bin/bash 


# MIT License
# 
# Copyright (c) 2020 International Business Machines
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# Navigate to the top level of the Repo
pushd ../../
set -x 
set -u
set -e

#BUILD_TYPE=$1
#SLACK_HOOK=$2


xcodebuild -workspace fhe-toolkit-macos.xcworkspace -scheme "Privacy Preserving Search" test
xcodebuild -workspace fhe-toolkit-macos.xcworkspace -scheme "Credit Card Fraud" test



#Leave this in for now  but comment out till we decide to use slack notifications
#Make A Notification in the Slack Channel about a new artifact in the repo
#pushd scripts/jenkins
#./fhe_artifactory_notification_script.sh $SLACK_HOOK "macOS" $BUILD_TYPE $ARTE_URL




