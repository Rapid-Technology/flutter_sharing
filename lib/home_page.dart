import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  final String text =
      'Flutter is a framework to build cross-platform applications. https://www.flutter.dev';
  final String imageAsset = 'assets/image.png';
  final String imageNetwork =
      'https://www.mindinventory.com/blog/wp-content/uploads/2022/10/flutter-3.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Sharing"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            shareButton('Share Text & Link', () {
              Share.share(text);
            }),
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 10),
              child: Image.asset(imageAsset),
            ),
            shareButton(
              'Share Image from Asset',
              () async {
                final image = await rootBundle.load(imageAsset);
                final buffer = image.buffer;
                Share.shareXFiles(
                  [
                    XFile.fromData(
                      buffer.asUint8List(
                        image.offsetInBytes,
                        image.lengthInBytes,
                      ),
                      name: 'Flutter Logo',
                      mimeType: 'image/png',
                    ),
                  ],
                  subject: 'Flutter Logo',
                );
              },
            ),
            Image.network(imageNetwork),
            shareButton(
              'Share Image from Network',
              () async {
                final url = Uri.parse(imageNetwork);
                final response = await http.get(url);
                Share.shareXFiles([
                  XFile.fromData(
                    response.bodyBytes,
                    name: 'Flutter 3',
                    mimeType: 'image/png',
                  ),
                ], subject: 'Flutter 3');
              },
            ),
            shareButton(
              'Share Image from Image Picker',
              () async {
                final imagePicker =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (imagePicker != null) {
                  Uint8List uint8List = await imagePicker.readAsBytes();
                  Share.shareXFiles(
                    [
                      XFile.fromData(
                        uint8List,
                        name: 'Image Gallery',
                        mimeType: 'image/png',
                      ),
                    ],
                    subject: 'Image Gallery',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  shareButton(String title, Function()? onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
