import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:modalroute_test/popup.dart';

import 'AppState.dart';

Store<AppState> store;
final navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  NavigateAction.setNavigatorKey(navigatorKey);
  var initialState = AppState();
  store = Store<AppState>(initialState: initialState);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark(),
        routes: {
          '/':(BuildContext context) => MyHomePageConnected(),
          //'/popup':(BuildContext context) => Popup(),
        },
        navigatorKey: navigatorKey,
      ),
    );
  }
}
class MyHomePage extends StatelessWidget {
  final VoidCallback dispatchModal;
  
  handleButton(){
    dispatchModal();
  }

  const MyHomePage({Key key, @required this.dispatchModal}) : super(key: key);
  
  @override
  build(BuildContext context){
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            RaisedButton(
              onPressed: handleButton,
              child: Text('Open with async_redux'),
            ),
          ]
        ),
      ),
    );
  }
}
class MyHomePageConnected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MyHomePageViewModel>(
      model: MyHomePageViewModel(),
      builder: (BuildContext context, MyHomePageViewModel vm){
        return MyHomePage(
          dispatchModal: vm.openModalFunction,
        );
      },
    );
  }
}


class MyHomePageViewModel extends BaseModel<AppState> {
  MyHomePageViewModel();
  VoidCallback openModalFunction;
  VoidCallback closeModalFunction;
  
  MyHomePageViewModel.build({
    this.openModalFunction,
    this.closeModalFunction,
  }) : super();
  @override
  fromStore() => MyHomePageViewModel.build(
    openModalFunction: () => dispatch(ActionOpenModal()),
    closeModalFunction: () => dispatch(ActionCloseModal())
  );
  
}

class ActionOpenModal extends ReduxAction<AppState> {
  ActionOpenModal();
  @override
  AppState reduce() {
    Color c = Theme.of(navigatorKey.currentContext).backgroundColor;
    dispatch(NavigateAction.push(Popup()));
    return null;
  } 
}
class ActionCloseModal extends ReduxAction<AppState> {
  ActionCloseModal();
  @override
  AppState reduce() {
    dispatch(NavigateAction.pop());
    return null;
  } 
}