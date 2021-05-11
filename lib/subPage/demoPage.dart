import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/postListItem.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('\"新冠病毒\" 的搜索结果'),
            bottom: TabBar(
              tabs: [Tab(text: '帖子',), Tab(text: '用户',)],
            ),
          ),
          body: TabBarView(children: [
            Column(
              children: [
                PostListItem(
                  imgAuthor: 'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/NEKjKGwEGEXb.gif',
                    titleText: '世卫组织将中国国药新冠疫苗列入“紧急使用清单”，外交部回应',
                    contentText:
                        '【环球时报-环球网报道 记者 乌元春】在5月10日举行的中国外交部例行记者会上，有记者提问：日前世卫组织总干事谭德塞宣布将中国国药的新冠疫苗列入了“紧急使用清单”，它也成为了清单内的首支非西方疫苗，......',
                    authorName: 'レエイン',
                    isAuthor: true,
                    tags: ['新冠病毒'],
                    time: DateTime.parse('2021-05-10 19:02:15.627Z').toString(),
                    editorID: 10000001),
                PostListItem(
                    imgAuthor: 'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/NEKjKGwEGEXb.gif',
                    titleText: '印度死亡病例可能将超百万？《柳叶刀》：印政府要为国家灾难负责',
                    contentText:
                    '【环球时报 记者 胡博峰】截至9日，印度连续两天新冠肺炎单日死亡病例超过4000例，连续4天单日新增确诊病例超过40万例。印度目前已有24万人死于新冠肺炎。有研究机构预测称，到了8月1日，这一数字可能......',
                    authorName: 'レエイン',
                    isAuthor: true,
                    tags: ['新冠病毒'],
                    time: DateTime.parse('2021-05-10 19:02:15.627Z').toString(),
                    editorID: 10000001)
              ],
            ),
            Column(
              children: [],
            )
          ]),
        ));
  }
}
