import 'package:flutter/material.dart';

class FamilyCollaborator {
  final String id;
  String name;
  String username;
  String email;
  String relationOrRole; // e.g., 'Family Admin', 'Brother • Family', 'Sister • Family'
  bool isActive;
  int sharedTasks;

  FamilyCollaborator({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.relationOrRole,
    this.isActive = true,
    this.sharedTasks = 0,
  });
}

class CollaboratorsPage extends StatefulWidget {
  const CollaboratorsPage({super.key});

  @override
  State<CollaboratorsPage> createState() => _CollaboratorsPageState();
}

class _CollaboratorsPageState extends State<CollaboratorsPage> {
  final TextEditingController _emailActivateController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedRelation = 'Family Member';

  final List<FamilyCollaborator> _familyMembers = [
    FamilyCollaborator(
      id: 'f1',
      name: 'Mutant Freeman',
      username: 'mutant',
      email: 'mutant@gmail.com',
      relationOrRole: 'Family Admin (You)',
      isActive: true,
      sharedTasks: 6,
    ),
    FamilyCollaborator(
      id: 'f2',
      name: 'Neon Saab',
      username: 'neon',
      email: 'neon@gmail.com',
      relationOrRole: 'Family Member',
      isActive: true,
      sharedTasks: 4,
    ),
    FamilyCollaborator(
      id: 'f3',
      name: 'Arian Freeman',
      username: 'arian_f',
      email: 'arian.family@gmail.com',
      relationOrRole: 'Family • Sibling',
      isActive: false,
      sharedTasks: 2,
    ),
    FamilyCollaborator(
      id: 'f4',
      name: 'Zara Freeman',
      username: 'zara_f',
      email: 'zara.family@gmail.com',
      relationOrRole: 'Family • Parent',
      isActive: false,
      sharedTasks: 1,
    ),
  ];

  @override
  void dispose() {
    _emailActivateController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _activateOrAddByEmail() {
    final email = _emailActivateController.text.trim().toLowerCase();
    final customName = _nameController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address to activate.'),
        ),
      );
      return;
    }

    // Check if member already exists in Family list
    final existingIndex = _familyMembers.indexWhere(
      (m) => m.email.toLowerCase() == email,
    );

    if (existingIndex != -1) {
      setState(() {
        _familyMembers[existingIndex].isActive = true;
      });
      _emailActivateController.clear();
      _nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Activated ${_familyMembers[existingIndex].name} ($email) in Family Circle!',
          ),
        ),
      );
      return;
    }

    // Otherwise add and activate new family member with that email
    final derivedUsername = email.split('@').first;
    final displayName = customName.isNotEmpty
        ? customName
        : derivedUsername[0].toUpperCase() + derivedUsername.substring(1);

    setState(() {
      _familyMembers.add(
        FamilyCollaborator(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: displayName,
          username: derivedUsername,
          email: email,
          relationOrRole: _selectedRelation,
          isActive: true,
          sharedTasks: 1,
        ),
      );
    });

    _emailActivateController.clear();
    _nameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$displayName ($email) added & activated in Family Section!',
        ),
      ),
    );
  }

  void _showVerifyEmailDialog(FamilyCollaborator member) {
    final confirmEmailCtrl = TextEditingController(text: member.email);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Activate Family Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm email address to activate ${member.name} in your Family workspace:',
              style: const TextStyle(fontSize: 13.5),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Family Member Email',
                prefixIcon: Icon(Icons.mark_email_read_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              final entered = confirmEmailCtrl.text.trim();
              if (entered.isNotEmpty && entered.contains('@')) {
                setState(() {
                  member.email = entered;
                  member.isActive = true;
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${member.name} activated via ${member.email}!',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.verified_rounded, size: 18),
            label: const Text('Activate Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = _familyMembers.where((m) => m.isActive).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family & Collaborators'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Family Overview Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(
                    Icons.family_restroom_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Family Collaboration Hub',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$activeCount of ${_familyMembers.length} family members active via email',
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
          ),

          const SizedBox(height: 18),

          // Activate / Invite Family Member by Email Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Activate Family Member via Email',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enter a family member\'s email to activate their access or add them to your Family section.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _emailActivateController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Family Member Email',
                      hintText: 'e.g., neon@gmail.com or arian.family@gmail.com',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Name (Optional)',
                            hintText: 'e.g., Neon Saab',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.dividerColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedRelation,
                            items: const [
                              DropdownMenuItem(
                                value: 'Family Member',
                                child: Text('Family'),
                              ),
                              DropdownMenuItem(
                                value: 'Family • Sibling',
                                child: Text('Sibling'),
                              ),
                              DropdownMenuItem(
                                value: 'Family • Parent',
                                child: Text('Parent'),
                              ),
                              DropdownMenuItem(
                                value: 'Family • Partner',
                                child: Text('Partner'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedRelation = val);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton.icon(
                      onPressed: _activateOrAddByEmail,
                      icon: const Icon(Icons.verified_user_outlined, size: 18),
                      label: const Text('Activate by Email'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Family Section List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.groups_rounded, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Family Section',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '$activeCount Active',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Family Member Cards
          ..._familyMembers.map((member) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: member.isActive
                      ? Colors.green.withValues(alpha: 0.35)
                      : theme.dividerColor.withValues(alpha: 0.25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: member.isActive
                              ? Colors.green.withValues(alpha: 0.15)
                              : theme.colorScheme.surfaceContainerHighest,
                          child: Text(
                            member.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: member.isActive
                                  ? Colors.green.shade700
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      member.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: member.isActive
                                          ? Colors.green.withValues(alpha: 0.14)
                                          : Colors.orange
                                              .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      member.isActive ? 'Active' : 'Inactive',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: member.isActive
                                            ? Colors.green.shade700
                                            : Colors.orange.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${member.email} • @${member.username}',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${member.relationOrRole} • ${member.sharedTasks} shared tasks',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: member.isActive,
                          onChanged: (val) {
                            if (val && !member.isActive) {
                              _showVerifyEmailDialog(member);
                            } else {
                              setState(() => member.isActive = val);
                            }
                          },
                        ),
                      ],
                    ),
                    if (!member.isActive) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showVerifyEmailDialog(member),
                          icon: const Icon(
                            Icons.mark_email_read_outlined,
                            size: 17,
                          ),
                          label: Text('Activate via ${member.email}'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
