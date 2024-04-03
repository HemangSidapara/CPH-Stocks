package com.stocks.cph;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;

import java.io.File;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "AndroidMethodChannel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("getPackageInfo")) {
                try {
                    PackageInfo packageInfo = this.getPackageManager().getPackageInfo(this.getPackageName(), 0);

                    String installerPackage;
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        installerPackage = this.getPackageManager().getInstallSourceInfo(this.getPackageName()).getInitiatingPackageName();
                    } else {
                        installerPackage = this.getPackageManager().getInstallerPackageName(this.getPackageName());
                    }
                    HashMap<String, String> infoMap = new HashMap<>();
                    infoMap.put("appName", packageInfo.applicationInfo.loadLabel(this.getPackageManager()).toString());
                    infoMap.put("packageName", packageInfo.packageName);
                    infoMap.put("version", packageInfo.versionName);
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        infoMap.put("buildNumber", Long.toString(packageInfo.getLongVersionCode()));
                    } else {
                        infoMap.put("buildNumber", Long.toString(packageInfo.versionCode));
                    }
                    infoMap.put("installerStore", installerPackage);
                    result.success(infoMap);
                } catch (PackageManager.NameNotFoundException e) {
                    result.success(null);
                    throw new RuntimeException(e);
                }
            } else if (call.method.equals("installApk")) {
                installApk(result);
            } else {
                result.notImplemented();
            }
        });
    }

    private void installApk(MethodChannel.Result result) {
        String fileName = "app-release.apk";

        File apkFile = new File(this.getExternalFilesDir(null), fileName);
        Log.d("APK Installer", "installApk: " + apkFile);
        if (apkFile.exists()) {
            Uri uri = FileProvider.getUriForFile(this, this.getPackageName() + ".provider", apkFile);
            Intent intent = new Intent(Intent.ACTION_INSTALL_PACKAGE);
            intent.setDataAndType(uri, "application/vnd.android.package-archive");
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            result.success(true);
        } else {
            Log.e("APK Installer", "APK file not found: " + apkFile.getAbsolutePath());
        }
    }
}
