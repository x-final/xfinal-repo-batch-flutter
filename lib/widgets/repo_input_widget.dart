import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:repo_batch/cubit/menu_cubit.dart';
import 'package:repo_batch/cubit/repo_data_cubit.dart';
import 'package:repo_batch/model/repo.dart';

import 'common_button.dart';

class RepoInputWidget extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _workspaceInputController = TextEditingController();
  final TextEditingController _repoInputController = TextEditingController();

  RepoInputWidget({Key? key}) : super(key: key);

  void _readRepoListContentFromFile(BuildContext context) async {

    String workspace = await RepoDataCubit.getRepoDataCubit(context).readWorkspaceFromFile();
    if (workspace.isNotEmpty) {
      _workspaceInputController.value = TextEditingValue(
        text: workspace,
      );
    }

    String repos = await RepoDataCubit.getRepoDataCubit(context).readRepoListContentFromFile();
    if (repos.isNotEmpty) {
      _repoInputController.value = TextEditingValue(
        text: repos,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _readRepoListContentFromFile(context));
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 30, left: 18, right: 18),
              child: TextFormField(
                controller: _workspaceInputController,
                decoration: const InputDecoration(
                  hintText: '输入本地工作空间路径',
                  hintStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white38,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38, width: 1),
                  ),
                ),
                cursorColor: Colors.white,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, left: 18, right: 18),
              child: TextFormField(
                controller: _repoInputController,
                decoration: const InputDecoration(
                  hintText: '输入仓库地址，多仓库分行即可',
                  hintStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white38,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38, width: 1),
                  ),
                ),
                cursorColor: Colors.white,
                maxLines: 16,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '仅支持 ssh 和 https 格式的 git 仓库链接，其他非法内容会被过滤掉',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: CommonTextButton(
                text: '确定',
                onPressed: () {
                  String path = _workspaceInputController.text.trim();
                  RepoDataCubit.getRepoDataCubit(context).writeWorkspaceToFile(path);
                  String content = _repoInputController.text.trim();
                  RepoDataCubit.getRepoDataCubit(context).writeRepoListToFile(content);
                  if (content.isEmpty) {
                    EasyLoading.showToast('清除成功', dismissOnTap: true);
                  } else {
                    MenuCubit.getMenuCubit(context).toggleToRepo();
                    EasyLoading.showToast('添加成功', dismissOnTap: true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
