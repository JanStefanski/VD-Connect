<img src="assets/icon/icon.png" align="center" height="256">

<p align="center">

# VD Connect

[Polski](README_pl.md) | [English](README.md) | [中文](README_zh.md)
</p>

Aplkacja towarzysząca dla naszego projektu Raspberry Pi. Wyświetla aktualny status i parametry stacji roboczej. Pozwala
na implementację niestandardowych komend, które można użyć do kontroli Raspberry Pi.

## Instalacja

Możesz pobrać aplikację ze [strony releases](https://github.com/JanStefanski/VD-Connect/releases/latest) i zainstalować
ją na swoim urządzeniu.

## Kompilacja i budowa kodu źródłowego

### Wymagania

Aby zbudować aplikację na Androida, musisz mieć instalowane następujące narzędzia:
- [Android SDK](https://developer.android.com/studio/index.html)
- [Java JDK](https://www.oracle.com/java/technologies/javase/downloads.html)
- [Flutter](https://flutter.dev)

Aby zbudować aplikację na iOS, musisz mieć instalowane następujące narzędzia:
- [Xcode](https://developer.apple.com/download/)
- [Flutter](https://flutter.dev)

Dodatkowo musisz zainstalować i skonfigurować serwer na Raspberry Pi. [Możesz pobrać kod serwera tutaj](https://github.com/JanStefanski/VD-Connect-Server)

### Klonowanie i konfiguracja

Po zainstalowaniu i skonfigurowaniu powyższych narzędzi, możesz sklonować repozytorium i przejść do folderu projektu:
```shell
git clone https://github.com/JanStefanski/VD-Connect.git
cd VD-Connect
```

Następnie, aby zainstalować zależności, uruchom komendę:
```shell
flutter pub get
```

Aby uruchomić aplikację, uruchom komendę:
```shell
flutter run
```

### Rozwiązywanie Błędów i Problemów

Aby skompilować aplikację w trybie debug i uruchomić ją na urządzeniu, musisz edytować plik `/android/app/build.gradle` i zmienić następujące wartości:
```
    buildTypes {
        release {
            signingConfig signingConfigs.release // <-- zmień "release" na "debug"
        }
    }
```

W przypadku problemów, możesz skorzystać z [dokumentacji Fluttera](https://flutter.dev/docs/).