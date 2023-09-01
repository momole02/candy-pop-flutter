import 'package:candy_pop_flutter/gameplay/action_pattern.dart';

class CallbackAction extends Action {
  Function(Map<String, dynamic>) callback;
  CallbackAction(this.callback);
  @override
  void perform(List<Action> actionQueue, Map<String, dynamic> globals) {
    callback(globals);
    terminate();
  }
}
