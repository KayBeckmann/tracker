pluginManagement {
    val localProperties = java.util.Properties().apply {
        file("local.properties").inputStream().use { load(it) }
    }

    val flutterSdkPath =
        localProperties.getProperty("flutter.sdk")
            ?: error("flutter.sdk not set in local.properties")

    val flutterGradlePluginPath =
        localProperties.getProperty("flutter.gradle.plugin.dir")
            ?: "$flutterSdkPath/packages/flutter_tools/gradle"

    includeBuild(flutterGradlePluginPath)

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
