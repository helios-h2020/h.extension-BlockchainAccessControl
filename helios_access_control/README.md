# Access Control Module

Repository for the Helios access control module (ACM)


## Short Intro to the funcionality

With this module any user could give/deny permission to the resources by using the blockchain etherum technology. 

### Basic Repo Architecture

<img src="TODO" alt="TODO">

This is a kotlin multiplatform module, which contains 5 modules. Currently, it only supports Android platform, but in the future, the iOS implementation could be developed for sure.


#### Core:
The core is the "accesscontrol" module, it exposes the method that any app could use. The implementation is the common one in a kotlin multiplatform library. It has three sourcesets:
- `commonMain`: Here, we find the interfaces that the module will expose
- `jvmMain`: If we need an especific implementation for android, we do it here
- `iosMain`: If we need an especific implementation for iOS, we do it here

The module exposes the following class:

```kotlin
class AccessControl {
    suspend fun createAccessRequest(uri: String): Either<Error, Success>
    suspend fun checkAccessRequest(requester: String, owner: String, uri: String, accessKey: String): Either<Error, Int>
    suspend fun acceptAccessRequest(uri: String): Either<Error, Success>
    suspend fun rejectAccessRequest(uri: String): Either<Error, Success>
    suspend fun resetAccessRequest(uri: String): Either<Error, Success>
}

```

Obviously, this class could be called from `Java` or `Kotlin`, it doesn't matter. Let us explain a little bit each function:

##### Create access request
`suspend fun createAccessRequest(uri: String): Either<Error, Success>`

This function will be used when some user wants to access a resource from another, the module will create a request inside the smart contract. It needs the URI of the resource, and the module will notify the owner about the request (obviously, if the owner is checking it, see "Smart contract" section). The result of the function is represented by an `Either` class. See "FAQs" to learn about how `Either` works

`suspend fun checkAccessRequest(requester: String, owner: String, uri: String, accessKey: String): Either<Error, Int>`

This function will be used by an external service (like a backend) when wants to check if the requester has access to the resource. The method requires 3 parameters. See "FAQs" to learn about what is the `accessKey`.

`suspend fun acceptAccessRequest(uri: String): Either<Error, Success>`

Function used to grant access to an specific URI

`suspend fun rejectAccessRequest(uri: String): Either<Error, Success>`

Function used to deny access to an specific URI

`suspend fun resetAccessRequest(uri: String): Either<Error, Success>`

Function used to reset the request to an specific URI

#### Smart Contract:

#### Backend:
Open Intellij and Run the backend using the following command:
```
.\gradlew run:backend
```

#### Android Support:
TODO

#### iOS Support:
TODO

### How to compile:

TODO

- Install Git in your computer: https://github.com/git-guides/install-git

- Choose a directory from your computer and download with Git the code using the link provided in this page:

`git clone TODO`

- Open Android Studio/IntelliJ and open an existing project from the directory of your code downloaded. To install Android Studio follow the next link: https://developer.android.com/studio/install, in case of IntelliJ, this one: https://www.jetbrains.com/idea/

### Library generation

#### Manually
To generate aar file, make module 'accesscontrol' and look for the aar file generated in output folder.
If y

### Request permissions

There are non additional permissions needed.


## Multiproject dependencies

This repository doesn't need any extra dependency so you don't have to download another repository


