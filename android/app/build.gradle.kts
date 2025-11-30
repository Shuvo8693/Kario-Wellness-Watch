plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.kario_wellness_watch"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.kario_wellness_watch"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    sourceSets {
        getByName("main") {
            jniLibs.srcDirs("src/main/libs")
        }
    }
    lint {
        baseline = file("lint-baseline.xml")
    }

}

dependencies {
    // Add this to include .aar and .jar files
//    implementation(fileTree(mapOf("dir" to "src/main/libs", "include" to listOf("*.jar", "*.aar"))))

    // OR explicitly reference the aar file
    implementation(files("src/main/libs/bluetoothsdk-release.aar"))
    implementation(files("src/main/libs/net-release.aar"))
    implementation(files("src/main/libs/rtk-core-1.2.9.jar"))
    implementation(files("src/main/libs/rtk-dfu-3.4.2.jar"))

    // Flutter
    // implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version")

    // Coroutines for async operations
    // implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
}

flutter {
    source = "../.."
}