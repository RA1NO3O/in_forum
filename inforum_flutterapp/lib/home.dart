import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:inforum/editPost.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  IconData _actionIcon = Icons.post_add;

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: const Icon(Icons.home, size: 30, color: Colors.blue),
          label: '首页'),
      BottomNavigationBarItem(
          icon:
              const Icon(Icons.local_post_office, size: 30, color: Colors.pink),
          label: '私信'),
      BottomNavigationBarItem(
          icon: const Icon(Icons.search, size: 30, color: Colors.cyan),
          label: '搜索'),
      BottomNavigationBarItem(
          icon: const Icon(Icons.person, size: 30, color: Colors.orange),
          label: '我')
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
            switch (_currentIndex) {
              case 0:
                _actionIcon = Icons.post_add;
                break;
              case 1:
                _actionIcon = Icons.add_comment;
                break;
            }
          });
        },
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? new FloatingActionButton(
              child: AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> anim) {
                  return ScaleTransition(child: child, scale: anim);
                },
                duration: Duration(milliseconds: 150),
                child: Icon(_actionIcon, key: ValueKey(_actionIcon)),
              ),
              onPressed: () {
                switch (_currentIndex) {
                  case 0:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return EditPostScreen();
                    }));
                    break;
                  case 1:
                    print(_currentIndex);
                    break;
                }
              },
            )
          : null,
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
        Center(child: Text('123')),
      ],
    );
  }
}
