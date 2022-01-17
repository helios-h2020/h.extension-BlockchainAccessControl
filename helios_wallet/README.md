# Helios Wallet

## Short Intro to the funcionality

With this module any user can create or import a existent wallet

### Basic Repo Architecture

This is a kotlin multiplatform module, which contains 5 modules. Currently, it only supports Android platform, but in the future, the iOS implementation could be developed for sure.


#### Core:
The core is the "wallet" module, it exposes the method that any app could use. The implementation is the common one in a kotlin multiplatform library. It has three sourcesets:
- `commonMain`: Here, we find the interfaces that the module will expose
- `jvmMain`: If we need an especific implementation for android, we do it here
- `iosMain`: If we need an especific implementation for iOS, we do it here

The module exposes the following class:

```kotlin
class Wallet {
    fun createWallet(pass: String): CreateWalletResponse
    fun getWalletCredentials(pass: String, mnemonic: String): WalletCredentials
}

```

Obviously, this class could be called from `Java` or `Kotlin`, it doesn't matter. Let us explain a little bit each function:

##### Create Wallet
```kotlin
 fun createWallet(pass: String): CreateWalletResponse
```

This function will be used when some user wants to generate a mnemonic:
```kotlin
data class CreateWalletResponse(
    val mnemonic: String,
)
```

##### Get Wallet Credentials
```kotlin
 fun createWallet(pass: String): CreateWalletResponse
```

This function will be used when user wants to:
 - Retrieve import a existent wallet providing a password and pnemonic
 - Retrieve a wallet created

```kotlin
 data class WalletCredentials(
     val address: String,
     val privateKey: String
 )
```

