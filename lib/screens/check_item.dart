import 'package:carbon_footprint_calculator/screens/item_details.dart';
import 'package:carbon_footprint_calculator/screens/your_clothes.dart';
import 'package:carbon_footprint_calculator/themes/default_theme.dart';
import 'package:carbon_footprint_calculator/widgets/border_icon.dart';
import 'package:carbon_footprint_calculator/widgets/brands_grid.dart';
import 'package:carbon_footprint_calculator/widgets/widget_functions.dart';
import 'package:flutter/material.dart';

class ItemCalculationStart extends StatefulWidget {
  final int tab;

  const ItemCalculationStart({Key? key, required this.tab}) : super(key: key);

  @override
  _ItemCalculationStartState createState() => _ItemCalculationStartState();
}

class _ItemCalculationStartState extends State<ItemCalculationStart>
    with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }

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

class CheckItemStart extends StatelessWidget {
  const CheckItemStart({Key? key}) : super(key: key);

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
            "We'll ask you a few questions to calculate the impact of your item.",
            textAlign: TextAlign.center,
            style: themeData.textTheme.headline3,
          ))
        ]),
      ),
      addVerticalSpace(25),
      ElevatedButton(
        child: const Text('Start'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ItemInfoPage()),
          );
        },
      )
    ]);
  }
}
