// providers/recording_states_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recording_state_provider.g.dart';

@riverpod
class RecordingState extends _$RecordingState {
  @override
  bool build() => false;

  void startRecording() {
    state = true;
  }

  void stopRecording() {
    state = false;
  }

  void toggleRecording() {
    state = !state;
  }
}