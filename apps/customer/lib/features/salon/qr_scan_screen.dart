import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

/// Camera QR scanner. Pops with the first code it reads; the salon entry screen resolves it.
class QrScanScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _done = false;

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    final value = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
    if (value == null || value.isEmpty) return;
    _done = true;
    context.pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.salonScanQr)),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
            errorBuilder: (context, error) => SbEmptyState(
              icon: Icons.no_photography_outlined,
              title: error.errorCode == MobileScannerErrorCode.permissionDenied ? l.cameraPermissionTitle : l.cameraUnavailable,
              body: l.cameraPermissionBody,
            ),
          ),
          PositionedDirectional(
            start: SbSpace.lg,
            end: SbSpace.lg,
            bottom: SbSpace.xl,
            child: SbCard(child: Text(l.salonScanHint, textAlign: TextAlign.center, style: context.sbText.bodyMedium)),
          ),
        ],
      ),
    );
  }
}
