import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessageNotifier extends StateNotifier<Map<String, dynamic>> {
  ChatMessageNotifier() : super({});

  // {
  //   room : [[user1, msg1], [user2, msg2]];
  //   room2 : []
  // }

  void deleteRoom(String roomId) {
    var temp = state;
    temp.removeWhere((key, value) => key == roomId);
    state = {...temp, roomId: []};
  }

  void addRoom(String roomId) {
    if (state.containsKey(roomId) == false) {
      state = {...state, roomId: []};
    }
  }

  void addMessage(List<String> data) {
    final room = data[0];
    final user = data[1];
    final msg = data[2];

    if (state.containsKey(room)) {
      state = {
        ...state,
        room: [
          ...state[room],
          [user, msg]
        ]
      };
    } else {
      state = {
        ...state,
        room: [
          [user, msg]
        ]
      };
    }
  }
}

final chatMessageProvider =
    StateNotifierProvider<ChatMessageNotifier, Map<String, dynamic>>(
        (ref) => ChatMessageNotifier());
