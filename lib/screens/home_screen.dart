import 'package:bizzsetu/model/getdata_model.dart';
import 'package:bizzsetu/services/http_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GetData? _getData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    var response = await HttpService.hGet('https://reqres.in/api/users?page=');

    setState(() {
      _getData = GetData.fromJson(response.data);
    });

    print(_getData!.perPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('GFG Pagination'),
          centerTitle: false,
          backgroundColor: Colors.green.shade600),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
