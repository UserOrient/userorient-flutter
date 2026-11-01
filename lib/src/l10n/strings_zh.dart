import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsZh extends UserOrientStrings {
  const StringsZh();

  @override
  String get tip => '为你期待的功能投票。';

  @override
  String get requestHint => '描述你的想法...';

  @override
  String get submit => '提交';

  @override
  String get inReview => '审核中';

  @override
  String get thanks => '谢谢！我们会尽快审核。';

  @override
  String get suggestFeature => '提交建议';

  @override
  String get roadmap => '路线图';

  @override
  String get shipped => '已实现';

  @override
  String get comments => '评论';

  @override
  String get noCommentsYet => '暂无评论';

  @override
  String get beFirstToComment => '成为第一个评论此功能的人';

  @override
  String get guest => '匿名';

  @override
  String get commentHint => '写下评论...';

  @override
  String get emailTitle => '电子邮箱';

  @override
  String get emailHint => '用于跟进的邮箱（选填）';

  @override
  String get send => '发送';

  @override
  String get skipAndSend => '跳过并发送';

  @override
  String get next => '下一步';

  @override
  String get invalidEmail => '请输入有效的邮箱';

  @override
  String get emailRequired => '邮箱为必填项';

  @override
  String get justNow => '刚刚';

  @override
  String get someTimeAgo => '一段时间前';

  @override
  String get minuteAgo => '1 分钟前';

  @override
  String minutesAgo(int n) => '$n 分钟前';

  @override
  String get hourAgo => '1 小时前';

  @override
  String hoursAgo(int n) => '$n 小时前';

  @override
  String get yesterday => '昨天';

  @override
  String daysAgo(int n) => '$n 天前';

  @override
  String get monthAgo => '1 个月前';

  @override
  String monthsAgo(int n) => '$n 个月前';

  @override
  String get yearAgo => '1 年前';

  @override
  String yearsAgo(int n) => '$n 年前';

  @override
  String get close => '关闭';

  @override
  String get vote => '投票';
}
