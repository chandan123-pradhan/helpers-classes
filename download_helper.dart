
class DownloadHelper {
  void downloadFile({required String url, context}) async {
    PermissionStatus status = await Permission.storage.request();
// debugger();
print(status);
    if (status.isGranted) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        String savename = "${url.split('/').last}.pdf";
        String savePath = dir.path + "/$savename";
        Dio dio = Dio();

        dio.options.headers['Authorization'] =
            "Bearer ${getString(PrefConstants.prefKeyUserAccessToken)}";

        try {
          await dio.download(url, savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              // print((received / total * 100).toStringAsFixed(0) + "%");
              if ((received / total * 100).toStringAsFixed(0) == "100") {
                var snackBar = SnackBar(
                  content: const Text('Invoice Downloaded Successfully'),
                  backgroundColor: (ColorConstants.blackColor),
                  action: SnackBarAction(
                    label: 'View',
                    textColor: ColorConstants.primaryColor,
                    onPressed: () {
                      OpenFile.open(savePath);
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else {
              var snackBar = const SnackBar(
                  content:  Text('Invoice Downloadeding, Please Wait...'),
                  backgroundColor: (ColorConstants.blackColor),
                  
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //downladoing
            }
            } 
          });

          print("File is saved to download folder.");
        } on DioError catch (e) {
          print(e.message);
        }
      }
    }else{

    }
  }

  
}