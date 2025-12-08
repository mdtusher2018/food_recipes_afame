// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:food_recipes_afame/controller/compleate_question_controller.dart';
import 'package:food_recipes_afame/view/Subscription/subscription_view.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';

class CompleateQuestionnairePage extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> options;
  final int currentStep; // zero based index
  final int totalSteps;
  final Function(String selectedAnswer) onNext;

  const CompleateQuestionnairePage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
  });

  @override
  State<CompleateQuestionnairePage> createState() =>
      _CompleateQuestionnairePageState();
}

class _CompleateQuestionnairePageState
    extends State<CompleateQuestionnairePage> {
  int? selectedOptionIndex;

  @override
  Widget build(BuildContext context) {
    double progress = (widget.currentStep + 1) / widget.totalSteps;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: authAppBar(""),

      bottomSheet: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.grey.shade400,
              color: AppColors.primary,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            commonText(widget.title, size: 18, isBold: true),
            const SizedBox(height: 8),
            commonText(widget.subtitle, size: 14, color: Colors.black87),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final selected = index == selectedOptionIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOptionIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Card(
                        elevation: 2,
                        shadowColor: AppColors.primary,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color:
                                selected
                                    ? AppColors.primary.withOpacity(0.3)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary,

                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: commonText(
                                  widget.options[index],
                                  size: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Radio<int>(
                                value: index,
                                groupValue: selectedOptionIndex,
                                onChanged: (val) {
                                  setState(() {
                                    selectedOptionIndex = val;
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            commonButton(
              widget.currentStep == widget.totalSteps - 1
                  ? "Complete"
                  : "Continue",
              haveNextIcon: true,
              onTap:
                  selectedOptionIndex == null
                      ? () {
                        showCustomSnackbar("Empty", "Please sellect an option");
                      }
                      : () {
                        final selected = widget.options[selectedOptionIndex!];
                        widget.onNext(selected); // ✅ Pass selected value
                        setState(() {
                          selectedOptionIndex = null;
                        });
                      },
            ),
          ],
        ),
      ),
    );
  }
}

class CompleateQuestionnaireFlow extends StatefulWidget {
  bool fromSignup;
  CompleateQuestionnaireFlow({super.key, this.fromSignup = false});

  @override
  State<CompleateQuestionnaireFlow> createState() =>
      _CompleateQuestionnaireFlowState();
}

class _CompleateQuestionnaireFlowState
    extends State<CompleateQuestionnaireFlow> {
  int currentStep = 0;

  final questions = [
    {
      "title": "Where are your culinary roots from?",
      "subtitle": "Select the region that represents your cultural heritage.",
      "options": [
        "Africa",
        "North Africa",
        "Middle East",
        "Europe",
        "Asia",
        "Latin America",
        "Caribbean",
      ],
    },
    {
      "title": "What's your favorite dish?",
      "subtitle": "Pick the dish you enjoy the most.",
      "options": [
        "Mafé",
        "Poulet yassa",
        "Tajine",
        "Couscous",
        "Colombo de poulet",
        "Empanadas",
        "Autre",
      ],
    },
    {
      "title": "What's your goal with our app?",
      "subtitle": "Choose the main reason you want to use Roots & Recipes.",
      "options": [
        "Rediscover my culinary culture",
        "Learn how to cook new dishes",
        "Prepare menus for my family",
        "Cook more easily on a daily basis",
        "Eat healthier without losing my roots",
      ],
    },
    {
      "title": "How often do you cook?",
      "subtitle": "Select your cooking frequency.",
      "options": ["Every day", "A few times a week", "Occasionally"],
    },
  ];

  Map<String, String> answers = {};

  void nextStep(String selectedAnswer) async {
    // Store current answer
    switch (currentStep) {
      case 0:
        answers['cultureHeritage'] = selectedAnswer;
        break;
      case 1:
        answers['favoriteDish'] = selectedAnswer;
        break;
      case 2:
        answers['pageGoal'] = selectedAnswer;
        break;
      case 3:
        answers['cookingFrequency'] = selectedAnswer;
        break;
    }

    // Go to next step or call API
    if (currentStep < questions.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      // Final Step: Call API
      await Get.put(CompleteProfileController()).completeProfile(
        cultureHeritage: answers['cultureHeritage'] ?? '',
        favoriteDish: answers['favoriteDish'] ?? '',
        pageGoal: answers['pageGoal'] ?? '',
        cookingFrequency: answers['cookingFrequency'] ?? '',
      );

      if (widget.fromSignup) {
        navigateToPage(SubscriptionView(fromSignup: widget.fromSignup));
      } else {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentStep];
    q['subtitle'] ??= "Please select an option";
    return CompleateQuestionnairePage(
      title: q['title']!.toString(),
      subtitle: q['subtitle']!.toString(),
      options: List<String>.from(q['options']! as List),
      currentStep: currentStep,
      totalSteps: questions.length,
      onNext: (selectedAnswer) => nextStep(selectedAnswer),
    );
  }
}
