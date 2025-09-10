import 'package:flutter/material.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  final _departureCtrl = TextEditingController();
  final _arrivalCtrl = TextEditingController();
  DateTime? _date;

  @override
  void dispose() {
    _departureCtrl.dispose();
    _arrivalCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pushNamed(
      context,
      '/search',
      arguments: {
        'from': _departureCtrl.text.trim(),
        'to': _arrivalCtrl.text.trim(),
        'date': _date,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _departureCtrl,
                decoration: const InputDecoration(labelText: "From"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _arrivalCtrl,
                decoration: const InputDecoration(labelText: "To"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(now.year, now.month, now.day),
                          lastDate: DateTime(now.year + 2),
                          initialDate: _date ?? now,
                        );
                        if (picked != null) setState(() => _date = picked);
                      },
                      child: Text(_date == null
                          ? "Select date"
                          : "${_date!.day}/${_date!.month}/${_date!.year}"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Search Flights"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
