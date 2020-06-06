# Overview of Toolkit Functionality


This document will walk you through setting up Xcode to use this Github repository and running
a complete mobile application example step by step.








# Installing Required Tools 

This toolkit requires the Xcode IDE and some associated command line tools. It also requires the cmake build system to be installed. 




## Step 1: Install XCode and command line tools (1/2)


Before cloning the repo, install [Xcode](https://developer.apple.com/xcode/) and the Xcode Command line Tools.  The Xcode IDE is the core of the Apple-native development experience and privides a productive environment for building apps for Mac, iPhone, iPad, and other Apple hardware.

To install the required Xcode command line tools, open a Terminal, such as Terminal.app and type the following command: 

```
xcode-select --install
```




## Step 2: Install CMAKE (2/2)

CMake is an open-source, cross-platform family of tools thst can be used to build and test software source code. CMake is used to control the software compilation process using platform and compiler independent configuration files as well as generating native makefiles that work with a variety of compilers.

Precompiled MacOS binaries are available for cmake at https://cmake.org/download/. This documentation was tested with the available binary release that supports Mac OS X 10.7 or later, and is available directly from: [https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1-Darwin-x86_64.dmg](https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1-Darwin-x86_64.dmg)

If you do not currently have cmake installed, the setup script will install it for you as it is needed to build the libraries.




# Installing and Using the Toolkit in Xcode


To begin, open Xcode. If you are not presented with the Welcome to XCode screen, within the XCode IDE, Select Window -> “Welcome To Xcode” 



## Step 1: 
Select “Clone an existing Project” from the Welcome to Xcode screen. 
 
![Step one image](/Documentation/Images/Step%201.png?raw=true "Cloning and existing Project from the Welcome to Xcode screen")



## Step 2: 
Enter the Repository URL shown below. This URL can be found in the clone or download button of the GitHub repository. 

```
https://github.com/IBM/fhe-toolkit-macos.git
```

![Step two image](/Documentation/Images/Step%202.png?raw=true "Enter the repository URL")



## Step 3: 
You will next be asked which branch you would like to clone. Select the "master" branch as shown and click the clone button to begin the source code copy process. The clone may take a few minutes depending on your network bandwidth and connectivity. 

![Step three image](/Documentation/Images/Step%203.png?raw=true "Selecting the master branch")



## Step 4

Next you will be presented with a location where to download the locally cloned code. 
Select any location that makes sense for you and click the Clone button. 

**NOTE: You will need this location for our next step so remember the location**

Once the download completes, the cloned git repository is almost ready for use with Xcode. 

![Step four image](/Documentation/Images/Step%204.png?raw=true "Selecting a download location")


## Step 5: 
Now that you have the toolkit repo cloned, along with the automatically included dependency code repositories, we must first compile those dependency libraries. To do this you must use a terminal application and `cd` into the `dependencies` directory from the root of the repo. The root location was entered in the previous step. 


```
cd dependencies
```

Now from within the dependencies folder, you can trigger the `setup.sh` script to compile the dependency libraries (NTL and GMP). 

``` 
./setup.sh
```     
 

![Step five image](/Documentation/Images/Step%205.png?raw=true "Building Dependencies")


## Step 6:
After the dependencies finish building, go back to Xcode and open the workspace `fhe-toolkit-macos.xcworkspace`.  If you previously had it open close it and re-open.  Find the target called `helib` and make sure "My Mac" is selected. Press Build, the "Play" buton in the upper left hand corner.

![Step six image](/Documentation/Images/Step%206.png?raw=true "Building Helib")



## Step 7: 
Switch the Build target to `Privacy Preserving Search`, and Build the sample app with the embedded libraries and dependencies by clicking the “Play” button in the upper left hand corner
of the IDE to start the build process. You will notice the bar at the top will indicate the build
process is proceeding. 

![Step seven image](/Documentation/Images/Step%207.png?raw=true "Click the play button to start the sample app")



## Step 8: 
With the compilation of the mobile demonstration application complete, the app will launch, and you will see the sample application as shown. The demonstration is a complete example of a privacy preserving search against an unencrypted database. The database is a key value store prepopulated with the english names of countries and their capital cities from the continent of Europe. Selecting the country will perform a search of the matching capital. On a 2019 Macbook Pro laptop, the example searches take under 80 seconds. 

![Step eight image](/Documentation/Images/Step%208.png?raw=true "Sample app Screenshots")

