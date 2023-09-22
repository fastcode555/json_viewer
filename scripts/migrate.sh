#! /bin/bash
cd ..
#更新仓库
dart pub get
#升级 null-safety 仓库
dart pub upgrade --null-safety
#列表更新内容
dart pub outdated
#开始迁移代码
dart migrate --apply-changes
#跑一下看哪里出问题
flutter run