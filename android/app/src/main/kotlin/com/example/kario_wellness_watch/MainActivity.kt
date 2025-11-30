package com.example.kario_wellness_watch

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.example.kario_wellness_watch.channels.EventChannelHandler
import com.example.kario_wellness_watch.channels.MethodChannelHandler
import com.example.kario_wellness_watch.starmax.StarmaxManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    private val TAG = "MainActivity"
    private val METHOD_CHANNEL = "com.kario.wellness/methods"
    private val EVENT_CHANNEL = "com.kario.wellness/events"

    private lateinit var starmaxManager: StarmaxManager

    private val PERMISSION_REQUEST_CODE = 1001

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "=== MainActivity onCreate called ===")
        requestBluetoothPermissions()
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Log.d(TAG, "=== Configuring Flutter Engine ===")

        try {
            starmaxManager = StarmaxManager(applicationContext)
            Log.d(TAG, "✅ StarmaxManager initialized")

            EventChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                EVENT_CHANNEL
            ).setStreamHandler(EventChannelHandler(starmaxManager))
            Log.d(TAG, "✅ Event Channel registered")

            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                METHOD_CHANNEL
            ).setMethodCallHandler(MethodChannelHandler(starmaxManager))
            Log.d(TAG, "✅ Method Channel registered")

        } catch (e: Exception) {
            Log.e(TAG, "❌ Error setting up channels", e)
        }
    }

    private fun requestBluetoothPermissions() {
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12+ (API 31+)
            arrayOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_ADVERTISE,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
        } else {
            // Android 6-11
            arrayOf(
                Manifest.permission.BLUETOOTH,
                Manifest.permission.BLUETOOTH_ADMIN,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
        }

        val permissionsToRequest = permissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }.toTypedArray()

        if (permissionsToRequest.isNotEmpty()) {
            Log.d(TAG, "Requesting permissions: ${permissionsToRequest.joinToString()}")
            ActivityCompat.requestPermissions(this, permissionsToRequest, PERMISSION_REQUEST_CODE)
        } else {
            Log.d(TAG, "✅ All permissions already granted")
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == PERMISSION_REQUEST_CODE) {
            val allGranted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }
            if (allGranted) {
                Log.d(TAG, "✅ All Bluetooth permissions granted")
            } else {
                Log.e(TAG, "❌ Some permissions were denied")
                permissions.forEachIndexed { index, permission ->
                    val result = if (grantResults[index] == PackageManager.PERMISSION_GRANTED) "GRANTED" else "DENIED"
                    Log.d(TAG, "$permission: $result")
                }
            }
        }
    }

    override fun onDestroy() {
        Log.d(TAG, "=== MainActivity onDestroy ===")
        starmaxManager.cleanup()
        super.onDestroy()
    }
}