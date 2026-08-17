# Android Platform Configuration

Decisions recorded here are required by `PRODUCT_REPORT.md` §30.6 ("Minimum and
target Android SDK versions must be selected deliberately during project
initialization and documented"). Change them only with the product owner's
agreement — each one is expensive to reverse after release.

## Application identity

| Setting | Value |
|---|---|
| `applicationId` | `com.knosis.reader` |
| Kotlin `namespace` | `com.knosis.reader` |
| App label | Knosis |

`applicationId` is the permanent Play Store identity. Changing it after
publishing creates a second, unrelated listing and orphans every existing
install, so it was chosen before the first release rather than inherited from
the `flutter create` template (which produced `com.knosis.knosis`).

## SDK levels

| Setting | Value | Rationale |
|---|---:|---|
| `minSdk` | 26 | Android 8.0. Predictable scoped file access and text rendering for the reader, fewer legacy storage branches in the import path, negligible device-reach cost in 2026. |
| `targetSdk` | 36 | Current Play requirement target and the maximum API level AGP 9.1.0 supports. |
| `compileSdk` | `flutter.compileSdkVersion` | Tracks the SDK the pinned Flutter release is tested against (API 36 for Flutter 3.47.0), so a Flutter upgrade does not silently leave the compile SDK behind. |

`minSdk` and `targetSdk` are pinned as literals rather than `flutter.*`
defaults so that a Flutter SDK upgrade cannot move the app's supported device
range without an explicit, reviewed commit.

## Toolchain

| Component | Version | Source of truth |
|---|---|---|
| Flutter | 3.47.0 (stable) | `.metadata` revision `4cf24164269a5ebf0c16a028a00727d0e77bbb05`, pinned in CI |
| Dart | 3.13.x (bundled) | `pubspec.yaml` `sdk: ^3.13.0` |
| JDK | 17 (Temurin) | CI, `compileOptions`, Kotlin `jvmTarget` |
| Gradle | 9.3.1 | `android/gradle/wrapper/gradle-wrapper.properties` |
| AGP | 9.1.0 | `android/settings.gradle.kts` |
| Kotlin | 2.4.0 | `android/settings.gradle.kts` |

AGP 9.1.0 requires Gradle ≥ 9.1.0 and JDK ≥ 17, and supports a maximum API
level of 36; the versions above are consistent with those constraints.

## Release signing

The `release` build type currently uses the template's **debug** signing
config, so `flutter build appbundle` works in CI. This is not shippable: a real
keystore plus CI secrets is a separate task to be done before any Play upload.

## Platform scope

Android only (`AGENTS.md` §7, `PRODUCT_REPORT.md` §30). The project
intentionally contains no `ios/`, `web/`, `windows/`, `macos/` or `linux/`
directories, and `analysis_options.yaml` excludes those paths.
