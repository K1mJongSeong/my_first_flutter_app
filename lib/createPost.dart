import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class createPost extends StatefulWidget {
  @override
  _createPostState createState() => _createPostState();
}

class _createPostState extends State<createPost> {
  FocusNode writingTextFocus = FocusNode();
  TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  bool _isLoading = false;
  File _postImageFile;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: writingTextFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  print('Select Image');
                  //_getImageAndCrop();
                },
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_photo_alternate, size: 28),
                      Text(
                        "Add Image",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  Future<void> _sendPostInFirebase(String postContent) async {
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance.collection('thread').doc().set({
      'userName': 'KimJongSeong',
      'userThumnail': '',
      'postTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'postContent': postContent,
      'postImage': 'testUserImage',
      'postLikeCount': 0,
      'postCommentCount': 0
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Writing Post'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              print("Post content is ${writingTextController.text}");
              _sendPostInFirebase(writingTextController.text);
            },
            child: Text(
              'Post',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: KeyboardActions(
        config: _buildConfig(context),
        child: _isLoading ? Column(
          children: [
            SizedBox(
              height: 28,
            ),
            Card(
              color: Colors.white,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(12.0),
              ),
              child: Container(
                width: size.width,
                height:
                    size.height - MediaQuery.of(context).viewInsets.bottom - 80,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      TextFormField(
                        autofocus: true,
                        focusNode: writingTextFocus,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Start Writing',
                          hintMaxLines: 4,
                        ),
                        controller: writingTextController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
/*
Future<void> _getImageAndCrop() async {
  File imageFileFromGallery =
      await ImagePicker.pickImage(source: ImageSource.gallery);
  if (imageFileFromGallery != null) {
    File cropImageFile = await Utils.cropImageFile(
        imageFileFromGallery); //await cropImageFile(imageFileFromGallery);
    if (cropImageFile != null) {
      setState(() {
        _postImageFile = cropImageFile;
      });
    }
  }
}
*/
