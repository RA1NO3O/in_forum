import 'package:flutter/material.dart';
import 'package:animations/animations.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context){
    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon:const Icon(
            Icons.home,
            size: 30,
            color: Colors.blue
        ),
        label: '首页'
      ),
      BottomNavigationBarItem(
        icon:const Icon(
            Icons.local_post_office,
            size: 30,
            color: Colors.pink
        ),
        label: '私信'
      ),
      BottomNavigationBarItem(
        icon: const Icon(
            Icons.search,
            size: 30,
            color: Colors.cyan
        ),
        label: '搜索'
      ),
      BottomNavigationBarItem(
        icon:const Icon(
            Icons.person,
            size: 30,
            color: Colors.orange
        ),
        label: '我'
      )
    ];

    return Scaffold(
      body: Center(
        child: PageTransitionSwitcher(
          child: _NavigationDestinationView(
            // Adding [UniqueKey] to make sure the widget rebuilds when transitioning.
            key: UniqueKey(),
            item: bottomNavigationBarItems[_currentIndex],
          ),
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeThroughTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        fixedColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _NavigationDestinationView extends StatelessWidget {
  _NavigationDestinationView({Key key, this.item}) : super(key: key);

  final BottomNavigationBarItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text('123')
        ),
      ],
    );
  }
}

