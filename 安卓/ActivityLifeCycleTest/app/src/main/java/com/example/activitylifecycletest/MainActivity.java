package com.example.activitylifecycletest;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button btn1 = (Button)findViewById(R.id.start_normal_activity);
        btn1.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View view) {
                Intent intent = new Intent(MainActivity.this,NormalActivity.class);
                startActivity(intent);
            }
        });

        Button btn2 = (Button)findViewById(R.id.start_dialog_activity);
        btn2.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View view) {
                Intent intent = new Intent(MainActivity.this,DialogActivity.class);
                startActivity(intent);
            }
        });

        Log.d("MainAC", "onCreate: ");
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d("MainAC", "onStart: ");
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.d("MainAC", "onResume: ");
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        Log.d("MainAC", "onRestart: ");
    }

    @Override
    protected void onStop() {
        super.onStop();
        Log.d("MainAC", "onStop: ");
    }

    @Override
    protected void onPause() {
        super.onPause();
        Log.d("MainAC", "onPause: ");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d("MainAC", "onDestroy: ");
    }
}
