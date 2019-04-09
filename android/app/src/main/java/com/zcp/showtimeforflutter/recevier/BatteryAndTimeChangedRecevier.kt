package com.zcp.showtimeforflutter.recevier

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.EventChannel
import java.text.SimpleDateFormat
import java.util.*

/**
 * @author zcp
 * @date 2019/4/9
 * @Description
 */
class BatteryAndTimeChangedRecevier : BroadcastReceiver {
    lateinit var mEventSink: EventChannel.EventSink
    private val sdf = SimpleDateFormat("HH:mm")
    constructor(eventSink: EventChannel.EventSink ){
        this.mEventSink = eventSink
    }
    override fun onReceive(context: Context?, intent: Intent?) {
        if (Intent.ACTION_BATTERY_CHANGED == intent?.action) {
            val level = intent.getIntExtra("level", 0)
            mEventSink.success(level)
        } else if (Intent.ACTION_TIME_TICK == intent?.action) {
            mEventSink.success(sdf.format(Date()))
        }
    }
}