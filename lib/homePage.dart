import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/upload.dart';
import 'package:ev/videoModel.dart';
import 'package:flutter/material.dart';
import 'Utils/SizeConfig.dart';
import 'Utils/constants.dart';
import 'videoP.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoModel> dataList = [];
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();

    getVideoData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 400;
    var h = SizeConfig.screenHeight / 800;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Upload();
                },
              ),
            );
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Film Space",
            style: txtS(Colors.white, 20, FontWeight.w700),
          ),
          backgroundColor: Colors.transparent,
          elevation: 3,
          shadowColor: Colors.black,
        ),
        body:
            /*SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: [
            sh(10),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showBottomSheet();
                    },
                    child: Container(
                      height: SizeConfig.screenHeight - (h * 60),
                      width: SizeConfig.screenWidth,
                      child: Stack(alignment: Alignment.topCenter, children: [
                        VideoPlayerScreen(),
                        Positioned(
                          bottom: SizeConfig.screenHeight * 0.04,
                          child: Column(
                            children: [
                              Container(
                                width: SizeConfig.screenWidth,
                                padding:
                                    EdgeInsets.symmetric(horizontal: b * 10),
                                child: Text(
                                  'Title ',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      txtS(Colors.black, 18, FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                }),
          ]),
        ),*/
            PageView.builder(
          physics: BouncingScrollPhysics(),

          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (dataList.isEmpty)
              return Container(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ));
            else
              return InkWell(
                onTap: () {
                  showBottomSheet(dataList[index].title, dataList[index].des,
                      dataList[index].videoLink);
                },
                child: Container(
                  height: SizeConfig.screenHeight - (h * 10),
                  width: SizeConfig.screenWidth,
                  child: Stack(alignment: Alignment.topCenter, children: [
                    VideoPlayerScreen(dataList[index].videoLink),
                    Positioned(
                      bottom: SizeConfig.screenHeight * 0.04,
                      child: Column(
                        children: [
                          Container(
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(horizontal: b * 10),
                            child: Text(
                              dataList[index].title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: txtS(Colors.white, 18, FontWeight.w500),
                            ),
                          ),
                          sh(10),
                        ],
                      ),
                    ),
                  ]),
                ),
              );
          },
          itemCount: dataList.length, // Can be null
        ),
      ),
    );
  }

  SizedBox sh(double h) {
    return SizedBox(height: SizeConfig.screenHeight * h / 800);
  }

  TextStyle txtS(Color col, double siz, FontWeight wg) {
    return TextStyle(
      color: col,
      fontWeight: wg,
      fontSize: SizeConfig.screenWidth * siz / 400,
    );
  }

  showBottomSheet(String title, String des, String link) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 400;
    var h = SizeConfig.screenHeight / 800;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: b * 10),
        margin: EdgeInsets.only(top: h * 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(b * 20),
            topRight: Radius.circular(b * 20),
          ),
        ),
        child: Column(
          children: [
            sh(50),
            Container(
              height: h * 350,
              width: SizeConfig.screenWidth,
              child: VideoPlayerScreen(link),
            ),
            sh(30),
            Text(
              title,
              textAlign: TextAlign.center,
              style: txtS(Colors.black, 18, FontWeight.w500),
            ),
            sh(30),
            Text(
              des,
              textAlign: TextAlign.center,
              style: txtS(Colors.black, 16, FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  getVideoData() async {
    FirebaseFirestore.instance.collection('videos').snapshots().listen((snap) {
      for (var i in snap.docs) {
        VideoModel tempModel = VideoModel(
            i.data()['title'],
            i.data()['des'],
            i.data()['videoLink'],
            i.data()['thumbLink'],
            i.data()['timestamp']);

        dataList.add(tempModel);
      }

      setState(() {});
    });
  }
}
