import 'package:flutter/material.dart';
import '../services/safe_vault.dart';
import '../models/media_item.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});
  @override State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  List<MediaItem> _items = [];
  final _vault = SafeVault();

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final items = await _vault.getVaultContents();
    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safe-Vault'), backgroundColor: const Color(0xFF0A0A0F)),
      body: _items.isEmpty
        ? const Center(child: Text('Vault is empty — all clear!', style: TextStyle(color: Colors.white70)))
        : ListView.builder(
            itemCount: _items.length,
            itemBuilder: (ctx, i) {
              final item = _items[i];
              final daysLeft = item.permanentDeleteAt?.difference(DateTime.now()).inDays ?? 0;
              return ListTile(
                title: Text(item.type, style: const TextStyle(color: Colors.white)),
                subtitle: Text('$daysLeft days until permanent delete', style: const TextStyle(color: Colors.white60)),
                trailing: TextButton(
                  onPressed: () async { await _vault.restore(item); await _load(); },
                  child: const Text('Restore'),
                ),
              );
            },
          ),
    );
  }
}
