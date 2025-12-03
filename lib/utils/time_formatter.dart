/// Utility class for formatting timestamps
class TimeFormatter {
  /// Format a DateTime to a relative time string
  /// Examples: "2m ago", "1h ago", "Yesterday", "Jan 15"
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Less than 1 minute ago
    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    // Less than 1 hour ago
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    // Less than 24 hours ago
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    // Yesterday
    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    // Less than 7 days ago
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    // Same year - show month and day
    if (dateTime.year == now.year) {
      return '${_getMonthName(dateTime.month)} ${dateTime.day}';
    }

    // Different year - show full date
    return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
  }

  /// Format a DateTime to a time string (e.g., "2:30 PM")
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Format a DateTime to a full date and time string
  static String formatFull(DateTime dateTime) {
    return '${formatRelative(dateTime)} at ${formatTime(dateTime)}';
  }

  /// Get month name abbreviation
  static String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  /// Check if two messages should be grouped together (same sender, within 5 minutes)
  static bool shouldGroupMessages(DateTime message1Time, DateTime message2Time) {
    final difference = message1Time.difference(message2Time).abs();
    return difference.inMinutes < 5;
  }
}

