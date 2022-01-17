pluginManagement {
    repositories {
        google()
        jcenter()
        gradlePluginPortal()
        mavenCentral()
    }

}
rootProject.name = "helios_wallet"


include(":androidSample")
include(":helioswallet")

enableFeaturePreview("GRADLE_METADATA")
