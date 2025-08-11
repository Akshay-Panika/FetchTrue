import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteServiceButtonWidget extends StatefulWidget {
  final String userId;
  final String serviceId;
  final bool isInitiallyFavorite;
  final void Function(bool)? onChanged;

  const FavoriteServiceButtonWidget({
    super.key,
    required this.userId,
    required this.serviceId,
    required this.isInitiallyFavorite,
    this.onChanged,
  });

  @override
  State<FavoriteServiceButtonWidget> createState() => _FavoriteServiceButtonWidgetState();
}

class _FavoriteServiceButtonWidgetState extends State<FavoriteServiceButtonWidget> {
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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CircleAvatar(
            radius: 20,
        backgroundColor: Colors.white.withOpacity(0.3),
        child: _isLoading
            ? Center(
              child: const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red,),
                    ),
            )
            : Center(
              child: IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
                      ),
                    ),
            )
      ),
    );
  }
}
