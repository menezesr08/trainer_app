import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trainer_app/features/chat/model/model.dart';
import 'package:trainer_app/features/chat/presentation/ratings_bar.dart';
import 'package:trainer_app/features/chat/presentation/selectable_options.dart';
import 'package:trainer_app/features/plans/domain/check_in_manager.dart';
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
  late bool _isLoading;
  final TextEditingController _textController = TextEditingController();
  late List<ChatMessage> _messages;
  late CheckInManager _checkInManager;
  late String userName;
  final ratingsLabel = ['Very Poor', 'Poor', 'Average', 'Good', 'Excellent'];

  @override
  void initState() {
    _messages = [];
    _isLoading = false;

    _openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_API_KEY'],
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _checkInManager = CheckInManager(flows: {
      'standard': CheckInFlow(name: 'standard', questions: []),
      'check_in': CheckInFlow(name: 'check_in', questions: [
        _buildQuestion(
          "How were your workouts this week?",
          RatingBar(
            ratingLabels: ratingsLabel,
            onRatingChanged: (v) {
              if (v - 1 < 2) {
                _checkInManager.addQuestion(
                  'What do you think is the main reason for this?',
                  SelectableOptions(
                    options: [
                      SelectableOption(
                          label: 'Lack of Sleep', value: 'lack_of_sleep'),
                      SelectableOption(
                          label: 'Poor Nutrition', value: 'poor_nutrition'),
                      SelectableOption(
                          label: 'No Warm-Up', value: 'no_warm_up'),
                      SelectableOption(
                          label: 'Mental Stress', value: 'mental_stress'),
                      SelectableOption(
                          label: 'Overtraining', value: 'overtraining'),
                    ],
                    selectedOption: null,
                    onOptionSelected: (value) async {
                      await standardCHATGPTResponse(
                          'Give me 3 solutions for $value');
                      _askCheckInQuestion();
                    },
                  ),
                );
              }

              _askCheckInQuestion();
            },
          ),
        ),
        _buildQuestion("How are you sleeping?", Text('hi')),
        _buildQuestion("How is your diet?", Text('test')),
      ]),
    });

    _checkInManager.startFlow(widget.flowString);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userName =
          await ref.read(getUserProvider.future).then((user) => user!.name);
      _handleInitialMessage();
    });

    super.initState();
  }

  Future<void> _handleInitialMessage() async {
    setState(() {
      _isLoading = true;
    });

    // Simulated initial message
    ChatMessage message = ChatMessage(
      text: "Hi, I'm your assistant. How can I help you today?",
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, message);
      _isLoading = false;
    });

    if (_checkInManager.currentFlow.name != 'standard') {
      _askCheckInQuestion();
    }
  }

  void _askCheckInQuestion() {
    if (_checkInManager.currentFlow.questions.isNotEmpty) {
      var nextQuestion = _checkInManager.currentFlow.questions.removeAt(0);

      ChatMessage message = ChatMessage(
        text: nextQuestion['question'],
        isSentByMe: false,
        timestamp: DateTime.now(),
        item: nextQuestion['widget'],
      );

      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  Future<void> _handleSubmit(String text) async {
    _textController.clear();

    ChatMessage prompt = ChatMessage(
      text: text,
      isSentByMe: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, prompt);
    });

    if (_checkInManager.currentFlow.name != 'standard') {
      _askCheckInQuestion();
    } else {
      // Simulated ChatGPT response
      ChatMessage response = ChatMessage(
        text: "This is a response from ChatGPT.",
        isSentByMe: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.insert(0, response);
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _buildQuestion(String question, Widget widget) {
    return {
      'question': question,
      'widget': widget,
    };
  }

  Future<void> standardCHATGPTResponse(String text) async {
    final request = ChatCompleteText(
      messages: [Messages(role: Role.user, content: text)],
      maxToken: 200,
      model:
          ChatModelFromValue(model: 'ft:gpt-3.5-turbo-0613:personal::9KMlAHyw'),
    );

    setState(() {
      _isLoading = true;
    });

    final response = await _openAI.onChatCompletion(request: request);

    ChatMessage message = ChatMessage(
      text: response!.choices.first.message!.content.trim(),
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, message);
      _isLoading = false;
    });
  }

  Widget _buildChatList() {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        reverse: true,
        itemCount: _messages.length,
        itemBuilder: (_, int index) {
          ChatMessage message = _messages[index];
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
                enabled: !_isLoading,
              ),
              onSubmitted: _isLoading ? null : _handleSubmit,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isLoading
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Stack(
          children: [
            Column(
              children: [
                _buildChatList(),
                if (_isLoading)
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
