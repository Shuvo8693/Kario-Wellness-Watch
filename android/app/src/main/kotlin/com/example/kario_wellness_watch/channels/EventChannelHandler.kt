package com.example.kario_wellness_watch.channels

import com.example.kario_wellness_watch.starmax.StarmaxManager
import io.flutter.plugin.common.EventChannel

class EventChannelHandler(
    private val starmaxManager: StarmaxManager
) : EventChannel.StreamHandler {

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        starmaxManager.setEventSink(events)

        events?.success(mapOf(
            "type" to "initialized",
            "message" to "Starmax SDK initialized"
        ))
    }

    override  fun onCancel(arguments: Any?) {
        starmaxManager.setEventSink(null)
    }
}