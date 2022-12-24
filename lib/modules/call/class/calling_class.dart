import 'package:get/get.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

import '../controller/call_controller.dart';

class CallingClass {
  final CallController _callController = Get.find();
  joinMeeting(
      {required String userName,
      required String userUrl,
      required String roomText,
      required serverText,
      bool isReceiver = false,
      required bool isAudioCall}) async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    Map<FeatureFlag, Object> featureFlags = {
      FeatureFlag.isChatEnabled: false,
      FeatureFlag.isInviteEnabled: false,
      FeatureFlag.isPipEnabled: false,
      FeatureFlag.isToolboxEnabled: false,
      FeatureFlag.isOverflowMenuEnabled: false,
      FeatureFlag.isMeetingNameEnabled: false,
      FeatureFlag.isConferenceTimerEnabled: false,
      FeatureFlag.isVideoMuteButtonEnabled: isAudioCall ? false : true,
    };
    print("serverUrl===$serverUrl");

    var optionsSender = JitsiMeetingOptions(
      roomNameOrUrl: roomText,
      serverUrl: serverUrl,
      isAudioMuted: false,
      isAudioOnly: isAudioCall ? true : false,
      isVideoMuted: false,
      userAvatarUrl: userUrl,
      userDisplayName: userName,
      featureFlags: featureFlags,
    );
    // var optionReceiver = JitsiMeetingOptions(
    //   roomNameOrUrl: roomText,
    //   serverUrl: serverUrl,
    //   isAudioMuted: false,
    //   isAudioOnly: isAudioCall ? true : false,
    //   isVideoMuted: false,
    //   userAvatarUrl: userUrl,
    //   userDisplayName: userName,
    //   featureFlags: featureFlags,
    // );
    // isReceiver
    //     ? await JitsiMeetWrapper.joinMeeting(
    //         options: optionsSender,
    //         listener: JitsiMeetingListener(
    //             onOpened: () {
    //               print('open call by receiver');
    //             },
    //             onConferenceWillJoin: (url) {},
    //             onConferenceJoined: (url) {
    //               print("onConferenceJoined");
    //             },
    //             onConferenceTerminated: (url, error) {
    //               print("onConferenceTerminated");
    //             },
    //             // onAudioMutedChanged: (isMuted) {},
    //             // onVideoMutedChanged: (isMuted) {},
    //             // onScreenShareToggled: (participantId, isSharing) {},
    //             // onParticipantJoined: (email, name, role, participantId) {},
    //             // onParticipantLeft: (participantId) {},
    //             // onParticipantsInfoRetrieved: (participantsInfo, requestId) {},
    //             // onChatMessageReceived: (senderId, message, isPrivate) {},
    //             //  onChatToggled: (isOpen) {},
    //             onClosed: () {
    //               print("call is closed by receiver");
    //             }),
    //       ):
    await JitsiMeetWrapper.joinMeeting(
      options: optionsSender,
      listener: JitsiMeetingListener(
          onOpened: () {
            print('open call by sender');
          },
          onConferenceWillJoin: (url) {},
          onConferenceJoined: (url) {
            print("onConferenceJoined");
          },
          onConferenceTerminated: (url, error) {
            print("onConferenceTerminated");
          },
          // onAudioMutedChanged: (isMuted) {},
          // onVideoMutedChanged: (isMuted) {},
          // onScreenShareToggled: (participantId, isSharing) {},
          onParticipantJoined: (email, name, role, participantId) {
            print("onParticipantJoined");
            print("call room id is===${_callController.callRoom?.callingId}");
            _callController.onReceivedCall();
          },
          // onParticipantLeft: (participantId) {},
          //onParticipantsInfoRetrieved: (participantsInfo, requestId) {},
          // onChatMessageReceived: (senderId, message, isPrivate) {},
          //  onChatToggled: (isOpen) {},
          onClosed: () {
            print("call close by sender");
          }),
    );
  }
}
