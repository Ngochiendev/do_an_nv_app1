import 'package:do_an_nv_app/modules/employes.dart';
import 'package:do_an_nv_app/pages/table_page.dart';
import 'package:flutter/material.dart';
import 'package:do_an_nv_app/datas/data.dart';
import 'package:provider/provider.dart';
class IdentifyPage extends StatelessWidget {
  static const String routeName = '/IdentifyPage';
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FireStoreDatabaseEmployers employersData = Provider.of<FireStoreDatabaseEmployers>(context);
    TextEditingController _nameController = TextEditingController();
    TextEditingController _passController = TextEditingController();
    return
      SafeArea(
        child: Scaffold(
          body: Center(
            child: StreamBuilder(
              stream: employersData.getEmployeeDataFromFireBase(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  Future<void> showAlert(){
                    return showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context){
                          return AlertDialog(
                            title: Text('Tên Nhân viên hoặc mật khẩu không đúng'),
                            content: Text('Vui lòng nhập lại'),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text('Xác Nhận', style: TextStyle(color: Colors.green),)
                              ),
                            ],
                          );
                        }
                    );
                  }
                  return Padding(
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
                            autocorrect: false,
                            validator: (value){
                               if(value.isEmpty){
                                 return 'Nhập Tên nhân viên';
                               }
                               else{
                                 return null;
                               }
                            },
                          ),
                          TextFormField(
                            controller: _passController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock_open_outlined),
                                labelText: 'Nhập Password',
                            ),
                            obscureText: true,
                            autocorrect: false,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Nhập Password nhân viên';
                              }
                              else{
                                return null;
                              }
                            },
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

                                      int index = 0;
                                      snapshot.data.forEach((EmployeSnapshot employee){
                                        if(employee.employes.name.toLowerCase().split(' ').join('') == _nameController.text
                                        && employee.employes.pass == _passController.text){
                                          Navigator.pushNamed(context, TablePage.routeName,
                                              arguments: {'employee': employee.employes});
                                          _passController.clear();
                                        }
                                        else{
                                          index++;
                                        }
                                      });
                                      if(index == snapshot.data.length){
                                        showAlert();
                                      }
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
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          )
        )
    );
  }
}
