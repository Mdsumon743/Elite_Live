# ================================
# Flutter Core Rules
# ================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# ================================
# Zego SDK (Critical for Live Streaming)
# ================================
-keep class **.zego.** { *; }
-keep class com.zegocloud.** { *; }
-keep class im.zego.** { *; }
-keep interface im.zego.**{*;}
-dontwarn im.zego.**
-keep class com.zegocloud.uikit.** { *; }
-keep class com.zegocloud.zimkit.** { *; }

# ================================
# Firebase
# ================================
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-keep class com.google.firebase.auth.** { *; }
-keep class com.google.firebase.messaging.** { *; }

# ================================
# Google Sign In & Fonts
# ================================
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.fonts.** { *; }

# ================================
# Dio HTTP Client
# ================================
-keep class com.dio.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ================================
# GetX State Management
# ================================
-keep class com.getx.** { *; }
-keep class dev.flutter.plugins.** { *; }

# ================================
# Video Player
# ================================
-keep class io.flutter.plugins.videoplayer.** { *; }
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# ================================
# Image & File Pickers
# ================================
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-keep class androidx.core.content.FileProvider { *; }

# ================================
# WebView
# ================================
-keep class io.flutter.plugins.webviewflutter.** { *; }
-keep class android.webkit.** { *; }
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}
-keepclassmembers class * extends android.webkit.WebChromeClient {
    public void *(android.webkit.WebView, java.lang.String);
}

# ================================
# WebSocket Channel
# ================================
-keep class io.flutter.plugins.websocket.** { *; }
-keep class org.java_websocket.** { *; }
-dontwarn org.java_websocket.**

# ================================
# Permissions & Local Notifications
# ================================
-keep class com.baseflow.permissionhandler.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# ================================
# Shared Preferences & Path Provider
# ================================
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# ================================
# URL Launcher
# ================================
-keep class io.flutter.plugins.urllauncher.** { *; }

# ================================
# In-App Purchase
# ================================
-keep class com.android.billingclient.** { *; }
-keep class io.flutter.plugins.inapppurchase.** { *; }

# ================================
# Photo View & Image Libraries
# ================================
-keep class com.reginald.swiperefresh.** { *; }
-keep class com.github.chrisbanes.photoview.** { *; }

# ================================
# Emoji Picker
# ================================
-keep class io.wemeetagain.emoji.** { *; }

# ================================
# Chart Libraries
# ================================
-keep class com.github.mikephil.charting.** { *; }

# ================================
# Keep Native Methods
# ================================
-keepclasseswithmembernames class * {
    native <methods>;
}

# ================================
# Keep Serializable Classes
# ================================
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ================================
# Keep Annotations & Attributes
# ================================
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes Exceptions

# ================================
# Keep Enum Classes
# ================================
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ================================
# Parcelable
# ================================
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# ================================
# R Classes (Resources)
# ================================
-keepclassmembers class **.R$* {
    public static <fields>;
}
-keep class **.R$* { *; }

# ================================
# Keep Custom Views
# ================================
-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
}

# ================================
# Gson (for JSON parsing)
# ================================
-keep class com.google.gson.** { *; }
-keep class org.json.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ================================
# AndroidX
# ================================
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-dontwarn androidx.**

# ================================
# Kotlin
# ================================
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# ================================
# Suppress Common Warnings
# ================================
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
-dontwarn edu.umd.cs.findbugs.annotations.**
-dontwarn org.codehaus.mojo.animal_sniffer.**

# ================================
# Keep Main Activity
# ================================
-keep class com.elites.live.app.MainActivity { *; }

# ================================
# Prevent Stripping of Generic Signatures
# ================================
-keepattributes Signature

# ================================
# Keep all model classes (add your package name)
# ================================
-keep class com.elitelive.mobile.app.** { *; }
-keep class com.elitelive.mobile.app.models.** { *; }
-keep class com.elitelive.mobile.app.data.** { *; }
-keep class com.elitelive.mobile.app.core.** { *; }

# ================================
# SharedPreferences Critical Rules
# ================================
-keep class android.content.SharedPreferences { *; }
-keep class android.content.SharedPreferences$** { *; }
-keepclassmembers class android.content.SharedPreferences {
    *;
}

# ================================
# GetX Critical Rules
# ================================
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * extends io.flutter.plugin.common.MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.PluginRegistry$Registrar { *; }

# ================================
# Flutter ScreenUtil
# ================================
-keep class com.flutter.screenutil.** { *; }