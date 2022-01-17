import java.io.File
import java.io.FileInputStream
import java.util.*

private fun getFile(path: String, file: String): File {
    return File("$path/$file")
}

private fun getProperty(file: String, property: String): String {
    val properties = Properties()
    properties.load(FileInputStream(file))
    return properties.getProperty(property)
}

fun getSignFile(path: String, properties: String): File =
    getFile(path, getProperty("$path/$properties", "KEYSTORE_FILE"))

fun getSignFilePassword(file: String): String = getProperty(file, "KEYSTORE_PASSWORD")
fun getSignAlias(file: String) = getProperty(file, "KEY_ALIAS")
fun getSignAliasPassword(file: String) = getProperty(file, "KEY_PASSWORD")

object Versions {
    const val firestore = "2.1.0"
    const val shadowJar = "5.1.0"
    const val kotlin = "1.4.30"
    const val versionCode = 13
    const val versionName = "0.1.3"
    const val coroutines = "1.4.2"
    const val serialization = "1.0.0"
    const val ktor = "1.4.2"
    const val kodein = "6.4.0"
    const val mockito = "2.2.0"
    const val assertj = "3.11.1"
    const val gson = "2.8.6"
    const val klock = "1.8.4"
    const val decimal = "0.2.0"

    const val security = "1.1.0-alpha01"

    const val appengine = "1.9.60"
    const val appenginePlugin = "2.1.0"
    const val gcplog = "0.117.0-alpha"
    const val logger = "1.2.1"
    const val web3j = "5.0.0"

    object Android {
        const val targetSdk = 28
        const val minSdk = 28
        const val versionCode = Versions.versionCode
        const val versionName = Versions.versionName
    }
}

object Dependencies {
    object Root {
        const val android = "com.android.tools.build:gradle:3.6.3"
        const val serialization = "org.jetbrains.kotlin:kotlin-serialization:${Versions.kotlin}"
        const val cocoapods = "co.touchlab:kotlinnativecocoapods:0.6"
        const val appengine = "com.google.cloud.tools:appengine-gradle-plugin:${Versions.appenginePlugin}"
        const val shadowJar = "com.github.jengelman.gradle.plugins:shadow:${Versions.shadowJar}"
    }

    object Backend {
        const val logger = "ch.qos.logback:logback-classic:${Versions.logger}"

        const val ktorNetty = "io.ktor:ktor-server-netty:${Versions.ktor}"
        const val ktorCore = "io.ktor:ktor-server-core:${Versions.ktor}"
        const val ktorAuth = "io.ktor:ktor-auth:${Versions.ktor}"
        const val ktorJwt = "io.ktor:ktor-auth-jwt:${Versions.ktor}"
        const val ktorGson = "io.ktor:ktor-gson:${Versions.ktor}"
        const val ktorServlet = "io.ktor:ktor-server-servlet:${Versions.ktor}"

        const val gcplog = "com.google.cloud:google-cloud-logging-logback:${Versions.gcplog}"
        const val appengine = "com.google.appengine:appengine:${Versions.appengine}"
    }

    object Android {
        const val core = "androidx.core:core-ktx:1.1.0"
        const val appCompat = "androidx.appcompat:appcompat:1.1.0"
        const val constraintLayout = "androidx.constraintlayout:constraintlayout:2.0.2"
        const val recycler = "androidx.recyclerview:recyclerview:1.2.0-alpha01"
        const val material = "com.google.android.material:material:1.2.0-alpha03"
        const val fragment = "androidx.fragment:fragment:1.1.0"
        const val fragmentKtx = "androidx.fragment:fragment-ktx:1.1.0"

        // Kodein
        const val kodeinJvm = "org.kodein.di:kodein-di-generic-jvm:${Versions.kodein}"
        const val kodeinX = "org.kodein.di:kodein-di-framework-android-x:${Versions.kodein}"

        const val mockito = "com.nhaarman.mockitokotlin2:mockito-kotlin:${Versions.mockito}"
        const val kotlinCorroutines =
            "org.jetbrains.kotlinx:kotlinx-coroutines-test:${Versions.coroutines}"

        const val gson = "com.google.code.gson:gson:${Versions.gson}"

        object Test {
            const val assertj = "org.assertj:assertj-core:${Versions.assertj}"
        }


        const val slf4j = "org.slf4j:slf4j-nop:1.7.25"
    }

    object Common {
        object Main {
            const val coroutines =
                "org.jetbrains.kotlinx:kotlinx-coroutines-core:${Versions.coroutines}"
            const val serialization =
                "org.jetbrains.kotlinx:kotlinx-serialization-runtime-common:${Versions.serialization}"

            const val ktorClientCore = "io.ktor:ktor-client-core:${Versions.ktor}"
            const val ktorClientJson = "io.ktor:ktor-client-json:${Versions.ktor}"
            const val ktorSerialization = "io.ktor:ktor-client-serialization:${Versions.ktor}"
            const val ktorClientAuth = "io.ktor:ktor-client-auth:${Versions.ktor}"
            const val ktorLogging = "io.ktor:ktor-client-logging:${Versions.ktor}"

            const val stately = "co.touchlab:stately-common:1.0.3"
            const val klock = "com.soywiz.korlibs.klock:klock:${Versions.klock}"

            const val decimal = "com.ionspin.kotlin:bignum:${Versions.decimal}"
        }

        object Jvm {
            const val coroutines =
                "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.coroutines}"
            const val serialization =
                "org.jetbrains.kotlinx:kotlinx-serialization-runtime:${Versions.serialization}"

            const val ktorClientCore = "io.ktor:ktor-client-android:${Versions.ktor}"
            const val ktorClientJson = "io.ktor:ktor-client-json-jvm:${Versions.ktor}"
            const val ktorSerialization = "io.ktor:ktor-client-serialization-jvm:${Versions.ktor}"
            const val ktorClientAuth = "io.ktor:ktor-client-auth-jvm:${Versions.ktor}"
            const val ktorLogging = "io.ktor:ktor-client-logging-jvm:${Versions.ktor}"
            const val ktorTls = "io.ktor:ktor-network-tls:${Versions.ktor}"
            const val ktorCertificates =
                "io.ktor:ktor-network-tls-certificates:${Versions.ktor}"
            const val security = "androidx.security:security-crypto:${Versions.security}"

            const val decimal = "com.ionspin.kotlin:bignum:${Versions.decimal}"

            // Web3j 5.0.0
            const val web3j = "org.web3j:core:${Versions.web3j}"
        }

        object Native {
            const val coroutines =
                "org.jetbrains.kotlinx:kotlinx-coroutines-core-native:${Versions.coroutines}"
            const val serialization =
                "org.jetbrains.kotlinx:kotlinx-serialization-runtime-native:${Versions.serialization}"

            const val ktorClientCore = "io.ktor:ktor-client-ios:${Versions.ktor}"
            const val ktorClientJson = "io.ktor:ktor-client-json-native:${Versions.ktor}"
            const val ktorSerialization =
                "io.ktor:ktor-client-serialization-native:${Versions.ktor}"
            const val ktorClientAuth = "io.ktor:ktor-client-auth-native:${Versions.ktor}"
            const val ktorLogging = "io.ktor:ktor-client-logging-native:${Versions.ktor}"
        }
    }
}