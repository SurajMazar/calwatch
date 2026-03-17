import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../core/constants.dart';
import '../data/repositories/settings_repository.dart';
import 'backup_service.dart';

final driveSyncServiceProvider = Provider<DriveSyncService>((ref) {
  final backupService = ref.watch(backupServiceProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return DriveSyncService(backupService, settingsRepo);
});

class DriveSyncService {
  final BackupService _backupService;
  final SettingsRepository _settingsRepo;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  DriveSyncService(this._backupService, this._settingsRepo);

  Future<bool> get isSignedIn async => _googleSignIn.isSignedIn();

  Future<GoogleSignInAccount?> signIn() async {
    return _googleSignIn.signIn();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) return null;
    return drive.DriveApi(httpClient);
  }

  Future<String?> _findOrCreateFolder(drive.DriveApi driveApi) async {
    // Search for existing folder
    final query =
        "name = '${AppConstants.driveAppFolderName}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
    final results = await driveApi.files.list(q: query, spaces: 'drive');

    if (results.files != null && results.files!.isNotEmpty) {
      return results.files!.first.id;
    }

    // Create folder
    final folder = drive.File()
      ..name = AppConstants.driveAppFolderName
      ..mimeType = 'application/vnd.google-apps.folder';

    final created = await driveApi.files.create(folder);
    return created.id;
  }

  Future<void> backup() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      throw Exception('Not signed in to Google Drive');
    }

    final folderId = await _findOrCreateFolder(driveApi);
    if (folderId == null) throw Exception('Could not create backup folder');

    // Create compressed backup
    final backupFile = await _backupService.createBackup();

    // Check if existing backup exists and delete it
    final existingQuery =
        "name = '${AppConstants.driveBackupFileName}' and '$folderId' in parents and trashed = false";
    final existing =
        await driveApi.files.list(q: existingQuery, spaces: 'drive');
    if (existing.files != null) {
      for (final f in existing.files!) {
        await driveApi.files.delete(f.id!);
      }
    }

    // Upload
    final media = drive.Media(
      backupFile.openRead(),
      await backupFile.length(),
    );

    final driveFile = drive.File()
      ..name = AppConstants.driveBackupFileName
      ..parents = [folderId];

    await driveApi.files.create(driveFile, uploadMedia: media);

    // Update last sync time
    await _settingsRepo.setLastSyncTime(DateTime.now());

    // Cleanup
    await backupFile.delete();
  }

  Future<void> restore() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      throw Exception('Not signed in to Google Drive');
    }

    final folderId = await _findOrCreateFolder(driveApi);
    if (folderId == null) throw Exception('Could not find backup folder');

    // Find backup file
    final query =
        "name = '${AppConstants.driveBackupFileName}' and '$folderId' in parents and trashed = false";
    final results = await driveApi.files.list(q: query, spaces: 'drive');

    if (results.files == null || results.files!.isEmpty) {
      throw Exception('No backup found on Google Drive');
    }

    final fileId = results.files!.first.id!;

    // Download
    final media = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final tempDir = await getTemporaryDirectory();
    final localFile = File(p.join(tempDir.path, 'calwatch_restore.tar.gz'));
    final sink = localFile.openWrite();

    await for (final chunk in media.stream) {
      sink.add(chunk);
    }
    await sink.close();

    // Restore from archive
    await _backupService.restoreBackup(localFile);

    // Cleanup
    await localFile.delete();
  }
}
