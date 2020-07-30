import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/viewmodels/session/index.dart';

class LoginView extends StatefulWidget {
  final SessionViewModel viewModel;

  LoginView({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginView();
  }
}

class _LoginView extends State<LoginView> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.checkWechatIsInstall();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<SessionViewModel>(
        builder: (context, viewmodel, child) {
          return Scaffold(
            body: Center(
              child: viewmodel.isWechatInstalled == true
                  ? MaterialButton(
                      child: Image.asset('assets/images/icon_wx_button.png'),
                      onPressed: viewmodel.isLoading == true ? () {} : viewmodel.loginWithWechat,
                    )
                  : Text('no wechat installed'),
            ),
          );
        },
      ),
    );
  }
}
