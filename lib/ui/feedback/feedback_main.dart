import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/models/feedback_model.dart';

import '../../providers/feedback_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  FeedbackScreenState createState() => FeedbackScreenState();
}

class FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  late FeedBackModel _feedback;
  bool _isSaving = false;
  bool _isCompleted = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _feedback = FeedBackModel(
      id: '',
      email: '',
      message: '',
      createdAt: now,
      updatedAt: now,
      uid: '',
    );
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref
        .read(feedBackProvider.notifier)
        .createFeedBack(_feedback)
        .then((value) {
      setState(() {
        _isSaving = false;
        _isCompleted = true;
      });
      //Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help us grow!'),
        actions: [
          _isCompleted
              ? const SizedBox.shrink()
              : TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _save();
                    }
                  },
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('SEND'),
                ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (_isCompleted) {
          return const Center(
            child: Text(
              'Thank You for Your Feedback!',
              style: TextStyle(fontSize: 20),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: sizes.largeScreenSize,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Thank you for using our app! As a budding application, we're in our early stages of development. We genuinely apologize if you encounter any hiccups or inconveniences. Your insights and feedback are incredibly valuable to us.",
                          //style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "By sharing your thoughts, you can play a crucial role in shaping our app's future. Whether it's something you'd like to see improved or a fresh idea you think would make a difference, we're all ears.",
                          //style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'email',
                          decoration: const InputDecoration(
                            labelText: 'You may leave your email',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _feedback.email = value!;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'message',
                          decoration: const InputDecoration(
                            labelText: 'Message*',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _feedback.message = value!;
                            });
                          },
                          minLines: 3,
                          maxLines: 8,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.min(4),
                            FormBuilderValidators.max(200),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
