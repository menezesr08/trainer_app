import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trainer_app/features/chat/data/chat_provider.dart';
import 'package:trainer_app/features/chat/model/model.dart';
import 'package:trainer_app/features/chat/presentation/chat_widgets/youtube_video.dart';
import 'package:trainer_app/features/chat/presentation/question_builders.dart';
import 'package:trainer_app/features/plans/domain/chat_flows_manager.dart';
import 'package:trainer_app/features/plans/domain/flow.dart';
import 'package:trainer_app/features/user/data/user_repository.dart';

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
  late ChatNotifier? chatNotifier;
  late ChatState? chatState;
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      chatNotifier = ref.read(chatProvider.notifier);
      chatState = ref.watch(chatProvider);
      userName =
          await ref.read(getUserProvider.future).then((user) => user!.name);

      _questionBuilders = QuestionBuilders(ref, _chatFlowsManager, _openAI,
          ratingsLabel, _standardCHATGPTResponse);
      _initializeChatFlowManager();
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

      chatNotifier?.addMessage(message);
      chatNotifier?.setLoading(false);
    }
  }

  Future<void> _standardCHATGPTResponse(String text) async {
    final request = ChatCompleteText(
      messages: [Messages(role: Role.user, content: text)],
      maxToken: 200,
      model:
          ChatModelFromValue(model: 'ft:gpt-3.5-turbo-0613:personal::9KMlAHyw'),
    );
    chatNotifier?.setLoading(true);
    final response = await _openAI.onChatCompletion(request: request);

    ChatMessage message = ChatMessage(
      text: response!.choices.first.message!.content.trim(),
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    chatNotifier?.setLoading(false);

    chatNotifier?.addMessage(message);
  }

  Future<void> _handleSubmit(String text) async {
    _textController.clear();

    ChatMessage prompt = ChatMessage(
      text: text,
      isSentByMe: true,
      timestamp: DateTime.now(),
    );
    chatNotifier?.addMessage(prompt);

    if (_chatFlowsManager.currentFlow.name != 'standard') {
      _questionBuilders.askCheckInQuestion();
    } else {
      _standardCHATGPTResponse(text);
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
          return _buildChatBubble(message, index);
        },
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, int index) {
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
                color: isSentByMe
                    ? Colors.white
                    : index == 0
                        ? Colors.black
                        : Colors.black.withOpacity(0.1),
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
    chatNotifier = ref.read(chatProvider.notifier);
    chatState = ref.watch(chatProvider);
    return WillPopScope(
      onWillPop: () async {
        chatNotifier?.printState();
        await chatNotifier?.clearState();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Ask me something'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildChatList(),
                  if (chatState?.isLoading ?? false)
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 50,
                    ),
                  if (chatState?.enableNextButton ?? false)
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, // Text color
                          backgroundColor:
                              Colors.black, // Button background color
                          side: BorderSide(
                              color: Colors.white,
                              width: 2), // Border color and width
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12), // Button padding
                        ),
                        onPressed: () {
                          // Define the action on button press here
                          chatNotifier?.setEnableNextButton(false);
                          _questionBuilders.askCheckInQuestion();
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 16), // Text style
                        ),
                      ),
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
