

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

import 'AppState.dart';
import 'main.dart';

class Popup extends ModalRoute{
  Popup(); //// Color passed into constructor from caller which has access to context.
  @override
  Color get barrierColor => Theme.of(navigatorKey.currentContext).backgroundColor;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => PopupPageConnected();
  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 1000);
  

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
        child: child,
    );
  }
}


class PopupPage extends StatelessWidget {
  final VoidCallback dispatchCloseModal;

  const PopupPage({Key key, this.dispatchCloseModal}) : super(key: key);
  
  build(BuildContext context){
    return Material(
      type:MaterialType.transparency,
      child:GestureDetector(
        child: Center(
          child:Text('Hello, world!',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontSize: 50,
            ),
          )
        ),
        onTap: (){
          dispatchCloseModal();
        } ,
      )
    );
  }
}



class PopupPageConnected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MyHomePageViewModel>(
      model: MyHomePageViewModel(),
      builder: (BuildContext context, MyHomePageViewModel vm){
        return PopupPage(
          dispatchCloseModal: vm.closeModalFunction,
        );
      },
    );
  }
}