import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewPage extends StatefulWidget {
  final String pdf;
  const PdfViewPage({super.key, required this.pdf});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const PDF(
          swipeHorizontal: true,
        ).cachedFromUrl(
          widget.pdf,
          placeholder: (progress) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text('Baixando...')
            ],
          ),
        ),
      ),
    );
  }
}
