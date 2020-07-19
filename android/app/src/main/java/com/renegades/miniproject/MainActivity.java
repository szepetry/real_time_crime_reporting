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
import android.view.KeyEvent;
import android.util.Log;

public class MainActivity extends FlutterActivity {
    public static final String STREAM = "com.renegades.miniproject/voldown";
    public static final String REPORT = "com.renegades.miniproject/report";
    private EventChannel channel;
    private MethodChannel mChannel;
    private int count1;
    private Intent foregroundService;
    private EventChannel.EventSink eventSink = null;

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
            }
        });
    }

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
                }
            }
        }
        return super.dispatchKeyEvent(event);
    }
}