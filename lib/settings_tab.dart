import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/lang_bot_sheet.dart';
import 'package:todo_app/theme_bot_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.language,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.primaryColor)),
          child: InkWell(
            onTap: () {
              showLanguageBottomSheet();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.english,
                    style: Theme.of(context).textTheme.bodyMedium),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ),
        SizedBox(height: height * 0.03),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.mode,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.primaryColor)),
          child: InkWell(
            onTap: () {
              showThemeBottomSheet();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.light,
                    style: Theme.of(context).textTheme.bodyMedium),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => LangugeBottomSheet());
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => ThemeBottomSheet());
  }
}