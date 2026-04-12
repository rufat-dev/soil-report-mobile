# Keep Flutter plugins
-keep class io.flutter.plugins.** { *; }

# Keep app models (used by JSON serialization)
-keep class com.rufatdev.soilreport.**.domain.** { *; }


# Keep classes used via reflection
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Keep enum names
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Optional: keep any Firebase / third-party rules if needed
