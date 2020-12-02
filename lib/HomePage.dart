import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class HomePage extends StatefulWidget{
  _HomePageState createState()=> _HomePageState();
  }
  class _HomePageState extends State<HomePage>{
    File fil;
    String tex='';
    parsetext()async {
final  imagefile=await ImagePicker().getImage(source: ImageSource.gallery,maxHeight: 600,maxWidth: 500);
print("imagefile");
print(imagefile);

var  bytes=File(imagefile.path.toString()).readAsBytesSync();
print("filepath");
print(imagefile.path);
setState(() {
  fil=File(imagefile.path);
});

String image64=base64Encode(bytes);
String url="https://api.ocr.space/parse/image";
var playboad={"base64Image":"data:image/jpeg;base64,${image64.toString()}"};
var api={"apikey":"eadd79e5e388957"};
var response=await http.post(url,body:playboad,headers:api );
 var result=  jsonDecode(response.body);
 print("response");
 print(response);
 print("result")
; print(result["ParsedResults"][0]["ParsedText"]);
setState(() {
  

tex=result["ParsedResults"][0]["ParsedText"];
});
    }
Widget build(BuildContext context){
return Scaffold(
 
  appBar: AppBar(
  backgroundColor: Colors.pink[400],
    title:Text("OCR APP",style: GoogleFonts.montserrat(fontSize:25,fontWeight:FontWeight.w800,color:Colors.black87.withOpacity(0.7),)),
    centerTitle: true,
  ),
  body: SingleChildScrollView(child:Container(
    decoration: BoxDecoration(borderRadius:BorderRadius.circular(30),color:Colors.grey[500], ),
    
    width: MediaQuery.of(context).size.width-20,
    margin: EdgeInsets.symmetric(horizontal:10,vertical:8),
    child: Column(children: <Widget>[
GestureDetector(
onTap: () => parsetext(),
  child:
      Container(
      
        margin: EdgeInsets.symmetric(vertical:10),
        decoration: BoxDecoration(
            color: Colors.red[400].withOpacity(0.8),
            borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.symmetric(horizontal:30,vertical:30),
        child:Text("Upload a Image",style: GoogleFonts.montserrat(fontWeight: FontWeight.w600,fontSize: 18,color:Colors.white)
        ),
        )),

      SizedBox(height:20),
      fil==null? Container(color: Colors.red,):Container(height: 250,width: 350,
        child:Image(image:FileImage(fil))),
       SizedBox(height:25),
       tex.isEmpty?Container():Container(color: Colors.amber[300],
         width: 350,
         child: Text(tex,style: GoogleFonts.montserrat(fontSize:18,fontWeight: FontWeight.w800),),),
         SizedBox(height:25),
        
         ]
  ),)
));

}
  }