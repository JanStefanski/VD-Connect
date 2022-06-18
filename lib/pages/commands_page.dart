import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommandsPage extends StatefulWidget {
  const CommandsPage({Key? key}) : super(key: key);

  @override
  State<CommandsPage> createState() => _CommandsPageState();
}

class _CommandsPageState extends State<CommandsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context)!.commands_page_description),
    );
  }
}