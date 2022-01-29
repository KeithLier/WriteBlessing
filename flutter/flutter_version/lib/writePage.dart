

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';




class WriteBlessingPage extends StatefulWidget {
  const WriteBlessingPage({Key? key}) :super(key: key);

  @override
  WriteBlessingPageState createState() => WriteBlessingPageState();
}

class WriteBlessingPageState extends State<WriteBlessingPage> {
  GlobalKey key = GlobalKey();

  PointerEvent? _event;

  // 所有的笔画数组
  List<List<Offset>> _lines = [];

  // 点集合
  List<Offset> _points = [];

  // 截图
  Uint8List? _postBytes;

  // 画笔颜色
  Color _paintColor = Colors.black;

  bool _onOff = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            key: key,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/images/bg.png",
                  )
                )
              ),
              child: CustomPaint(painter: BlessingPainter(_lines,_paintColor),),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover, 
                image: AssetImage(
                  "assets/images/bg.png",
                ),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.25,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Text(
                            "福",
                            style: TextStyle(
                              fontSize: 260,
                              color: Color(0xffcb442b),
                              fontFamily: "kaiti",
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    Listener(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                      ),
                      onPointerDown: (PointerDownEvent event) {
                        setState(() {
                          _event = event;
                          _points.add(_event?.localPosition ?? Offset.zero);
                          _lines.add(_points);
                        });

                      },
                      onPointerMove: (PointerMoveEvent event) {
                        setState(() {
                          _event = event;
                          _points.add(_event?.localPosition ?? Offset.zero);
                          _lines.last = _points;
                        });
                      },
                      onPointerUp: (PointerUpEvent event) {
                        setState(() {
                          _event = event;
                          _points.add(Offset.zero);
                          _lines.last = _points;
                        });
                        _points = [];

                      },
                    ),
                    Positioned(
                      top:MediaQuery.of(context).size.height * 0.15,
                      left: 20,
                      child: CupertinoSwitch(
                        value: _onOff,
                        onChanged: (onOff) {
                          setState(() {
                            _onOff = onOff;
                            _paintColor = onOff ? Colors.amber : Colors.black;

                          });
                        },
                        activeColor: Colors.amber,
                        trackColor: Colors.black,
                      ),
                    ),
                    Positioned(
                      left: (_event != null ? _event?.position.dx : 0),
                      top: (_event != null ? (_event?.position.dy ?? 0) : 0),
                      child: Container()
                    ),
                    CustomPaint(painter: BlessingPainter(_lines,_paintColor)),
                    Positioned(
                      bottom: 50,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  _lines.removeLast();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: const Text(
                                  "撤销",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                saveImage();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: const Text(
                                  "保存到相册",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  _lines = [];
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: const Text(
                                  "重写",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  saveImage() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted &&
        statuses[Permission.photos] == PermissionStatus.granted) {
      Fluttertoast.showToast(
        msg: "正在保存请稍后...",
      );
      RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      _postBytes = byteData?.buffer.asUint8List();
      var result = await ImageGallerySaver.saveImage(_postBytes!);
      if (result != null && result != "" && result["isSuccess"] == true) {
        Fluttertoast.showToast(
          msg: "保存成功",
        );
      }else{
        Fluttertoast.showToast(
          msg: "保存失败${result["errorMessage"]}",
        );
      }
    }else{
      Fluttertoast.showToast(
        msg: "无存储权限",
      );
    }
  }
}


class BlessingPainter extends CustomPainter {
  BlessingPainter(this.lines, this.paintColor);

  final List<List<Offset>> lines;
  final Color paintColor;

  Paint myPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    myPaint.strokeCap = StrokeCap.round;
    myPaint.color = paintColor;
    myPaint.strokeWidth = 20.0;
    if(lines.isEmpty) {
      canvas.drawPoints(PointMode.polygon, [Offset.zero, Offset.zero], myPaint);
    } else {
      for(int i = 0; i < lines.length; i++) {
        for(int j = 0; j < lines[i].length - 1; j++) {
          if(lines[i][j] != Offset.zero && lines[i][j + 1] != Offset.zero) {
            canvas.drawLine(lines[i][j], lines[i][j + 1], myPaint);
          }
        }
      }
    }

  }

  @override
  bool shouldRepaint(BlessingPainter painter) => true;

}