
class Download {
  final int id;
  final String targetPath;
  final int receivedBytes;
  final int totalBytes;
  final String siteUrl;

  Download(this.id, this.targetPath, this.receivedBytes, this.totalBytes,
      this.siteUrl);
}
