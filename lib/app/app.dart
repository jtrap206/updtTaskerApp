import 'package:tasker/service/task_service.dart';
import 'package:tasker/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:tasker/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:tasker/ui/views/home/home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tasker/ui/views/create_task_view/create_task_view_view.dart';
import 'package:tasker/ui/views/task_summary/task_summary_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: CreateTaskViewView),
    MaterialRoute(page: TaskSummaryView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: TaskService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
