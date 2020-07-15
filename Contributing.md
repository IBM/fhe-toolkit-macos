# Contributing to the IBM Fully Homomorphic Toolkit for MacOS

Adding new features, improving documentation, fixing bugs, writing new tests, designing and coding new examples or writing tutorials are all examples of helpful contributions.

We kindly request that any bug fixes be initiated through GitHub pull requests (PRs). 

## Prerequisits
If you are new to GitHub, you can find useful documentation [here][1], and information on the `git` version control system in this [handbook][2].

## Coding convention
This toolkit comprises a combination of `bash scripts` for setting up the environment and  `Objective C` for coding the examples. When making code contributions to this toolkit, we ask you to follow the [Shell Style Guide][3] for bash scripting and the [Objective-C Style Guide][4] for Objective-C code. Any future contributions in Swift should follow the [Swift Style Guild][5].

We also ask that contributions of new code for features come complete with unit tests for those new features.

## Steps to contribute 
When contributing to IBM Fully Homomorphic Toolkit for MacOS, we ask you to follow some simple steps:
- Create a new git [`issue`][6] describing the type of contribution (new feature,
documentation, bug fix, new tests, new examples, tutorial, etc) and assigning it to 
yourself, this will help to inform others that you are working on the contribution 
and if you want, it is also a vehicle to ask for help with it.
- Create your own git [`fork`][7] of this repository to work on the intended contribution.
- Once the contribution is complete, tested, documented and ready for review by 
the committer team, please initiate a GitHub [`pull request`][8] into the `master` branch 
from **your fork of the repository**.

## Signing off your contribution
This project uses [DCO][9]. Be sure to [sign off][10] your contributions using the `-s` flag or adding `Signed-off-By: Name<Email>` in the git commit message. We will not be able to accept non-signed contributions.

### Example commit message
```bash
git commit -s -m 'Informative commit message'
```

  [1]: https://docs.github.com/en/github/using-git    "GitHubDocs"
  [2]: https://guides.github.com/introduction/git-handbook/    "gitHandbook"
  [3]: https://google.github.io/styleguide/shellguide.html    "ShellStyle"
  [4]: https://google.github.io/styleguide/objcguide.html    "ObjectiveCStyle"
  [5]: https://google.github.io/swift/    "SwiftStyle"
  [6]: https://docs.github.com/en/github/managing-your-work-on-github/managing-your-work-with-issues   "gitIssue"
  [7]: https://docs.github.com/en/github/getting-started-with-github/fork-a-repo    "gitFork"
  [8]: https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork    "GitHubPullReq"    
  [9]: https://developercertificate.org/    "DCO"
  [10]: https://docs.github.com/en/github/authenticating-to-github/signing-commits    "gitSignoff"


