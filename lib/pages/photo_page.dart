
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_identifier/config/data.dart';
import 'package:history_identifier/pages/paywall_page.dart';
import 'package:history_identifier/pages/photo_aIanaliz.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:image_picker/image_picker.dart';


class PhotoScannerPage extends ConsumerStatefulWidget {
  const PhotoScannerPage({super.key});

  @override
  ConsumerState<PhotoScannerPage> createState() => _PhotoScannerPageState();
}

class _PhotoScannerPageState extends ConsumerState<PhotoScannerPage> {

  CameraController? _controller;
  bool _isCameraInitialized = false;
  FlashMode _currentFlashMode = FlashMode.off;
  bool customerSub = false;
  
  //late int freePhotoTake;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _initializedCamera();
    loadCustomerSubInformation();
  }

  Future<void> loadCustomerSubInformation () async {
    customerSub = await SubscriptionManager.isUserSubscribed();
  }


  Future<void> _initializedCamera() async {
    final camera = await availableCameras();
    final firstCamera = camera.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("ABONELİK BİLGİSİ : $customerSub");

    return SafeArea(
      child: Stack(
        children: [

          Center(
            child: _isCameraInitialized
                ? CameraPreview(_controller!)
                : Center(
                    child: Text("navigation.kameraHataText".tr(), style: TextStyle(color: Colors.white, fontSize: 24),),
                  ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              TopArea(),

              BottomArea()
            ],
          ),
        ],
      ),
    );
  }

  
  Widget TopArea() {
    return Container(
      width: double.maxFinite,
      height: 55,
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, size: 36, color: Colors.white),
          ),

          IconButton(
            onPressed: () {
              _toggleFlash();
            },
            icon: _currentFlashMode == FlashMode.off
                ? Icon(Icons.flash_off, color: Colors.white)
                : Icon(Icons.flash_on, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget BottomArea() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.photo_library,
                  color: Colors.transparent,
                  size: 40,
                ),
              ),
            ),
        
            SizedBox(width: 30),

            //! TAKE PHOTO BUTTON
            Container(
              //color: Colors.amber,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 1,
                      color: Colors.white,
                      strokeWidth: 5,
                    ),
                  ),
        
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_isCameraInitialized) { //!

                          await _takePicture();
                          
                        }
                        
                      },
                      child: Container(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(width: 30),
        
            //! PHOTO LİBRARY BUTTON
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(40),
              ),
              child: IconButton(
                onPressed: () {
                  _pickImage();
                  
                },
                icon: Icon(Icons.photo_library, color: Colors.white, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePicture() async {

    if (ref.read(saveFreePhotoTakeProvider) < 5 || customerSub) {

      final image = await _controller!.takePicture();
      File imageFile = File(image.path);

      await _controller!.pausePreview();

      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => PhotoAIanalizPage(Myimage: imageFile),),);
      ref.read(saveFreePhotoTakeProvider.notifier).state += 1;

      _controller!.resumePreview();

    }
    else {
      showAlert();
    }

  }

  Future<void> _pickImage() async {

    if (ref.read(saveFreePhotoTakeProvider) < 5 || customerSub) {

      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        File fileImage = File(image!.path);
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => PhotoAIanalizPage(Myimage: fileImage)));
        ref.read(saveFreePhotoTakeProvider.notifier).state += 1;
      }
      else {
        return;
      }

    }
    else {
      showAlert();
    }

  }

  Future<void> _toggleFlash() async {
    FlashMode newFlashMode;

    if (_currentFlashMode == FlashMode.off) {
      newFlashMode = FlashMode.torch;
    } else if (_currentFlashMode == FlashMode.torch) {
      newFlashMode = FlashMode.off;
    } else {
      newFlashMode = FlashMode.off;
    }

    if (_controller != null) {
      await _controller!.setFlashMode(newFlashMode);
      setState(() {
        _currentFlashMode = newFlashMode;
      });
    }
  }

  Future showAlert () {

    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor:Color.fromRGBO(15, 27, 33, 1),
          content: Text("navigation.daily_scan_limit".tr(), style: TextStyle(color: Colors.white),),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => PayWallPage()));
            }, child: Text("Ok", style: TextStyle(color: Colors.white),))
          ],
        );
      }
    );
  }

}
