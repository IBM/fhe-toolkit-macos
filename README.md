----------------------------------------------------------------------------
IBM Fully Homomorphic Encryption Toolkit for MacOS
----------------------------------------------------------------------------

This source code is the packaged XCode project and resources needed to build the open source <a href="https://github.com/IBM-HElib/HElib/">HELib</a> <a href="https://en.wikipedia.org/wiki/Homomorphic_encryption">Fully Homomorphic Encryption</a> library on MacOS. If you are instead looking for the IBM Fully Homomorphic Encryption Tookit for Linux that provides a docker based toolkit for Linux developers, it can be found <a href="https://github.com/IBM/fhe-toolkit-linux" target="_blank">here</a>.

To learn more about FHE in general, and what it can be used for, you can check out our [FAQ/Content Solutions page](https://www.ibm.com/support/z-content-solutions/fully-homomorphic-encryption/).


--------------------------------------------
Compiling and Running the XCode Project
--------------------------------------------

If you want to dive right in and get started using the SDK, please see the [Getting Started Document](GettingStarted.md).


## Need Help to Get Started?

Corporate clients can email fhestart@us.ibm.com to request a design thinking workshop about building FHE solutions for your business use cases at no cost for applicants accepted to our sponsor user program. For corporate support outside of our sponsor user program, <a href="https://www.ibm.com/security/services/homomorphic-encryption" target="_blank">IBM Security Homomorphic Encryption Services</a> can help unlock the value of your sensitive data without decrypting it to help maintain your privacy and compliance controls. Our trusted advisors offer commercial education, expert support and testing environments to build your prototype applications. 



Feedback Survey
----------------------------------------------------------------------------
 
"IBM invites you to participate in our Advanced Security and Encryption Survey. This survey is designed to gather insights around the security challenges you or your organization face and better understand our users and how to serve you better. We will only use your feedback to improve the FHE Toolkit experience and inform future IBM security-focused products and services. IBM will not share your response data with any third parties. We look forward to your valuable feedback to improve the IBM Fully Homomorphic Encryption Toolkit for macOS, iOS, and Linux."

https://www.surveygizmo.com/s3/5731822/Advanced-Security-And-Encryption-Survey-2020


----------------------------------------------------------------------------
About Xcode Projects
----------------------------------------------------------------------------

If you are a developer interested in Homomorphic Encryption and you use a MacOS development machine, this project will help you get started with a pre-configured [Xcode](https://developer.apple.com/xcode/) Project that can save you time. If you are new to Xcode, an Xcode project is a directory structure for all the resources needed to build one or more software using the Xcode IDE from Apple.  You can install Xcode directly through the App Store. 

The contents of this Xcode project includes the pre-determined compilation procedure and the required dependency relationships between source code modules. Typically an Xcode project contains one or more build targets, which specify the compilation procedure for the final executable or library products. This project comes complete with default build settings for HELib as well as the two external dependencies required by HELib, namely [The GNU Multiple Precision Arithmetic Library (GMP)](https://gmplib.org/) and [NTL Lib](https://www.shoup.net/ntl/) which is a number theoretic library.

The targets of the project are:
	
* Privacy Preserving Search (sample app)
* Credit Card Fraud (sample app)
* HElib Library




--------------------------------------------
Source Code Overview:
--------------------------------------------

The code base is split up into a few major components.  Upon initial installation, a script is needed to download and compile the source code and its dependencies.  This code is then accessed through the Xcode workspace, `fhe-toolkit-macos.xcworkspace`.  Always use the workspace when trying to work with any of these components.  

* The Helib source code is a copy of the public open source repo of [HElib](https://github.com/IBM-HElib/HElib).  The files have been compiled into a static library and linked to the `fhe-toolkit-macos` project file.  This is done through a shared workspace.  All work should be done through the `fhe-toolkit-macos.xcworkspace` file.

* The `include/helib` directory contains all of the .h files that are a copy of the public open source repo of [HElib](https://github.com/IBM-HElib/HElib).  None of these files have been modified from the original files from that repo, but they need to be included in the Xcode project in order to build.  In the Xcode project, under the target, under `Build Settings`, there is a path that links to these files under `Header Search Paths`.  The current path is a relative path to the files from your system directory.  They currently reside in `dependencies/HElib/include`.  If you change the location of these files it will be neccessary to update this path.

* The Helib library has two dependencies from other open source libraries.  They are built when the `setup.sh` script is run for the first time.  They currently build for the x86_64 ARCHITECTURE and get added to the `dependencies` folder.  Nothing needs to be done with them, but they are linked as relative paths on the target, in `Build Settings` under `Library Search Paths`, for the .a files, and `Header Search Paths` for the .h files.  Again if you alter the location of these files, you will need to update these paths accordingly.

    * ntl                       
    * gmplib-so-macosx-x86_64


--------------------------------------------
fhe-toolkit-macos.xcworkspace
--------------------------------------------
A workspace is an Xcode document that groups projects and other documents so you can work on them together. A workspace can contain any number of Xcode projects, plus any other files you want to include.  

This workspace contains the macOS sample code for building a sample macOS application as well as the helib target for building the helib.a static library.


--------------------------------------------
fhe-toolkit-macos.xcodeproj
--------------------------------------------
This directory contains the project files describing the XCode build environment. 

These are files that Xcode manages to help the developer create and build the app.  These files are generally not altered by hand.
 
* project.xcworkspace	 
* xcshareddata/xcschemes  	
* project.pbxproj 

--------------------------------------------
fhe-toolkit-macos
--------------------------------------------

This is the Xcode Directory that contains all of the files that are neccessary to build the macOS target.  Inside here are two sample applications.  Privacy Preserving Search and Credit Card Fraud.

##### Privacy Preserving Search

The Helib files are imported into the `CountryTableViewController.mm` 

* Assets.xcassets	- directory structure where all assets (art, icons, images, etc) are held
* AppDelegate - Main entry point to application. Handles responsibilities for when the app is launched or closed
* Info.plist	- The file that contains app settings
* CountryData - The object that contains the data for the split view controller  
* CapitalDetailViewController - The side of the split view controller that contains the details about the country.  This is where the code utilizes the Helib library.
* CountryTableViewController - the "left" side of the split view that contains all of the countries to click
* CountryDisplaySplitViewController - The file that manages the split views 
* main.m	-	The start file that creates the Application, this is usually not altered in an macOS application

##### Credit Card Fraud


The Helib files are imported into the `CreditCardInferenceViewController.mm` 

* Assets.xcassets	- directory structure where all assets (art, icons, images, etc) are held
* AppDelegate - Main entry point to application. Handles responsibilities for when the app is launched or closed
* Info.plist	- The file that contains app settings
* CreditSampleResultsData - The object that contains the data that is returned from the inferencing 
* CreditCardInferenceViewController - The main window of the application that holds the UI for interacting with the program.  This is where the code utilizes the Helib library through a Client Server model.
* main.m	-	The start file that creates the Application, this is usually not altered in an macOS application





