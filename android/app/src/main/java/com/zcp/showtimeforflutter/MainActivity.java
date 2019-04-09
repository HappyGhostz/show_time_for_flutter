package com.zcp.showtimeforflutter;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.zcp.showtimeforflutter.recevier.BatteryAndTimeChangedRecevier;

import java.util.ArrayList;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "local/songs";
    private static final String BATTERY_CHANGED_CHANNEL = "local/battery";
    private static final String TIMER_CHANGED_CHANNEL = "local/time";
    private static final int MY_PERMISSIONS_REQUEST_READ_MEDIA = 1000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            int permissionCheck = checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE);

            if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE}, MY_PERMISSIONS_REQUEST_READ_MEDIA);
            } else {
                getLocalMusic();
            }
        } else {
            getLocalMusic();
        }
        getBatteryChanged();
        getTimeChanged();

    }

    private void getTimeChanged() {
        new EventChannel(getFlutterView(),TIMER_CHANGED_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    BroadcastReceiver chargingStateChangeReceiver;
                    @Override
                    public void onListen(Object o, EventChannel.EventSink eventSink) {
                        chargingStateChangeReceiver = new BatteryAndTimeChangedRecevier(eventSink);
                        IntentFilter intentFilter = new IntentFilter();
                        intentFilter.addAction(Intent.ACTION_TIME_TICK);
                        registerReceiver(chargingStateChangeReceiver, intentFilter);
                    }

                    @Override
                    public void onCancel(Object o) {
                        unregisterReceiver(chargingStateChangeReceiver);
                    }
                });
    }

    private void getBatteryChanged() {
        new EventChannel(getFlutterView(),BATTERY_CHANGED_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    BroadcastReceiver chargingStateChangeReceiver;
                    @Override
                    public void onListen(Object o, EventChannel.EventSink eventSink) {
                        chargingStateChangeReceiver = new BatteryAndTimeChangedRecevier(eventSink);
                        IntentFilter intentFilter = new IntentFilter();
                        intentFilter.addAction(Intent.ACTION_BATTERY_CHANGED);
                        registerReceiver(chargingStateChangeReceiver, intentFilter);
                    }

                    @Override
                    public void onCancel(Object o) {
                        unregisterReceiver(chargingStateChangeReceiver);
                    }
                });
    }



    private void getLocalMusic() {
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, Result result) {
                if (TextUtils.equals("getSongs", methodCall.method)) {
                    LocalSongsPresent present = new LocalSongsPresent(MainActivity.this);
                    List<Song> localSongs = present.getLocalSongs();
                    Gson gson = new Gson();
                    String songsJson = gson.toJson(localSongs);
                    result.success(songsJson);
                }
            }
        });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST_READ_MEDIA:
                if ((grantResults.length > 0) && (grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    getLocalMusic();
                }
                break;

            default:
                break;
        }
    }
}
