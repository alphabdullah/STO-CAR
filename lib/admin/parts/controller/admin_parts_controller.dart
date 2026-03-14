import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/parts_state.dart';
import '../../../models/part_model.dart';

/// Admin parts controller (MVC pattern - Controller layer)
class AdminPartsController extends GetxController {
  final PartsState _partsState = PartsState();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();
  String? _selectedCompanyId;

  @override
  void onClose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.onClose();
  }

  void showAddPartDialog(BuildContext context) {
    _clearFields();
    _showPartDialog(context, isEdit: false);
  }

  void showEditPartDialog(BuildContext context, PartModel part) {
    _nameController.text = part.name;
    _descriptionController.text = part.description;
    _priceController.text = part.price.toString();
    _stockController.text = part.stockQuantity.toString();
    _categoryController.text = part.category;
    _selectedCompanyId = part.companyId;
    _showPartDialog(context, isEdit: true, part: part);
  }

  void _showPartDialog(
    BuildContext context, {
    required bool isEdit,
    PartModel? part,
  }) {
    final companies = _partsState.companies;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              decoration: BoxDecoration(
                color: AppDesign.getBgSecondary(context),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.redPrimary.withValues(alpha: 0.2),
                          AppTheme.redPressed.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.redPrimary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isEdit ? Icons.edit_rounded : Icons.add_rounded,
                            color: AppTheme.redPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isEdit
                                ? AppLocalizations.of(context)!.editPart
                                : AppLocalizations.of(context)!.addPart,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: AppDesign.getTextPrimary(context),
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppDesign.getTextSecondary(context),
                            size: 24,
                          ),
                          onPressed: () {
                            _clearFields();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedCompanyId,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.company,
                              prefixIcon: Icon(
                                Icons.business_rounded,
                                color: AppDesign.getTextSecondary(context),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppDesign.getBgElevated(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.redPrimary,
                                  width: 2,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: AppDesign.getTextSecondary(context),
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            dropdownColor: AppDesign.getBgSecondary(context),
                            style: TextStyle(
                              color: AppDesign.getTextPrimary(context),
                              fontFamily: AppTheme.fontFamily,
                            ),
                            items: companies
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => _selectedCompanyId = value,
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.partName,
                              prefixIcon: Icon(
                                Icons.label_outline_rounded,
                                color: AppDesign.getTextSecondary(context),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppDesign.getBgElevated(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.redPrimary,
                                  width: 2,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: AppDesign.getTextSecondary(context),
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            style: TextStyle(
                              color: AppDesign.getTextPrimary(context),
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.description,
                              prefixIcon: Icon(
                                Icons.description_outlined,
                                color: AppDesign.getTextSecondary(context),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppDesign.getBgElevated(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.redPrimary,
                                  width: 2,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: AppDesign.getTextSecondary(context),
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            style: TextStyle(
                              color: AppDesign.getTextPrimary(context),
                              fontFamily: AppTheme.fontFamily,
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          TextField(
                            controller: _categoryController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.category,
                              prefixIcon: Icon(
                                Icons.category_outlined,
                                color: AppDesign.getTextSecondary(context),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppDesign.getBgElevated(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.redPrimary,
                                  width: 2,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: AppDesign.getTextSecondary(context),
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            style: TextStyle(
                              color: AppDesign.getTextPrimary(context),
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          TextField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.priceAed,
                              prefixIcon: Icon(
                                Icons.attach_money_rounded,
                                color: AppDesign.getTextSecondary(context),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppDesign.getBgElevated(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.redPrimary,
                                  width: 2,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: AppDesign.getTextSecondary(context),
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            style: TextStyle(
                              color: AppDesign.getTextPrimary(context),
                              fontFamily: AppTheme.fontFamily,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          TextField(
                            controller: _stockController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.stockQuantity,
                              prefixIcon: Icon(
                                Icons.inventory_2_outlined,
                                color: AppDesign.getTextSecondary(context),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppDesign.getBgElevated(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppDesign.getBorder(context)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.redPrimary,
                                  width: 2,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: AppDesign.getTextSecondary(context),
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            style: TextStyle(
                              color: AppDesign.getTextPrimary(context),
                              fontFamily: AppTheme.fontFamily,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      color: AppDesign.getBgElevated(context),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              _clearFields();
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 14 : 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: AppDesign.getBorder(context),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: AppDesign.getTextSecondary(context),
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 16),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.redPrimary,
                                  AppTheme.redPressed,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.redPrimary.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _savePart(context, isEdit, part),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 14 : 16,
                                  ),
                                  child: Center(
                                    child: Text(
                                      isEdit
                                          ? AppLocalizations.of(context)!.save
                                          : AppLocalizations.of(context)!.add,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppDesign.getTextPrimary(context),
                                        fontFamily: AppTheme.fontFamily,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _savePart(
    BuildContext context,
    bool isEdit,
    PartModel? part,
  ) async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCompanyId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseFillRequiredFields),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return;
    }

    final company = _partsState.companies.firstWhere(
      (c) => c.id == _selectedCompanyId,
    );

    final newPart = PartModel(
      id: isEdit ? part!.id : 'part_${DateTime.now().millisecondsSinceEpoch}',
      companyId: _selectedCompanyId!,
      companyName: company.name,
      name: _nameController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
      condition: isEdit ? part!.condition : 'new',
      price: double.tryParse(_priceController.text) ?? 0.0,
      currentPrice: double.tryParse(_priceController.text) ?? 0.0,
      stockQuantity: int.tryParse(_stockController.text) ?? 0,
      createdAt: isEdit ? part!.createdAt : DateTime.now(),
    );

    if (isEdit) {
      await _partsState.updatePart(newPart);
    } else {
      await _partsState.addPart(newPart);
    }

    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      Navigator.pop(context);
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit ? l10n.partUpdatedSuccessfully : l10n.partAddedSuccessfully,
          ),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> deletePart(BuildContext context, String partId) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deletePart),
        content: Text(l10n.deletePartConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _partsState.deletePart(partId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.partDeletedSuccessfully),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _categoryController.clear();
    _selectedCompanyId = null;
  }
}
