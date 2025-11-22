import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_themes.dart';
import '../../widgets/common/custom_bottom_nav_bar.dart';
import '../../viewmodels/payment_card_viewmodel.dart';
import '../../models/payment_card_model.dart';

class PaymentCard {
  final String id;
  final String cardHolderName;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String cardType;

  PaymentCard({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.cardType,
  });

  String get maskedCardNumber {
    if (cardNumber.length >= 4) {
      return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
    }
    return cardNumber;
  }

  // Convert from PaymentCardModel
  factory PaymentCard.fromModel(PaymentCardModel model) {
    return PaymentCard(
      id: model.id,
      cardHolderName: model.cardHolderName,
      cardNumber: model.cardNumber,
      expiryMonth: model.expiryMonth,
      expiryYear: model.expiryYear,
      cvv: model.cvv,
      cardType: model.cardType,
    );
  }
}

class FarmerAccountsView extends StatefulWidget {
  const FarmerAccountsView({Key? key}) : super(key: key);

  @override
  State<FarmerAccountsView> createState() => _FarmerAccountsViewState();
}

class _FarmerAccountsViewState extends State<FarmerAccountsView> {
  int _selectedNavIndex = 1;
  List<PaymentCard> _paymentCards = [];
  int? _selectedCardIndex;

  @override
  void initState() {
    super.initState();
    // Load payment cards from Firebase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentCardViewModel>().loadPaymentCards();
    });
  }

  void _onNavItemTapped(int index) {
    if (_selectedNavIndex == index) return;

    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/farmer-home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/farmer-profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/farmer-settings');
        break;
    }
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AddCardDialog(
        onCardAdded: (card) async {
          final viewModel = context.read<PaymentCardViewModel>();
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(dialogContext);
          
          final success = await viewModel.addPaymentCard(
            cardHolderName: card.cardHolderName,
            cardNumber: card.cardNumber,
            expiryMonth: card.expiryMonth,
            expiryYear: card.expiryYear,
            cvv: card.cvv,
            cardType: card.cardType,
          );

          navigator.pop();
          
          if (success && mounted) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Card added successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (mounted) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(viewModel.errorMessage ?? 'Failed to add card'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      ),
    );
  }

  void _deleteCard(int index, String cardId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Card'),
        content: const Text('Are you sure you want to delete this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final viewModel = context.read<PaymentCardViewModel>();
              final success = await viewModel.deletePaymentCard(cardId);
              
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Card deleted successfully'),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage ?? 'Failed to delete card'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentCardViewModel>(
      builder: (context, viewModel, child) {
        // Convert PaymentCardModel to PaymentCard for UI
        final cards = viewModel.cards.map((model) => PaymentCard.fromModel(model)).toList();
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            if (cards.isEmpty)
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'No cards added yet',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: ListView.builder(
                                  itemCount: cards.length,
                                  itemBuilder: (context, index) {
                                    return _buildCardItem(cards[index], index, viewModel.cards[index].id);
                                  },
                                ),
                              ),
                            const SizedBox(height: 20),
                            _buildAddButton(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _selectedNavIndex,
            onTap: _onNavItemTapped,
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/farmer-home');
                },
              ),
              const Expanded(
                child: Text(
                  'Account Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(PaymentCard card, int index, String cardId) {
    final isSelected = _selectedCardIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardIndex = isSelected ? null : index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Delete icon on the left
            GestureDetector(
              onTap: () => _deleteCard(index, cardId),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Card logo
            Container(
              width: 50,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: _getCardLogo(card.cardType),
              ),
            ),
            const SizedBox(width: 16),
            // Card number
            Expanded(
              child: Text(
                card.maskedCardNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _getCardLogo(String cardType) {
    if (cardType.toLowerCase() == 'visa') {
      return const Text(
        'VISA',
        style: TextStyle(
          color: Color(0xFF1A1F71),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (cardType.toLowerCase() == 'mastercard') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFFEB001B),
              shape: BoxShape.circle,
            ),
          ),
          Transform.translate(
            offset: const Offset(-6, 0),
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFF79E1B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
    return const Icon(Icons.credit_card, color: Colors.grey);
  }

  Widget _buildAddButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: _showAddCardDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}

class AddCardDialog extends StatefulWidget {
  final Function(PaymentCard) onCardAdded;

  const AddCardDialog({Key? key, required this.onCardAdded}) : super(key: key);

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  String _selectedMonth = '01';
  String _selectedYear = '24';

  final List<String> _months = List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> _years = List.generate(10, (i) => (24 + i).toString());

  String _detectCardType(String cardNumber) {
    final sanitized = cardNumber.replaceAll(' ', '');
    if (sanitized.startsWith('4')) {
      return 'visa';
    } else if (sanitized.startsWith(RegExp(r'5[1-5]'))) {
      return 'mastercard';
    }
    return 'other';
  }

  void _handleAddCard() {
    if (_formKey.currentState!.validate()) {
      final card = PaymentCard(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardHolderName: _cardHolderController.text,
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        expiryMonth: _selectedMonth,
        expiryYear: _selectedYear,
        cvv: _cvvController.text,
        cardType: _detectCardType(_cardNumberController.text),
      );

      widget.onCardAdded(card);
      // Don't pop here - the callback will handle it
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add Card Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildLabel('Name on Card'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _cardHolderController,
                  hintText: 'Aruna Indika',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cardholder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Card Number'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _cardNumberController,
                  hintText: '1234 5678 1234 5678',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    _CardNumberFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    }
                    final sanitized = value.replaceAll(' ', '');
                    if (sanitized.length < 13 || sanitized.length > 19) {
                      return 'Invalid card number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Expiration Date'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        value: _selectedMonth,
                        items: _months,
                        onChanged: (value) => setState(() => _selectedMonth = value!),
                        hint: 'MM',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        value: _selectedYear,
                        items: _years,
                        onChanged: (value) => setState(() => _selectedYear = value!),
                        hint: 'YY',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('CCV'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _cvvController,
                  hintText: '123',
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter CVV';
                    }
                    if (value.length < 3) {
                      return 'CVV must be 3-4 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleAddCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Card',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        counterText: '',
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}