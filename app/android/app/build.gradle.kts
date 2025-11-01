import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android Gradle plugin.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "life.personaltracker.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "life.personaltracker.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (!keystorePropertiesFile.exists()) {
                throw GradleException(
                    "Missing key.properties for release signing. " +
                        "Create the file or adjust the signing configuration."
                )
            }

            val storeFileProp = keystoreProperties["storeFile"]?.toString()
            val storePasswordProp = keystoreProperties["storePassword"]?.toString()
            val keyAliasProp = keystoreProperties["keyAlias"]?.toString()
            val keyPasswordProp = keystoreProperties["keyPassword"]?.toString()

            require(!storeFileProp.isNullOrBlank()) { "storeFile is missing in key.properties" }
            require(!storePasswordProp.isNullOrBlank()) { "storePassword is missing in key.properties" }
            require(!keyAliasProp.isNullOrBlank()) { "keyAlias is missing in key.properties" }
            require(!keyPasswordProp.isNullOrBlank()) { "keyPassword is missing in key.properties" }

            storeFile = rootProject.file(storeFileProp)
            storePassword = storePasswordProp
            keyAlias = keyAliasProp
            keyPassword = keyPasswordProp
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
