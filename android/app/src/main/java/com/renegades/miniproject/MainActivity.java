package com.renegades.miniproject;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.os.Build;
import android.os.Handler;
import io.flutter.plugin.common.EventChannel;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.app.Activity;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
// import android.widget.FrameLayout;
import android.view.KeyEvent;
import android.util.Log;

public class MainActivity extends FlutterActivity {
    public static final String STREAM = "com.renegades.miniproject/voldown";
    public static final String REPORT = "com.renegades.miniproject/report";
    private EventChannel channel;
    private MethodChannel mChannel;
    private int count1;
    private Intent foregroundService;
//    private int count2;
    private EventChannel.EventSink eventSink = null;
    // @Override
    // public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    // super.configureFlutterEngine(flutterEngine);
    // // GeneratedPluginRegistrant.registerWith(flutterEngine);
    // }

    @Override
    protected void onDestroy() {
        // added due to JNDI error in flutter 
        try{    
        if (getFlutterEngine() != null)
        if (getFlutterEngine().getPlatformViewsController() != null)
            getFlutterEngine().getPlatformViewsController().onFlutterViewDestroyed() ;
        }
        catch(Error e){
            System.out.println(e);
        }
            super.onDestroy();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        foregroundService = new Intent(MainActivity.this, ReportingService.class);

        mChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), REPORT);
        mChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if(call.method.equals("startReportService")){
                    startReportService();
                    result.success("Report Service started");
                }
            }
        });

        channel = new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), STREAM);
        channel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object args, final EventChannel.EventSink events) {
                eventSink = events;
            }

            @Override
            public void onCancel(Object args) {
                eventSink = null;
                count1 = 0;
//                count2 = 0;
            }
        });
    }
//
//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        stopService(foregroundService);
//    }

    private void startReportService(){
        if(VERSION.SDK_INT>= VERSION_CODES.O){
            startForegroundService(foregroundService);
        } else {
            startService(foregroundService);
        }
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getKeyCode() == KeyEvent.KEYCODE_VOLUME_DOWN) {
            if (eventSink != null) {
                ++count1;
                Log.w("count1 value", count1+"");
                if (count1%10==0) {
                    Log.w("count1 value inside if",count1+"");
                    eventSink.success("voldown");
                    // count1 = 0;
                }
            }
        }
        // else {
        // if (event.getKeyCode() == KeyEvent.KEYCODE_VOLUME_UP) {
        // if (eventSink != null) {
        // ++count2;
        // if (count2 % 4 == 0)
        // eventSink.success(1);
        // }
        // }
        // }
        return super.dispatchKeyEvent(event);
    }

    // @Override
    // public boolean dispatchKeyEvent(KeyEvent event) {
    // if (event.getKeyCode() == KeyEvent.KEYCODE_VOLUME_DOWN) {
    // // if (eventSink != null) {
    // // eventSink.success(0);
    // event.startTracking();
    // return true;
    // // }
    // } else {
    // if (event.getKeyCode() == KeyEvent.KEYCODE_VOLUME_UP) {
    // if (eventSink != null) {
    // eventSink.success(1);
    // }
    // }
    // }
    // return super.dispatchKeyEvent(event);
    // }

    // @Override
    // public boolean onKeyDown(int keyCode, KeyEvent event) {
    // if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
    // // this is method which detect press even of button
    // event.startTracking(); // Needed to track long presses
    // return true;
    // }
    // else if(keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
    // if (eventSink != null) {
    // // Here we can detect long press of power button
    // eventSink.success(1);
    // Log.w("LightWriter", "UP.");
    // return true;
    // }
    // }
    // return super.onKeyDown(keyCode, event);
    // }

    // @Override
    // public boolean onKeyLongPress(int keyCode, KeyEvent event) {
    // if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
    // if (eventSink != null) {
    // // Here we can detect long press of power button
    // eventSink.success(3);
    // Log.w("LightWriter", "DOWN Long Press.");
    // return true;
    // }
    // }
    // return super.onKeyLongPress(keyCode, event);
    // }

}