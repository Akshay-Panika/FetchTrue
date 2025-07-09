import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteButton extends StatefulWidget {
  final String userId;
  final String serviceId;
  final bool isInitiallyFavorite;
  final void Function(bool)? onChanged;

  const FavoriteButton({
    super.key,
    required this.userId,
    required this.serviceId,
    required this.isInitiallyFavorite,
    this.onChanged,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isInitiallyFavorite;
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoading = true);

    final url = Uri.parse(
      'https://biz-booster.vercel.app/api/users/favourite-services/${widget.userId}/${widget.serviceId}',
    );

    try {
      final response = _isFavorite ? await http.delete(url) : await http.put(url);

      if (response.statusCode == 200) {
        setState(() => _isFavorite = !_isFavorite);
        widget.onChanged?.call(_isFavorite); // Notify parent
      } else {
        print('❌ Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 15,
              offset: Offset(0, 1),
            ),
          ],
        ),
      child: _isLoading
          ? Center(
            child: const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red,),
                  ),
          )
          : IconButton(
        onPressed: _toggleFavorite,
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
      )
    );
  }
}
