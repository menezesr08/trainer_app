import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trainer_app/features/chat/model/model.dart';
import 'package:trainer_app/features/chat/presentation/question_builders.dart';

import 'package:trainer_app/features/chat/providers.dart';
import 'package:trainer_app/features/plans/domain/chat_flows_manager.dart';
import 'package:trainer_app/features/plans/domain/flow.dart';
import 'package:trainer_app/features/user/data/user_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({
    super.key,
    required this.flowString,
  });

  final String flowString;

  @override
  ConsumerState<ChatPage> createState() => _ConsumerChatPageState();
}

class _ConsumerChatPageState extends ConsumerState<ChatPage> {
  late final OpenAI _openAI;

  final TextEditingController _textController = TextEditingController();
  late ChatFlowsManager _chatFlowsManager;
  late QuestionBuilders _questionBuilders;
  late String userName;
  final ratingsLabel = ['Very Poor', 'Poor', 'Average', 'Good', 'Excellent'];

  @override
  void initState() {
    super.initState();

    _openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_API_KEY'],
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _chatFlowsManager = ChatFlowsManager(flows: {
      'standard': ChatFlow(name: 'standard', questions: []),
      'check_in': ChatFlow(name: 'check_in', questions: []),
    });

    _questionBuilders = QuestionBuilders(
      ref,
      _chatFlowsManager,
      _openAI,
      ratingsLabel,
    );

    _initializeChatFlowManager();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
      ref.read(chatProvider.notifier).printState();
      userName =
          await ref.read(getUserProvider.future).then((user) => user!.name);
      _handleInitialMessage();
    });
  }

  void _initializeChatFlowManager() {
    _chatFlowsManager.flows['check_in']?.questions = [
      _questionBuilders.buildWorkoutQuestion(),
      _questionBuilders.buildSleepQuestion(),
      _questionBuilders.buildDietQuestion(),
    ];

    _chatFlowsManager.startFlow(widget.flowString);
  }

  Future<void> _handleInitialMessage() async {
    if (_chatFlowsManager.currentFlow.name != 'standard') {
      _questionBuilders.askCheckInQuestion();
    } else {
      // Simulated initial message
      ChatMessage message = ChatMessage(
        text: "Hi, I'm your assistant. How can I help you today?",
        isSentByMe: false,
        timestamp: DateTime.now(),
      );


      ref.read(chatProvider.notifier).addMessage(message);
      ref.read(chatProvider.notifier).setLoading(false);
    }
  }

  Future<void> _handleSubmit(String text) async {
    _textController.clear();

    ChatMessage prompt = ChatMessage(
      text: text,
      isSentByMe: true,
      timestamp: DateTime.now(),
    );
    ref.read(chatProvider.notifier).addMessage(prompt);

    if (_chatFlowsManager.currentFlow.name != 'standard') {
      _questionBuilders.askCheckInQuestion();
    } else {
      // Simulated ChatGPT response
      ChatMessage response = ChatMessage(
        text: "This is a response from ChatGPT.",
        isSentByMe: false,
        timestamp: DateTime.now(),
      );

      ref.read(chatProvider.notifier).addMessage(response);
      ref.read(chatProvider.notifier).setLoading(false);
    }
  }

  Widget _buildChatList() {
    final messages = ref.watch(chatProvider).messages;
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (_, int index) {
          ChatMessage message = messages[index];
          return _buildChatBubble(message);
        },
      ),
    );
  }

  Widget _buildChatBubble(
    ChatMessage message,
  ) {
    final isSentByMe = message.isSentByMe;
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    final List<String> words = message.text.split(' ');
    bool showVideo = false;

    for (var word in words) {
      if (word.startsWith('https://www.youtube.com/watch?v=')) {
        showVideo = true;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              margin: isSentByMe
                  ? const EdgeInsets.only(left: 100)
                  : const EdgeInsets.only(right: 100),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.white : Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12.0),
                  topRight: const Radius.circular(12.0),
                  bottomLeft: isSentByMe
                      ? const Radius.circular(12.0)
                      : const Radius.circular(0.0),
                  bottomRight: isSentByMe
                      ? const Radius.circular(0.0)
                      : const Radius.circular(12.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSentByMe ? userName : 'Charlie',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSentByMe ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  showVideo
                      ? YouTubeTextWithThumbnails(
                          text: message.text,
                        )
                      : Text(
                          message.text,
                          style: TextStyle(
                            color: isSentByMe ? Colors.black : Colors.white,
                            fontSize: 12,
                          ),
                        ),
                  const SizedBox(height: 12),
                  if (message.item != null) message.item!,
                  const SizedBox(height: 12),
                  Text(
                    '${dateFormat.format(message.timestamp)} at ${timeFormat.format(message.timestamp)}',
                    style: TextStyle(
                      color: isSentByMe ? Colors.black : Colors.white,
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatComposer() {
    bool isLoading = ref.watch(chatProvider).isLoading;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message',
                enabled: !isLoading,
              ),
              onSubmitted: isLoading ? null : _handleSubmit,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isLoading
                ? null
                : () => _handleSubmit(
                      _textController.text,
                    ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ref.read(chatProvider.notifier).printState();
        ref.read(chatProvider.notifier).clearState();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Time to Check in!'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildChatList(),
                  if (ref.watch(chatProvider).isLoading)
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 50,
                    ),
                  const Divider(height: 1.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _buildChatComposer(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YouTubeTextWithThumbnails extends StatelessWidget {
  final String text;

  const YouTubeTextWithThumbnails({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> words = text.split(' ');
    final List<Widget> widgets = [];

    for (var word in words) {
      if (word.startsWith('https://www.youtube.com/watch?v=')) {
        final videoId =
            word.substring('https://www.youtube.com/watch?v='.length);

        YoutubePlayerController controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: true,
          ),
        );
        widgets.add(
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
        );
      } else {
        widgets.add(Text(word));
      }
      widgets.add(SizedBox(width: 2)); // Add space between widgets
    }

    return Wrap(children: widgets);
  }
}
