class Download {
  int id;
  String targetPath;
  late String receivedBytes;
  late String totalBytes;
  String siteUrl;

  Download(this.id, this.targetPath, int receivedBytes, int totalBytes,
      this.siteUrl) {
    this.receivedBytes = _calculateBytes(receivedBytes);
    this.totalBytes = _calculateBytes(totalBytes);
  }

  String _calculateBytes(int bytes) {
    if (bytes > 1000000) {
      double gigaBytes = bytes / 1000000;
      return "${gigaBytes.toStringAsFixed(1)} GB";
    } else if (bytes > 1000) {
      double megaBytes = bytes / 1000;
      return "${megaBytes.toStringAsFixed(1)} MB";
    } else if (bytes > 100) {
      double kiloBytes = bytes / 100;
      return "${kiloBytes.toStringAsFixed(1)} kB";
    } else {
      return "$bytes Bytes";
    }
  }
}
