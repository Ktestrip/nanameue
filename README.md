# nanameue

## dependencies

the project needs [swiftlint](https://github.com/realm/SwiftLint) in order to compile correctly

assuming you're using `Brew`, type 

```shell
brew install swiftlint
```

install [pods](https://cocoapods.org/)

clone the repository, access `Nanameue` folder

type 

```shell
pod install
```

wait for dependencies install


## How The project was built

I divided the project in way that I created One branch for one `Feature`

I considered as a `Feature` one fonctionnality that could be build on isolation by itself, that could be unit tested and that would bring a new functionnality to the app. You change access `Pull request` to see all the request, and so each feature, that was made to reach the final result

I tried to make it really easy to test each components and tried to seperate as much as it would make sense to each components.

eg : `PostProviderController` provide all func related to the creation / deletion / fetch of the post. It wouldn't had make sense to split each responsability into smaller pieces of code

No view controller depends on concrete implementation of controller, instead the depends only on abstractions. this way they can be replace by mock during unit testing

Design is not my best point, but all color does support switch between light and dark mode. Icon does the same if it's needed.

The app is built only to run on iOS 15 devices. iOS 16 haven't be tried so glitches could occured

all constraints have been done through AutoLayout usage.

only `Xib` are used, `Storyboard` remains intact

I really focused on doing the cleanest things, most testable things, and easier things to understand. No black magic, or dark undocummented API usage

About third party, only robust and trusted third party libraries are used. I pick them the same way I would do for a professionnal project. checking number of star, issues, number of answer to this library on SO, and asking myself if it exactly cover 100% of my needs.

Firebase is used as a backend

built on Xcode 13.4.1


