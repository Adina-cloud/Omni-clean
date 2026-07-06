package com.yourname.omni_clean

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.app.Notification.EXTRA_TEXT
import android.app.Notification.EXTRA_TITLE
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.Locale

class NotificationListener : NotificationListenerService() {

  companion object {
    private val BILLING_KEYWORDS = listOf(
      "charged", "trial ending", "subscription", "renewal",
      "billed", "payment due", "your receipt", "invoice"
    )
    private val AMOUNT_REGEX = Regex("[\$£€]\\d+(\\.\\d{2})?|\\d+(\\.\\d{2})?\\s?(USD|GBP|EUR|ZWL)")
    private val DATE_REGEX  = Regex("(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\\s+\\d{1,2}", RegexOption.IGNORE_CASE)
  }

  override fun onNotificationPosted(sbn: StatusBarNotification) {
    val extras = sbn.notification.extras
    val text  = extras.getString(EXTRA_TEXT, "")  ?: ""
    val title = extras.getString(EXTRA_TITLE, "") ?: ""
    val combined = "$title $text"

    if (BILLING_KEYWORDS.none { combined.contains(it, ignoreCase = true) }) return
val amount = AMOUNT_REGEX.find(combined)?.value ?: "unknown"
    val date   = DATE_REGEX.find(combined)?.value  ?: "unknown"

    sendToFlutter(mapOf(
      "package"  to sbn.packageName,
      "title"    to title,
      "text"     to text,
      "amount"   to amount,
      "date"     to date,
      "detected" to System.currentTimeMillis().toString()
    ))
  }

  private fun sendToFlutter(data: Map<String, String>) {
    // Store in shared preferences for Flutter to read on next launch
    val prefs = getSharedPreferences("omni_notif", MODE_PRIVATE)
    val existing = prefs.getStringSet("pending", mutableSetOf()) ?: mutableSetOf()
    existing.add(data.entries.joinToString("|") { "${it.key}=${it.value}" })
    prefs.edit().putStringSet("pending", existing).apply()
  }
}

