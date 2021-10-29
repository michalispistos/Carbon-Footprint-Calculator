import 'package:carbon_footprint_calculator/screens/item_details.dart';
import 'package:carbon_footprint_calculator/screens/your_clothes.dart';
import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/brands_grid.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:carbon_footprint_calculator/screens/carbon_score_result.dart';
import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:carbon_footprint_calculator/data/item.dart';
import 'package:carbon_footprint_calculator/utils/barcode_items_sample_data.dart';
import 'package:flutter/material.dart';
import 'package:carbon_footprint_calculator/screens/carbon_score_result.dart';
import 'package:carbon_footprint_calculator/screens/check_item.dart';

class ItemCalculationStart extends StatefulWidget {
  final int tab;

  const ItemCalculationStart({Key? key, required this.tab}) : super(key: key);

  @override
  _ItemCalculationStartState createState() => _ItemCalculationStartState();
}

class _ItemCalculationStartState extends State<ItemCalculationStart>
    with TickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(
        child: Row(
      children: [
        addHorizontalSpace(30),
        const Text("Check Item"),
        addHorizontalSpace(30)
      ],
    )),
    // ChoiceOption(text: "Check Item"),
    Tab(
        child: Row(
      children: [
        addHorizontalSpace(30),
        const Text("Your Clothes"),
        addHorizontalSpace(30)
      ],
    )),
    Tab(
        child: Row(
      children: [
        addHorizontalSpace(30),
        const Text("Best Brands"),
        addHorizontalSpace(30)
      ],
    )),
    Tab(
        child: Row(
      children: [
        addHorizontalSpace(30),
        const Text("Your Score"),
        addHorizontalSpace(30)
      ],
    )),
    // ChoiceOption(text: "Your Score")
  ];

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(vsync: this, length: myTabs.length);
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    _tabController.animateTo(widget.tab);

    return SafeArea(
      top: false,
      bottom: false,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          // TODO: Implement drawer functionality.
          endDrawer: Drawer(),
          body: Stack(children: <Widget>[
            CustomPaint(
                size: Size.infinite, painter: CircleBackgroundPainter()),
            Column(
              children: [
                addVerticalSpace(60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            BorderIcon(
                                height: 40,
                                width: 40,
                                bgColor: const Color(0xffffe8ec),
                                child: Image.asset('images/leaf.png')),
                            addHorizontalSpace(10),
                            //TODO: login system xd
                            Text("Hi, User",
                                style: themeData.textTheme.headline4),
                          ],
                        ),
                        const Icon(Icons.menu, color: CustomTheme.COLOR_BLACK)
                      ]),
                ),
                addVerticalSpace(15),
                TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  controller: _tabController,
                  tabs: myTabs,
                ),
                addVerticalSpace(15),
                Expanded(
                    child: TabBarView(
                        controller: _tabController,
                        children: const [
                      CheckItemStart(),
                      ClothesList(),
                      BrandsGrid(),
                      Icon(Icons.ac_unit)
                    ])),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class CircleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Offset sets each circle's center
    canvas.drawCircle(Offset(size.width - 40, 20), 150,
        Paint()..color = const Color(0xffffe3d3));
    canvas.drawCircle(Offset(size.width / 2, size.height), 300,
        Paint()..color = const Color(0xffe7f6ff));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CheckItemStart extends StatefulWidget {
  const CheckItemStart({Key? key}) : super(key: key);

  @override
  _CheckItemStartState createState() => _CheckItemStartState();
}

class _CheckItemStartState extends State<CheckItemStart> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Check your item",
                style: themeData.textTheme.headline1,
                textAlign: TextAlign.left),
          ],
        ),
      ),
      addVerticalSpace(size.height / 2 - 200),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
              child: Text(
            "Check method to calculate the impact of your item.",
            textAlign: TextAlign.center,
            style: themeData.textTheme.headline3,
          ))
        ]),
      ),
      addVerticalSpace(25),
      FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        color: const Color(0xfffffaca),
        onPressed: () async {
          scan();
        },
        child: const Text('Scan Barcode',
            style: TextStyle(
              fontSize: 17,
            )),
      ),
      addVerticalSpace(25),
      FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        color: const Color(0xfffffaca),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ItemInfoPage()),
          );
        },
        child: const Text('Import Details Manually',
            style: TextStyle(
              fontSize: 17,
            )),
      ),
    ]);
  }

  String _data = "";
  Map<String, Item> sampleBarcodeItems = BarcodeItems.sampleBarcodeItems;

  scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => {
              setState(() {
                _data = value.toString();
                if (_data == "-1") {

                } else {
                  if(sampleBarcodeItems.containsKey(_data)){
                    createCalculateFootprintDialog(context);
                  }else{
                    createErrorDialog(context,"Item is not in database");
                }}
              })
            });
  }

  Item getItem(){
    return sampleBarcodeItems[_data]!;
  }

  Future createCalculateFootprintDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text("Item detected: ${getItem().name}",
                    style: const TextStyle(
                      fontSize: 20,
                    ))),
            content: SizedBox(
                height: 300,
                child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage(getItem().imagePath),
                          //fit: BoxFit.fill,
                        ),
                        border: Border.all(
                            color: Colors.pink.shade50.withAlpha(100),
                            width: 1)))),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                color: const Color(0xfffffaca),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarbonScoreResult(
                            item: getItem())),
                  );
                },
                child: const Text('Calculate carbon score',
                    style: TextStyle(
                      fontSize: 17,
                    )),
              ),
              MaterialButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                elevation: 5.0,
                child: const Text("CLOSE"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future createErrorDialog(BuildContext context, String errorMessage) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: SizedBox(
                height: 20,
                child: Text(errorMessage,
                    style: const TextStyle(
                      fontSize: 15,
                    ))),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                elevation: 5.0,
                child: const Text("CLOSE"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
