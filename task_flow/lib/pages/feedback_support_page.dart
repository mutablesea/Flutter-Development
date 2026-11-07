import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackSupportPage extends StatefulWidget {
  const FeedbackSupportPage({super.key});

  static const String demoSupportEmail = 'mutant@gmail.com';

  @override
  State<FeedbackSupportPage> createState() => _FeedbackSupportPageState();
}

class _FeedbackSupportPageState extends State<FeedbackSupportPage> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'Feature Request';
  int _rating = 5;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _copyDemoEmail() {
    Clipboard.setData(
      const ClipboardData(text: FeedbackSupportPage.demoSupportEmail),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied mutant@gmail.com to clipboard!'),
      ),
    );
  }

  void _handleSendDemoMail() {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    if (subject.isEmpty && message.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Demo Mode: Mail client for mutant@gmail.com is simulated only.',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.mark_email_read_rounded,
          size: 40,
          color: Colors.deepPurple,
        ),
        title: const Text('Demo Feedback Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To: mutant@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Category: $_selectedCategory (Rating: $_rating/5)'),
            if (subject.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Subject: $subject'),
            ],
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Note: mutant@gmail.com is a demo email address, so no real email is dispatched right now.',
                style: TextStyle(fontSize: 12.5),
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _subjectController.clear();
              _messageController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Demo feedback recorded for mutant@gmail.com!',
                  ),
                ),
              );
            },
            child: const Text('OK, Got It'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Prominent Demo Support Email Card (mutant@gmail.com)
          Card(
            elevation: 2,
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(
                          Icons.mail_outline_rounded,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Send Feedback via Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Want to send feedback? Mail us at:',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.alternate_email_rounded,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const SelectableText(
                              FeedbackSupportPage.demoSupportEmail,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: _copyDemoEmail,
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text('Copy'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '* Demo email address (mutant@gmail.com) — email sending is simulated in preview mode.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Feedback Form Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Compose Feedback to mutant@gmail.com',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Rating stars
                  const Text(
                    'How would you rate Task Flow?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(5, (index) {
                      final starNum = index + 1;
                      return IconButton(
                        onPressed: () => setState(() => _rating = starNum),
                        icon: Icon(
                          starNum <= _rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: Colors.amber.shade700,
                          size: 30,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    'Feedback Category',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      'Feature Request',
                      'Bug Report',
                      'UI / Design',
                      'Other',
                    ].map((cat) {
                      return ChoiceChip(
                        label: Text(cat),
                        selected: _selectedCategory == cat,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = cat);
                          }
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 14),
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      hintText: 'Brief summary of your feedback',
                      prefixIcon: Icon(Icons.subject_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Your Message for mutant@gmail.com',
                      hintText:
                          'Write your suggestion, question, or bug details...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _handleSendDemoMail,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Mail Feedback to mutant@gmail.com'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Support FAQ Section
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Card(
            child: Column(
              children: [
                ExpansionTile(
                  leading: Icon(Icons.help_outline_rounded),
                  title: Text('How do I restore a deleted task?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Text(
                        'Open the Navigation Drawer and go to "Trash Bin". From there you can restore individual tasks or tap "Restore All".',
                      ),
                    ),
                  ],
                ),
                Divider(height: 1),
                ExpansionTile(
                  leading: Icon(Icons.family_restroom_rounded),
                  title: Text('How do I activate a Family collaborator?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Text(
                        'Go to "Family & Collaborators", enter their email in the Family activation box, and tap "Activate by Email".',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

