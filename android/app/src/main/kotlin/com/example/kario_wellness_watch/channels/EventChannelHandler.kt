package com.example.kario_wellness_watch.channels

import android.util.Log
import com.example.kario_wellness_watch.starmax.StarmaxManager
import io.flutter.plugin.common.EventChannel

class EventChannelHandler(
    private val starmaxManager: StarmaxManager
) : EventChannel.StreamHandler {

    companion object {
        private const val TAG = "EventChannel"
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "EventChannel: onListen")
        starmaxManager.setEventSink(events)
    }

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "EventChannel: onCancel")
        starmaxManager.setEventSink(null)
    }
}