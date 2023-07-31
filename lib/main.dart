import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:io' if (dart.library.html) 'dart:html' as platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:io';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Business Card',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: BusinessCard(),
    );
  }
}

class BusinessCard extends StatefulWidget {
  @override
  _BusinessCardState createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  String name = "Fatimah Alzahrani";
  int i = 0;
  String jobTitle = "Application Developer";
  String company = "Albaha University";
  String phoneNumber = "0558699756";
  String email = "12fatimah.15@gmail.com";
  String website = "";
  String selectedColor = "143F6B";
  String selectedColor2 = "E38B29";
  String img="card1_1";
  Color text = Colors.black;
  File? profilePicture;
  GlobalKey globalKey = GlobalKey();
  File? _profileImage;
  File? _selectedImage;
  Uint8List? _selectedImage2;

  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();

  // to save image bytes of widget
  Uint8List? bytes;

  double cardSize=440;
  void _saveAsPdf() async {
    final pdf = pw.Document();
    final pdfImageProvider = pw.MemoryImage(bytes!.buffer.asUint8List());
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(pdfImageProvider));
        },
      ),
    );
    final output = File('business_card.pdf');
    await output.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Business Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareImage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: WidgetsToImage(
                  controller: controller,
                  child: cardWidget(),
                ),
              ),
              const SizedBox(height: 16),
              // SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('upload a profile picture or logo'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Customize Your Card:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Job Title'),
                onChanged: (value) {
                  setState(() {
                    jobTitle = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Company'),
                onChanged: (value) {
                  setState(() {
                    company = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Website'),
                onChanged: (value) {
                  setState(() {
                    website = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose Card Color:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ColorOption(
                    color1: const Color(0xFF143F6B),
                    color2: const Color(0xFFDA8627),
                    isSelected: selectedColor == "FF143F6B",
                    onSelect: () {
                      selectColor("FFDA8627");
                      selectColor2("FFDA8627");
                      setState(() {
                        img="card1_1";
                      });
                    },
                  ),
                  ColorOption(
                    color1: const Color(0xFF000000),
                    color2: const Color(0xFF25E1C7),
                    isSelected: selectedColor == "FF000000",
                    onSelect: () {
                      selectColor("FF000000");
                      selectColor2("FF25E1C7");
                      setState(() {
                        img="card1_2";
                      });
                    },
                  ),
                  ColorOption(
                    color1: const Color(0xFFB6B5B5),
                    color2: const Color(0xFFE9E422),
                    isSelected: selectedColor == "FFB6B5B5",
                    onSelect: () {
                      selectColor("FFB6B5B5");
                      selectColor2("FFE9E422");
                      setState(() {
                        img="card1_3";
                      });
                    },
                  ),
                  ColorOption(
                    color1: const Color(0xFFD2DFEC),
                    color2: const Color(0xFFE328BB),
                    isSelected: selectedColor == "FFD2DFEC",
                    onSelect: () {
                      selectColor("FFD2DFEC");
                      selectColor2("FFE328BB");
                      setState(() {
                        img="card1_4";
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final bytes = await controller.capture();
                    setState(() {
                      this.bytes = bytes;
                      saveLocalImage(bytes!, "card.png");
                    });
                  },
                  child: const Text('Save Business Card as Image'),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final bytes = await controller.capture();
                    setState(() async {
                      this.bytes = bytes;
                      final blob = html.Blob([bytes]);
                      final url = html.Url.createObjectUrlFromBlob(blob);

                    });
                  },
                  child: const Text('Save Business Card as Qr Code'),
                ),
              ),
              const SizedBox(height: 5),
              Center(
              child: ElevatedButton(
              onPressed: () async {
               _saveAsPdf();
              },
              child: const Text('Save Business Card as PDF'),
          ),
          ),
        const SizedBox(width: 5),
              const Text(
                "My Cards",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (bytes != null) buildImage(bytes!),
              // if (bytes != null)
              //   QrImageView(
              //   data:  uploadImageAndGetUrl(bytes!, "Qr.png").toString(),
              //   version: QrVersions.auto,
              //   embeddedImage: MemoryImage(bytes!),
              //   errorCorrectionLevel: QrErrorCorrectLevel.L, // Adjust the error correction level as needed.
              //   size: 100,
              //   gapless: false,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void selectColor(String color) {
    setState(() {
      selectedColor = color;
    });
  }

  void selectColor2(String color) {
    setState(() {
      selectedColor2 = color;
    });
  }

  Widget cardWidget() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/$img.PNG',
              height: 270,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: text,

                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  jobTitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 16,
                    color: text,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Contact Information :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: text,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 10),
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 16,
                        color: text,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email),
                    const SizedBox(width: 10),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: text,
                      ),
                    ),
                  ],
                ),
                if(website!="")
                  buildQrWeb(website)
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(300.0),
              child: _buildSelectedImage(),

            ),
            if(i!=-1)
              changeSize()
          ],
        ),
      ),

    );

  }

  Widget buildImage(Uint8List bytes) => Image.memory(bytes);
  Widget buildQrWeb(String url) {
    return Row(
      children: [
        const Icon(Icons.web),
        const SizedBox(width: 10),
        QrImageView(
          data:  url,
          version: QrVersions.auto,
          size: 70,
          gapless: false,
        ),
      ],
    );
  }

// Function for saving image on mobile (Android and iOS)
  void _saveImageAsFileMobile(Uint8List imageBytes, String fileName) async {
    final file =
    File('${(await getApplicationDocumentsDirectory()).path}/$fileName');
    await file.writeAsBytes(imageBytes);
    print('Image saved as file: ${file.path}');
  }

// Function for saving image on web
  void _saveImageAsFileWeb(Uint8List imageBytes, String fileName) {
    final blob = html.Blob([imageBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and set the download and href attributes
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  void saveLocalImage(Uint8List imageBytes, String fileName) {
    if (kIsWeb) {
      _saveImageAsFileWeb(imageBytes, fileName);
    } else {
      _saveImageAsFileMobile(imageBytes, fileName);
    }
  }
  // Future<String> uploadImageAndGetUrl(Uint8List imageBytes, String imageName) async {
  //   try {
  //     // Replace "YOUR_CLOUD_STORAGE_URL" with the appropriate URL for your cloud storage service.
  //     final Uri uploadUrl = Uri.parse('YOUR_CLOUD_STORAGE_URL');
  //     // Send a POST request to upload the image to the cloud storage service.
  //     final http.Response response = await http.post(uploadUrl, body: imageBytes);
  //     // Check if the request was successful (status code 200-299) and get the public URL.
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       final String imageUrl = response.body;
  //       return imageUrl;
  //     } else {
  //       // Handle the case when the image upload fails.
  //       return "null";
  //     }
  //   } catch (e) {
  //     // Handle any exceptions that occur during the process.
  //     return "null";
  //   }
  // }

  Widget _buildSelectedImage() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if(_selectedImage2!=null) {
      return Image.memory(_selectedImage2!,        height: 150,
        width: 150,
      );
    }else{
      return Image.asset(
        'assets/okul.png',
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    }
  }
  Future<void> _pickImage() async {
    if (kIsWeb) {
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
      // _selectedImage=File(fromPicker as String);
      setState(() {
        _selectedImage2 = bytesFromPicker;
      });
    } else {
      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }
  void _shareImage() async {
    // String base64Image = base64Encode(bytes as List<int>);
    // String imageDataUri= "data:image/jpeg;base64,$base64Image";
    // final Uri uri = Uri.dataFromString(imageDataUri);
    // final html.HtmlDocument htmlDocument = html.document;
    // final html.AnchorElement anchor = html.AnchorElement(href: uri.toString())
    //   ..target = '_blank'
    //   ..download = 'card.jpg'; // Provide a filename for the downloaded image
    // htmlDocument.body?.append(anchor);
    // anchor.click();
    // anchor.remove();
    // // Share the image using the share plugin
    await Share.shareFiles([Image.memory(bytes!).toString()],
        mimeTypes: ['image/png'], // Adjust mimeTypes according to your image type
        subject: 'Sharing Card');
  }

  changeSize() {
    setState(() {
      cardSize=600;
    });
  }

}

class ColorOption extends StatelessWidget {
  final Color color1;
  final Color color2;
  final bool isSelected;
  final VoidCallback onSelect;

  const ColorOption({
    required this.color1,
    required this.color2,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: CustomPaint(
        size: Size(50, 50),
        painter: CirclePainter(color1, color2, isSelected),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final bool isSelected;

  CirclePainter(this.color1, this.color2, this.isSelected);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color1
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the first half of the circle
    final rect1 = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect1, -pi, pi, true, paint);

    // Draw the second half of the circle
    final paint2 = Paint()
      ..color = color2
      ..style = PaintingStyle.fill;
    final rect2 = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect2, 0, pi, true, paint2);

    // Draw the border if isSelected is true
    if (isSelected) {
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(center, radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return true;
}
