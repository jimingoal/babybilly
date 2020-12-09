import 'package:babybilly/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  PanelController sc = new PanelController();

  @override
  void initState() {
    super.initState();

    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Scaffold(
      backgroundColor: white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '앗, 방지민님은 아직 체크리스트가 없어요.',
                  style: bodyStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    'baby.jpeg',
                    fit: BoxFit.cover,
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 55.0,
                  width: 350.0,
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: FlatButton(
                    child: Text(
                      '지금 내 체크리스트 만들기 ➔',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        _fabHeight =
                            100 * (_panelHeightOpen - _panelHeightClosed) +
                                _initFabHeight;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SlidingUpPanel(
            controller: sc,
            maxHeight: _panelHeightOpen,
            minHeight: 20,
            parallaxEnabled: true,
            parallaxOffset: .5,
            panelBuilder: (sc) {
              print('panelBuilder');
              return _panel(sc);
            },
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            // onPanelSlide: (double pos) => setState(() {
            //   _fabHeight = 100 * (_panelHeightOpen - _panelHeightClosed) +
            //       _initFabHeight;
            // }),
          ),
        ],
      ),
    );
  }

  Widget _getSlidingUpPanel() {
    print('getSlidingUpPanel');
    return SlidingUpPanel(
      panel: Center(
        child: Text("This is the sliding Widget"),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Explore Pittsburgh",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 36.0,
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Images",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl:
                            "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
                        height: 120.0,
                        width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                        fit: BoxFit.cover,
                      ),
                      CachedNetworkImage(
                        imageUrl:
                            "https://cdn.pixabay.com/photo/2016/08/11/23/48/pnc-park-1587285_1280.jpg",
                        width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("About",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    """Pittsburgh is a city in the state of Pennsylvania in the United States, and is the county seat of Allegheny County. A population of about 302,407 (2018) residents live within the city limits, making it the 66th-largest city in the U.S. The metropolitan population of 2,324,743 is the largest in both the Ohio Valley and Appalachia, the second-largest in Pennsylvania (behind Philadelphia), and the 27th-largest in the U.S.\n\nPittsburgh is located in the southwest of the state, at the confluence of the Allegheny, Monongahela, and Ohio rivers. Pittsburgh is known both as "the Steel City" for its more than 300 steel-related businesses and as the "City of Bridges" for its 446 bridges. The city features 30 skyscrapers, two inclined railways, a pre-revolutionary fortification and the Point State Park at the confluence of the rivers. The city developed as a vital link of the Atlantic coast and Midwest, as the mineral-rich Allegheny Mountains made the area coveted by the French and British empires, Virginians, Whiskey Rebels, and Civil War raiders.\n\nAside from steel, Pittsburgh has led in manufacturing of aluminum, glass, shipbuilding, petroleum, foods, sports, transportation, computing, autos, and electronics. For part of the 20th century, Pittsburgh was behind only New York City and Chicago in corporate headquarters employment; it had the most U.S. stockholders per capita. Deindustrialization in the 1970s and 80s laid off area blue-collar workers as steel and other heavy industries declined, and thousands of downtown white-collar workers also lost jobs when several Pittsburgh-based companies moved out. The population dropped from a peak of 675,000 in 1950 to 370,000 in 1990. However, this rich industrial history left the area with renowned museums, medical centers, parks, research centers, and a diverse cultural district.\n\nAfter the deindustrialization of the mid-20th century, Pittsburgh has transformed into a hub for the health care, education, and technology industries. Pittsburgh is a leader in the health care sector as the home to large medical providers such as University of Pittsburgh Medical Center (UPMC). The area is home to 68 colleges and universities, including research and development leaders Carnegie Mellon University and the University of Pittsburgh. Google, Apple Inc., Bosch, Facebook, Uber, Nokia, Autodesk, Amazon, Microsoft and IBM are among 1,600 technology firms generating \$20.7 billion in annual Pittsburgh payrolls. The area has served as the long-time federal agency headquarters for cyber defense, software engineering, robotics, energy research and the nuclear navy. The nation's eighth-largest bank, eight Fortune 500 companies, and six of the top 300 U.S. law firms make their global headquarters in the area, while RAND Corporation (RAND), BNY Mellon, Nova, FedEx, Bayer, and the National Institute for Occupational Safety and Health (NIOSH) have regional bases that helped Pittsburgh become the sixth-best area for U.S. job growth.
                  """,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }

  Widget _body() {
    return Container();
    //   Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         '앗, 방지민님은 아직 체크리스트가 없어요.',
    //         style: bodyStyle,
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(top: 10.0),
    //         child: Image.asset(
    //           'baby.jpeg',
    //           fit: BoxFit.cover,
    //           width: 200.0,
    //           height: 200.0,
    //         ),
    //       ),
    //       Container(
    //         margin: EdgeInsets.symmetric(vertical: 20.0),
    //         height: 55.0,
    //         width: 350.0,
    //         decoration: BoxDecoration(
    //           color: blue,
    //           borderRadius: BorderRadius.circular(30.0),
    //         ),
    //         child: FlatButton(
    //           child: Text(
    //             '지금 내 체크리스트 만들기 ➔',
    //             style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 18.0,
    //                 fontWeight: FontWeight.bold),
    //           ),
    //           onPressed: () {
    //             setState(() {
    //               _fabHeight = 100 * (_panelHeightOpen - _panelHeightClosed) +
    //                   _initFabHeight;
    //             });
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
