// def localProperties = new Properties()
// def localPropertiesFile = rootProject.file('local.properties')
// if (localPropertiesFile.exists()) {
//     localPropertiesFile.withReader('UTF-8') { reader ->
//         localProperties.load(reader)
//     }
// }

// def flutterRoot = localProperties.getProperty('flutter.sdk')
// if (flutterRoot == null) {
//     throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
// }

// def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
// if (flutterVersionCode == null) {
//     flutterVersionCode = '1'
// }

// def flutterVersionName = localProperties.getProperty('flutter.versionName')
// if (flutterVersionName == null) {
//     flutterVersionName = '1.0'
// }

// apply plugin: 'com.android.application'
// apply plugin: 'kotlin-android'
// apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

// android {
//     compileSdkVersion 33
//     ndkVersion flutter.ndkVersion

//     compileOptions {
//         sourceCompatibility JavaVersion.VERSION_1_8
//         targetCompatibility JavaVersion.VERSION_1_8
//     }

//     kotlinOptions {
//         jvmTarget = '1.8'
//     }

//     sourceSets {
//         main.java.srcDirs += 'src/main/kotlin'
//     }

//     defaultConfig {
//         // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//         applicationId "com.example.recipez"
//         // You can update the following values to match your application needs.
//         // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-build-configuration.
//         minSdkVersion 21
//         targetSdkVersion 33
//         versionCode flutterVersionCode.toInteger()
//         versionName flutterVersionName
//     }

//     buildTypes {
//         release {
//             // TODO: Add your own signing config for the release build.
//             // Signing with the debug keys for now, so `flutter run --release` works.
//             signingConfig signingConfigs.debug
//         }
//     }
// }

// flutter {
//     source '../..'
// }

// dependencies {
//     implementation "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version"
//     implementation 'com.facebook.android:facebook-login:latest.release'
//     implementation platform('com.google.firebase:firebase-bom:31.2.0')
//     implementation 'com.google.firebase:firebase-auth'
//     implementation 'com.google.android.gms:play-services-auth:20.4.1'
// }
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.recipez"
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
        applicationId = "com.example.recipez"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
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
}

flutter {
    source = "../.."
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(17)
    }
}