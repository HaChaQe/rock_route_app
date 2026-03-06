plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// 🤘 SENIOR DOKUNUŞU: .env dosyasını okuyan Kotlin scripti
import java.util.Properties

val envProperties = Properties()
// Flutter'ın ana dizinindeki .env dosyasını buluyoruz
val envFile = rootProject.file("../.env")
if (envFile.exists()) {
    envFile.inputStream().use { stream ->
        envProperties.load(stream)
    }
}

android {
    namespace = "com.chaash.rockroute.rock_route"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.chaash.rockroute.rock_route"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 🤘 ŞİFREYİ .ENV'DEN ÇEKİP ANDROID'E ŞIRINGA EDİYORUZ
        val mapsApiKey = envProperties.getProperty("GOOGLE_API_KEY") ?: ""
        manifestPlaceholders["mapsApiKey"] = mapsApiKey
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}