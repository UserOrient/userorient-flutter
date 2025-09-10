extension DateTimeX on DateTime? {
  String timeAgoWithAllEdgeCases() {
    if (this == null) {
      return 'Some time ago';
    }

    final now = DateTime.now();
    final diff = now.difference(this!);

    if (diff.inSeconds < 60) {
      return 'Just now';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }

    if (diff.inDays < 30) {
      return '${diff.inDays}d ago';
    }

    if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30}m ago';
    }

    return '${diff.inDays ~/ 365}y ago';
  }
}
