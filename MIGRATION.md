# Migration Guide: CocoaPods to Swift Package Manager

This document outlines the migration of AccuTerraSQLCipher from CocoaPods to Swift Package Manager.

## Summary of Changes

### 1. Project Structure
**Before (CocoaPods):**
```
AccuTerraSQLCipher/
├── AccuTerraSQLCipher.podspec.json
├── sqlite3.c
├── sqlite3.h
└── PrivacyInfo.xcprivacy
```

**After (Swift Package):**
```
AccuTerraSQLCipher/
├── Package.swift
├── Sources/
│   └── AccuTerraSQLCipher/
│       ├── sqlite3.c
│       ├── SQLCipherExample.swift
│       ├── include/
│       │   └── sqlite3.h
│       └── Resources/
│           └── PrivacyInfo.xcprivacy
├── Tests/
│   └── AccuTerraSQLCipherTests/
│       └── AccuTerraSQLCipherTests.swift
└── README.md
```

### 2. Configuration Migration

#### CocoaPods Subspecs → Swift Package Targets
The original CocoaPods specification had multiple subspecs (`common`, `standard`, `fts`, `unlock_notify`). In the Swift Package version, we've consolidated these into a single target with all flags enabled by default, as this provides the most complete functionality.

#### Compiler Flags
All compiler flags from the CocoaPods `compiler_flags` and `xcconfig.OTHER_CFLAGS` have been converted to Swift Package `cSettings`:

```swift
cSettings: [
    .headerSearchPath("."),
    .define("NDEBUG"),
    .define("SQLITE_HAS_CODEC"),
    .define("SQLITE_TEMP_STORE", to: "2"),
    // ... all other flags
]
```

#### Framework Dependencies
The `Foundation` and `Security` frameworks are linked using:

```swift
linkerSettings: [
    .linkedFramework("Foundation"),
    .linkedFramework("Security")
]
```

### 3. Platform Support
Maintained compatibility with all original platforms:
- iOS 11.0+
- macOS 10.13+
- tvOS 11.0+
- watchOS 7.0+

### 4. Resource Handling
The `PrivacyInfo.xcprivacy` file is now included as a resource in the package.

## Usage Changes

### Import Statement
No changes required:
```swift
import AccuTerraSQLCipher
```

### Integration

#### Before (CocoaPods)
```ruby
# Podfile
pod 'AccuTerraSQLCipher', :git => 'https://github.com/neotreks/sqlcipher.git', :tag => 'AccuTerrav4.5.6'
```

#### After (Swift Package Manager)
```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/neotreks/sqlcipher.git", from: "4.5.6")
]
```

Or in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/neotreks/sqlcipher.git`

## Testing the Migration

Run the following commands to verify the migration:

```bash
# Build the package
swift build

# Run tests
swift test

# Generate Xcode project (optional)
swift package generate-xcodeproj
```

## Benefits of Swift Package Manager

1. **Native Xcode Integration**: No need for external dependency managers
2. **Faster Builds**: More efficient dependency resolution
3. **Better Tooling**: Integrated with Swift toolchain
4. **Cross-Platform**: Works on all Swift-supported platforms
5. **Version Management**: Semantic versioning built-in

## Compatibility Notes

- All original functionality is preserved
- API remains unchanged
- Performance characteristics are identical
- All compiler optimizations and flags are maintained

## Troubleshooting

### Common Issues

1. **Build Errors**: Ensure all source files are in the correct directory structure
2. **Missing Headers**: Verify `sqlite3.h` is in `Sources/AccuTerraSQLCipher/include/`
3. **Linker Errors**: Check that Framework linking is configured correctly

### Getting Help

If you encounter issues during migration:
1. Check the build logs for specific error messages
2. Verify the directory structure matches the expected layout
3. Ensure all required files are present and in the correct locations
4. Test with a minimal example project first
