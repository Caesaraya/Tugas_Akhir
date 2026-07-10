import 'package:flutter/material.dart';
import 'package:tugas_akhir/widget/admin/dialogs/custom_form_fields.dart';

/// ==========================================
/// 1. DIALOG TAMBAH USER BARU (INSERT)
/// ==========================================
class InsertUserDialog extends StatefulWidget {
  final Function(String name, String email, String role, String password)
  onSave;

  const InsertUserDialog({super.key, required this.onSave});

  @override
  State<InsertUserDialog> createState() => _InsertUserDialogState();
}

class _InsertUserDialogState extends State<InsertUserDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DialogCommonTitle(
                title: 'Tambah User Baru',
                icon: Icons.person_add_alt_1_rounded,
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                icon: Icons.badge_outlined,
                hint: 'Masukkan nama lengkap',
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                hint: 'contoh@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                hint: 'Masukkan password akun',
              ),
              const SizedBox(height: 20),

              CustomDropdownMenu(
                controller: _roleController,
                label: 'Pilih Role / Hak Akses',
                icon: Icons.admin_panel_settings_outlined,
                items: const ['ADMIN', 'KASIR', 'OWNER'],
              ),
              const SizedBox(height: 28),

              DialogActionButtons(
                saveLabel: 'Tambah',
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  if (_nameController.text.trim().isNotEmpty &&
                      _emailController.text.trim().isNotEmpty &&
                      _passwordController.text.trim().isNotEmpty &&
                      _roleController.text.isNotEmpty) {
                    widget.onSave(
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _roleController.text.toUpperCase(),
                      _passwordController.text.trim(),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ==========================================
/// 2. DIALOG UBAH DATA USER (EDIT)
/// ==========================================
/// Edit Informasi User (nama, email, role SAJA).
/// Dialog ini TIDAK PERNAH menampilkan atau meminta password lama,
/// dan tidak memiliki field password sama sekali.
class EditUserDialog extends StatefulWidget {
  final Map<String, dynamic> currentUserData;
  final Function(int id, String name, String email, String role) onSave;

  const EditUserDialog({
    super.key,
    required this.currentUserData,
    required this.onSave,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late int _userId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userId = widget.currentUserData['id'] ?? 0;
    _nameController.text = widget.currentUserData['name'] ?? '';
    _emailController.text = widget.currentUserData['email'] ?? '';
    _roleController.text = widget.currentUserData['role'] ?? 'KASIR';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DialogCommonTitle(
                title: 'Ubah Informasi User',
                icon: Icons.manage_accounts_rounded,
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                icon: Icons.badge_outlined,
                hint: 'Masukkan nama lengkap',
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                hint: 'contoh@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              CustomDropdownMenu(
                controller: _roleController,
                label: 'Ubah Role / Hak Akses',
                icon: Icons.admin_panel_settings_outlined,
                items: const ['ADMIN', 'KASIR', 'OWNER'],
              ),
              const SizedBox(height: 28),

              DialogActionButtons(
                saveLabel: 'Simpan',
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  if (_nameController.text.trim().isNotEmpty &&
                      _emailController.text.trim().isNotEmpty &&
                      _roleController.text.isNotEmpty) {
                    widget.onSave(
                      _userId,
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _roleController.text.toUpperCase(),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ==========================================
/// 3. DIALOG RESET PASSWORD
/// ==========================================
/// Alur khusus Admin (mis. staf lupa password):
/// - Hanya meminta Password Baru + Konfirmasi Password.
/// - TIDAK PERNAH meminta atau menampilkan password lama.
/// - Password lama langsung ditimpa oleh backend (hashing di backend).
class ResetPasswordDialog extends StatefulWidget {
  final int userId;
  final String userName;
  final Function(int id, String newPassword) onSave;

  const ResetPasswordDialog({
    super.key,
    required this.userId,
    required this.userName,
    required this.onSave,
  });

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty) {
      setState(() => _errorText = 'Password baru wajib diisi');
      return;
    }
    if (confirm.isEmpty) {
      setState(() => _errorText = 'Konfirmasi password wajib diisi');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorText = 'Password minimal 6 karakter');
      return;
    }
    if (password != confirm) {
      setState(() => _errorText = 'Password dan konfirmasi tidak sama');
      return;
    }

    setState(() => _errorText = null);
    widget.onSave(widget.userId, password);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DialogCommonTitle(
                title: 'Reset Password',
                icon: Icons.lock_reset_rounded,
              ),
              const SizedBox(height: 8),
              Text(
                'Buat password baru untuk akun "${widget.userName}". '
                'Password lama akan langsung ditimpa.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: _passwordController,
                label: 'Password Baru',
                icon: Icons.lock_outline_rounded,
                hint: 'Minimal 6 karakter',
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _confirmController,
                label: 'Konfirmasi Password',
                icon: Icons.lock_outline_rounded,
                hint: 'Ulangi password baru',
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],

              const SizedBox(height: 28),

              DialogActionButtons(
                saveLabel: 'Reset',
                onCancel: () => Navigator.pop(context),
                onSave: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
