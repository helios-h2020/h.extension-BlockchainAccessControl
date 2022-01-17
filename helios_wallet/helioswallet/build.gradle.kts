plugins {
    kotlin("multiplatform")
    kotlin("native.cocoapods")
    id("com.android.library")
    id("kotlin-android-extensions")
    id("maven-publish")
}

group = "com.worldline"
version = "0.0.5"

kotlin {
    android {
        publishAllLibraryVariants()
        publishLibraryVariantsGroupedByFlavor = true
    }

    val onPhone = System.getenv("SDK_NAME")?.startsWith("iphoneos") ?: false
    /*if (onPhone) {
        iosArm64("ios")
    } else {
        iosX64("ios")
    }*/

    sourceSets {
        // all {
        //     languageSettings.apply {
        //         useExperimentalAnnotation("kotlin.RequiresOptIn")
        //         useExperimentalAnnotation("kotlinx.coroutines.ExperimentalCoroutinesApi")
        //     }
        // }
        val commonMain by getting {
            dependencies {
                implementation(kotlin("stdlib-common"))
            }
        }
        val commonTest by getting {
            dependencies {
                implementation(kotlin("test-common"))
                implementation(kotlin("test-annotations-common"))
            }
        }
        val androidMain by getting {
            dependencies {
                implementation("com.google.android.material:material:1.3.0")
                implementation("org.web3j:core:5.0.0")
            }
        }
        val androidTest by getting {
            dependencies {
                implementation(kotlin("test-junit"))
                implementation("junit:junit:4.13.2")
            }
        }
        //val iosMain by getting
        //val iosTest by getting
    }

    cocoapods {
        ios.deploymentTarget = "13.5"
        // if (onPhone) {
        //     ios.deploymentTarget = "13.5"
        // } else {
        // }

        summary = "Common library for the KaMP starter kit"
        homepage = "https://github.com/touchlab/KaMPKit"
        frameworkName = "helioswallet"
        // pod("web3swift")
    }

    targets.withType<org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget> {
        binaries.withType<org.jetbrains.kotlin.gradle.plugin.mpp.Framework> {
            isStatic = false
            export(project(":helioswallet"))
        }
    }
}

android {
    compileSdkVersion(30)
    sourceSets["main"].manifest.srcFile("src/androidMain/AndroidManifest.xml")
    defaultConfig {
        minSdkVersion(24)
        targetSdkVersion(30)
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    lintOptions {
        isAbortOnError = true
    }
}