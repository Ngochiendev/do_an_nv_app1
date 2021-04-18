import 'package:do_an_nv_app/pages/table_page.dart';
import 'package:flutter/material.dart';
class IdentifyPage extends StatelessWidget {
  static const String routeName = '/IdentifyPage';
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _idController = TextEditingController();
    return
      SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formState,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.account_circle),
                          labelText:  'Nhập tên nhân viên'
                      ),
                      // keyboardType: TextInputType.emailAddress,
                      autovalidate: false,
                      autocorrect: false,
                      validator: (value)=> value.isEmpty ? 'Nhập tên nhân viên' : null,
                    ),
                    TextFormField(
                      controller: _idController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock_open_outlined),
                          labelText: 'Nhập MSNV'
                      ),
                      // obscureText: true,
                      autovalidate: false,
                      autocorrect: false,
                      validator: (value)=> value.isEmpty ? 'Nhập mã số nhân viên' : null,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            onPressed: (){
                              if(_formState.currentState.validate()){
                                Navigator.pushNamed(context, TablePage.routeName,
                                    arguments: {'name': _nameController.text, 'id': _idController.text});
                              }
                            },
                            child: Text('Xác nhận', style: TextStyle(color: Colors.white, fontSize: 16),),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10),),
                        ],
                      ),// a login button here
                    ),
                  ],
                ),
              ),
            )
          ),
        )
    );
  }
}
