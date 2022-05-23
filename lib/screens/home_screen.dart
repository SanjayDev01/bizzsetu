import 'package:bizzsetu/model/getdata_model.dart';
import 'package:bizzsetu/services/http_service.dart';
import 'package:flutter/cupertino.dart';
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
          footer: CustomFooter(
            builder: (context, mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = const Text("pull up load");
              } else if (mode == LoadStatus.loading) {
                body = const CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = const Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = const Text("release to load more");
              } else if (mode == LoadStatus.noMore) {
                body = const Text("Thats all the data!");
              } else {
                body = const Text("Thats all the data!");
              }
              return SizedBox(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
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

                    return Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 170,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18.0,
                              right: 18.0,
                            ),
                            child: Image.network(data.avatar,
                                width: 140, height: 140, fit: BoxFit.cover),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text(data.firstName,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              Text(data.lastName,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              Text(data.email,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ))
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _dataList!.length,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
