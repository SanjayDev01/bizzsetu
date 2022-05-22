import 'package:bizzsetu/model/getdata_model.dart';
import 'package:bizzsetu/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GetData? _getData;
  List<Data>? _dataList;
  int pageNumber = 0;
  bool dataLoaded = false;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(pageNumber);
  }

  Future<void> getData(int page) async {
    var response =
        await HttpService.hGet('https://reqres.in/api/users?page=$page');

    setState(() {
      _getData = GetData.fromJson(response.data);
    });

    if (_getData != null) {
      setState(() {
        dataLoaded = true;
      });
      if (_dataList == null) {
        setState(() {
          _dataList = _getData!.data;
        });
      } else {
        setState(() {
          _dataList!.addAll(_getData!.data);
        });
      }
    } else {
      setState(() {
        dataLoaded = false;
      });
    }

    print(_dataList);
  }

  getMore() {
    setState(() {
      pageNumber = pageNumber + 2;
    });
    getData(pageNumber);
  }

  getDefault() {
    _dataList!.clear();
    setState(() {
      pageNumber = 0;
    });
    getData(pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('GFG Pagination'),
          centerTitle: false,
          backgroundColor: Colors.green.shade600),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () async {
          getDefault();
          if (dataLoaded) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          getMore();
          if (dataLoaded) {
            refreshController.loadComplete();
          } else {
            refreshController.loadFailed();
          }
        },
        child: dataLoaded
            ? ListView.separated(
                itemBuilder: (context, index) {
                  final data = _dataList![index];

                  return ListTile(
                    title: Text(data.firstName),
                    subtitle: Text(data.firstName),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: _dataList!.length,
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
