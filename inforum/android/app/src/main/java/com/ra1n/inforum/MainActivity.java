package com.ra1n.inforum;

import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.setStatusBarColor(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
            window.setNavigationBarColor(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
        }
    }
}
