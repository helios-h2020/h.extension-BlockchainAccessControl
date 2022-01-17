buildscript {

    dependencies {
        classpath(Dependencies.Root.android)
        classpath(Dependencies.Root.serialization)
        classpath(Dependencies.Root.cocoapods)
        classpath(Dependencies.Root.appengine)
        classpath(Dependencies.Root.shadowJar)
        classpath(kotlin("gradle-plugin", Versions.kotlin))
    }

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven(url = "https://oss.sonatype.org/content/repositories/snapshots/")
        maven(url = "https://jitpack.io")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven(url = "https://oss.sonatype.org/content/repositories/snapshots/")
        maven(url = "https://jitpack.io")
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}