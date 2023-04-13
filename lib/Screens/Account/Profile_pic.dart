import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_ordering_system/Screens/Account/profile_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {


  String mail = '';
  String name = '';
  String mobileNo = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AccountInfo(context);
  }

  AccountInfo(BuildContext context) async{
    final pref = await SharedPreferences.getInstance();
    setState(() {
      mail = pref.getString('emailId').toString();
      name = pref.getString('name').toString();
      mobileNo = pref.getString('mobileNo').toString();
    });
  }

  final imagePicker = ImagePicker();
 // File _imageFile;
  var _imageFile = File('assets/images/adi.jpg');
  bool IsImage = false;
  Future<void> getImageFromPhone(ImageSource imageSource) async {
    final selectedImage = await imagePicker.pickImage(source: imageSource);
    if (selectedImage != null) {
      setState(() {
        _imageFile = File(selectedImage.path);
        IsImage = true;
      });
    }
  }

  Future<String> _saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = directory.path + '/image.png';
    await image.copy(imagePath);
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF181a20),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF181a20),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp),
            onPressed: (){
              Navigator.pushNamed(context, '/bottoms');
            },
          ),
          title: Text(
            'My Account',
            style: TextStyle(
              color: Color(0xFF0695b4),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0 , 35.0 , 8.0 , 8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  IsImage ? Container(
                     width: 170,
                     height: 170,
                     decoration: BoxDecoration(
                       border: Border.all(width: 4, color: Colors.white70),
                       boxShadow: [
                         BoxShadow(
                           spreadRadius: 2,
                           blurRadius: 8,
                           color: Colors.black.withOpacity(0.1),
                           offset: const Offset(0, 10),
                         ),
                       ],
                       shape: BoxShape.circle,
                       image: DecorationImage(
                         fit: BoxFit.cover,
                         image:
                         FileImage(_imageFile)
                       ),
                     ),
                   ) : Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white70),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 10),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                          AssetImage('assets/images/tommy.jpg')
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(

                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white38,
                        ),
                        color: Color(0xFF262a34),
                      ),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                          context: context,
                          builder: ((builder) => selectProfile()),
                          );
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Color(0xFF0695b4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Text(name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
              ),),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.mail,color: Color(0xFF0695b4),),
                SizedBox(
                  width: 5,
                ),
                Text(mail,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),),
              ],),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call,color: Color(0xFF0695b4),),
                  SizedBox(
                    width: 5,
                  ),
                  Text(mobileNo,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),),
                ],),

              Expanded(child: ProfileScreen()),
            ],
          ),
        ));
  }

  Widget selectProfile() {
    return Container(
        height:120.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              "Choose Image From",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black.withOpacity(0.8)),
                  icon: const Icon(Icons.photo_camera_rounded),
                  onPressed: () async {
                    try {
                      await getImageFromPhone(ImageSource.camera);
                      Navigator.pop(context);
                    } catch (e) {
                      Flushbar(
                        title: "Could Not Update Profile",
                        message: "Select Smaller Image",
                        icon: const Icon(
                          Icons.error,
                          size: 28.0,
                          color: Colors.red,
                        ),
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    }
                  },
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black.withOpacity(0.8)),
                  icon: const Icon(Icons.image_rounded),
                  onPressed: () async {
                    try {
                      await getImageFromPhone(ImageSource.gallery);
                      Navigator.pop(context);
                    } catch (e) {}
                  },
                  label: const Text("Gallery"),
                )
              ],
            ),
          ],
        ));
  }

  Widget _buildImage() {
    if (_imageFile == null) {
      return const Text('No image selected.');
    }
    return Image.file(_imageFile!);
  }
}
