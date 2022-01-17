buildscript {
    repositories {
        gradlePluginPortal()
        jcenter()
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.4.32")
        classpath("com.android.tools.build:gradle:4.1.1")

    }
}

group = "com.worldline"
version = "0.0.4"

allprojects {

    repositories {
        mavenLocal()
        google()
        jcenter()
        mavenCentral()
    }
}