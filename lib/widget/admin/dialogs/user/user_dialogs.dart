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
  bool _isPasswordObscured = true; // ← State untuk toggle mata password

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
              // Password Field dengan Obscure Text & Icon Mata
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                hint: 'Masukkan password akun',
                obscureText: _isPasswordObscured, // ← Diaktifkan di sini
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomDropdownMenu(
                controller: _roleController,
                label: 'Pilih Role / Hak Akses',
                icon: Icons.admin_panel_settings_outlined,
                items: const ['ADMIN', 'KASIR', 'BAKERY'],
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

    // Pastikan role dikonversi ke UpperCase agar cocok dengan item di CustomDropdownMenu
    String initialRole = (widget.currentUserData['role'] ?? 'KASIR')
        .toString()
        .toUpperCase();
    _roleController.text = ['ADMIN', 'KASIR', 'BAKERY'].contains(initialRole)
        ? initialRole
        : 'KASIR';
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
                items: const [
                  'ADMIN',
                  'KASIR',
                  'BAKERY',
                ], // Menggunakan BAKERY menggantikan OWNER
              ),
              const SizedBox(height: 28),

              DialogActionButtons(
                saveLabel: 'Simpan',
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  if (_nameController.text.trim().isNotEmpty &&
                      _emailController.text.trim().isNotEmpty &&
                      _roleController.text.isNotEmpty) {
                    // Kirim data ke controller
                    widget.onSave(
                      _userId,
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _roleController.text
                          .toUpperCase(), // Memastikan huruf kapital
                    );
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
  bool _obscurePassword = true; // ← State penutup password baru
  bool _obscureConfirm = true; // ← State penutup konfirmasi password

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
                'Buat password baru untuk akun "${widget.userName}". Password lama akan langsung ditimpa.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _passwordController,
                label: 'Password Baru',
                icon: Icons.lock_outline_rounded,
                hint: 'Minimal 6 karakter',
                obscureText: _obscurePassword, // ← Diaktifkan di sini
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _confirmController,
                label: 'Konfirmasi Password',
                icon: Icons.lock_outline_rounded,
                hint: 'Ulangi password baru',
                obscureText: _obscureConfirm, // ← Diaktifkan di sini
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() => _obscureConfirm = !_obscureConfirm);
                  },
                ),
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
