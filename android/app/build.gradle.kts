android {
    namespace = "com.example.gestao_de_estagios"
    compileSdk = flutter.compileSdkVersion  // Use a versão do Flutter
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.estagiobloc"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion  // Use a versão do Flutter
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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
