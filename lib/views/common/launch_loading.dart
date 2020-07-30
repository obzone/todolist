import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/viewmodels/common/launch_load.dart';
import 'package:todolist/viewmodels/session/index.dart';
import 'package:todolist/views/index.dart';
import 'package:todolist/views/session/login.dart';

class LaunchLoadingView extends StatefulWidget {
  final LaunchLoadingViewModel viewModel;

  LaunchLoadingView({Key key, @required this.viewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LaunchLoadingView();
  }
}

class _LaunchLoadingView extends State<LaunchLoadingView> {
  @override
  void initState() {
    super.initState();

    this._checkState();
  }

  _checkState() async {
    await widget.viewModel.checkState();

    if (widget.viewModel.isLoading == false && widget.viewModel.e != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginView(
            viewModel: SessionViewModel.getInstance(),
          ),
        ),
      );
    } else if (widget.viewModel.isLoading == false && widget.viewModel.e == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageView(),
        ),
      );
    }
  }

  Widget _buildLoadingIndicatorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text('正在加载所需资源...'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: widget.viewModel,
        child: Consumer<LaunchLoadingViewModel>(
          builder: (context, viewModel, child) {
            return Center(
              child: this._buildLoadingIndicatorWidget(),
            );
          },
        ),
      ),
    );
  }
}
