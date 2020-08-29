import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yoyoza/Components/customdialog.dart';
import 'package:yoyoza/Model/GalleryItem.dart';
import 'package:yoyoza/Model/RequestResidentialUnit.dart';
import 'package:yoyoza/service/documentservice.dart';
import 'package:yoyoza/service/generateimageurl.dart';
import 'package:yoyoza/service/requestresidentialunitservice.dart';
import 'package:uuid/uuid.dart';

const Color kErrorRed = Colors.redAccent;
const Color kDarkGray = Color(0xFFA3A3A3);
const Color kLightGray = Color(0xFFF1F0F5);
enum PhotoSource { FILE, NETWORK }

class ImageController extends StatefulWidget {
  ImageController({this.parentEntity});
  final RequestResidentialUnit parentEntity;
  @override
  _ImageControllerState createState() => _ImageControllerState(parentEntity:this.parentEntity);
}

class _ImageControllerState extends State<ImageController> {
  _ImageControllerState({this.parentEntity});
  final RequestResidentialUnit parentEntity;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
List<File>_photos = List<File>();
  List<String>_photosUrls = List<String>();
  List<PhotoSource>_photoSources = List<PhotoSource>();
  List<GalleryItem> _galleryItems = new List<GalleryItem>();
  @override
  Widget build(BuildContext context) {

    print('before camera');
    print(parentEntity);
    return new Scaffold(
     // key:_scaffoldKey,
     // appBar: _buildAppBar(),
      body:
      //parentEntity.milestoneRuleSet == null
         // ? Center(child: Text('Empty'),)
          _buildCameraBody(),
     // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar(){
    return AppBar(

        title: Text("Stand No: ${parentEntity.unit}"));
  }

  Widget _buildCameraBody(){


    return Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100,
          child: ListView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: _photos.length +1,
            itemBuilder: (context,index){
            if(index == 0)
              {
                return _buildAddPhoto();
              }

            File image =_photos[index-1];
            PhotoSource source =_photoSources[index-1];
            return Stack(
              children: <Widget>[
                InkWell(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    height:100,
                    width:100,
                    color:kLightGray,
                    child:source == PhotoSource.FILE
                        ? Image.file(image)
                        :Image.network(_photosUrls[index-1],)
                  ),
                )
              ],
            );
            },
          ),
        ),
        Container(
 margin: EdgeInsets.all(16),
          child: RaisedButton(
            child:Text('Upload'),
            onPressed: (){},
          ),
        )
      ],

    );
  }
_buildAddPhoto(){
    return InkWell(
        onTap:()=> _onAddPhotoClicked(context),
      child:Container(
        margin: EdgeInsets.all(5),
        height: 100,
        width: 100,
        color: kDarkGray,
        child: Center(
          child: Icon(
            MaterialIcons.add_to_photos,
            color: kLightGray,
          ),
        ),
      )
    );
}

_onAddPhotoClicked(context)async{
  print('trigger');
    Permission permission;
    if(Platform.isIOS)
      {
        permission = Permission.photos;
      }else{
      permission = Permission.storage;
    }
    PermissionStatus permissionStatus = await permission.status;
    print(permissionStatus);

    if(permissionStatus == PermissionStatus.restricted)
      {
        _showOpenAppSettingsDialog(context);
        permissionStatus = await permission.status;
      }
    if(permissionStatus == PermissionStatus.granted)
    {
      print('approved');
      print('Permission granted implemented');

      File image = await ImagePicker.pickImage(
          source: ImageSource.gallery);

      if(image != null)
      {
        String fileExtension = p.extension(image.path);
        _galleryItems.add(
            GalleryItem(
              id:Uuid().v1(),
              resource:image.path,
              isSvg: fileExtension.toLowerCase() == ".svg",
            )
        );

        setState(() {
          _photos.add(image);
          _photoSources.add(PhotoSource.FILE);
        });
        print('Upload now');
        _UploadImage(image);
      }
      return;
    }
    if(permissionStatus == PermissionStatus.permanentlyDenied)
    {
      _showOpenAppSettingsDialog(context);
      permissionStatus = await permission.status;
      if(permissionStatus == PermissionStatus.granted)
      {
        //only continue if permission granted
        return;
      }
    }
    if (permissionStatus == PermissionStatus.undetermined) {
      permissionStatus = await permission.request();

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {


    }




}

_UploadImage(File image )async
{
  String fileExtension = p.extension(image.path);
  String uploadUrl ='';
  print('trrigger upload');
  /*
  GenerateImageUrl generateImageUrl = GenerateImageUrl();
  await generateImageUrl.call(fileExtension);


  if(generateImageUrl.isGenerated !=null && generateImageUrl.isGenerated)
    {
      uploadUrl = generateImageUrl.uploadUrl;
    }else{
    throw generateImageUrl.message;
  }
*/
  bool isUploaded = await uploadFile(context,uploadUrl,image);
  if(isUploaded)
    {
      setState(() {
        _photosUrls.add('');
      });
    }


}

Future<bool> uploadFile(context,String url,File image)async{
    try{
      ImageService uploadFile = ImageService();
      await uploadFile.call(url, image);

      if(uploadFile.isUploaded!=null && uploadFile.isUploaded)
        {
          return true;
        }else{
        throw uploadFile.message;
      }
        }
    catch(e){
      throw e;
    }
}
  _showOpenAppSettingsDialog(context) {
    return CustomDialog.show(
      context,
      'Permission needed',
      'Photos permission is needed to select photos',
      'Open settings',
      openAppSettings,
    );
  }

  Widget _buildBottomNavigationBar(){
    return BottomAppBar(

      child: RaisedButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Text('Save & Continue'),

        onPressed: (){
          print('save milestone');
          saveMilestone();
        },
      ),

    );
  }


  void saveMilestone() async{

    print('save milestone');
    var saveResponse = await RequestResidentialUnitService.postEntity(parentEntity);

    if(saveResponse)
      {
        Navigator.pop(context,true);
      }else{
      showMessage('An error occured please try again!',Colors.red);
    }
    }
  Color _toggleColor(bool isCompliant){
    return Colors.white;
  }

  Widget _displayByStyle(bool isCompliant){
    return isCompliant ?Icon(Icons.check_circle):Icon(Icons.account_balance);
  }

  void showMessage(String message,[MaterialColor color = Colors.red])
  {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(
        backgroundColor: color,
        content: new Text(message)));
  }

  }




