plugins {
    kotlin("multiplatform")
    id("kotlinx-serialization")
}
group = "com.accesscontrol.model"
version = "0.0.1"

kotlin {
    jvm()
    // iosX64("ios") {
    //     binaries {
    //         framework {
    //             baseName = "library"
    //         }
    //     }
    // }
    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation(Dependencies.Common.Main.coroutines)
            }
        }
        val commonTest by getting {
            dependencies {
                implementation(kotlin("test-common"))
                implementation(kotlin("test-annotations-common"))
            }
        }

        // val iosMain by getting
        // val iosTest by getting

        val jvmMain by getting {
            dependencies {
                implementation(Dependencies.Common.Jvm.web3j)
            }
        }
        val jvmTest by getting
    }
}

tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile::class.java) {
    sourceCompatibility = JavaVersion.VERSION_1_8.toString()
    targetCompatibility = JavaVersion.VERSION_1_8.toString()

    kotlinOptions {
        jvmTarget = "1.8"
    }
}
