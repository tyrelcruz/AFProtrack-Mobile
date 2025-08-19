import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ValidatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final VoidCallback? onChanged;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final String? errorText;
  final bool showError;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const ValidatedTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.errorText,
    this.showError = false,
    this.focusNode,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  // Focus tracking not currently used
  // bool _isFocused = false;
  String? _currentError;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _runValidation(String value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != _currentError) {
        setState(() {
          _currentError = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError =
        (widget.showError && widget.errorText != null) ||
        (_touched && _currentError != null);
    final errorMessage = _currentError ?? widget.errorText;

    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            focusNode: widget.focusNode,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            onChanged: (value) {
              widget.onChanged?.call();
              if (!_touched) _touched = true;
              _runValidation(value);
            },
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            // onTap intentionally omitted; focus tracking not used
            decoration: InputDecoration(
              prefixIcon:
                  widget.prefixIcon != null
                      ? Icon(
                        widget.prefixIcon,
                        color: hasError ? Colors.red : AppColors.armyPrimary,
                      )
                      : null,
              labelText: widget.labelText,
              hintText: widget.hintText,
              labelStyle: TextStyle(
                color: hasError ? Colors.red : AppColors.armyPrimary,
              ),
              hintStyle: TextStyle(
                color: AppColors.armyPrimary.withOpacity(0.6),
                fontSize: 12,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : AppColors.armyPrimary,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : AppColors.armyPrimary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          if (hasError && errorMessage != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
