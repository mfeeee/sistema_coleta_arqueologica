// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginSystemTitle => 'System Access';

  @override
  String get loginPlatformDesc => 'Archaeological Data Collection Platform';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'example@archaeo.org';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginCreateAccount => 'Create Account';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginNoAccount => 'Don\'t have an account? Sign up';

  @override
  String get loginEmailRequired => 'Please enter your email';

  @override
  String get loginPasswordRequired => 'Please enter your password';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle =>
      'Join our archaeological exploration community.';

  @override
  String get registerFullName => 'Full Name';

  @override
  String get registerFullNameHint => 'Enter your full name';

  @override
  String get registerFullNameRequired => 'Please enter your name';

  @override
  String get registerEmailHint => 'example@institution.edu';

  @override
  String get registerClassification => 'Classification';

  @override
  String get registerClassificationHint => 'Select your profile';

  @override
  String get registerClassStudent => 'Student';

  @override
  String get registerClassTeacher => 'Professor';

  @override
  String get registerClassArchaeologist => 'Archaeologist';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint => 'Create a password';

  @override
  String get registerPasswordMin => 'Minimum 8 characters';

  @override
  String get registerConfirmPassword => 'Confirm Password';

  @override
  String get registerConfirmPasswordHint => 'Repeat password';

  @override
  String get registerPasswordMismatch => 'Passwords don\'t match';

  @override
  String get registerButton => 'Create Account';

  @override
  String get registerHaveAccount => 'Already have an account? Sign in';

  @override
  String get registerTermsText => 'By registering, you agree to our';

  @override
  String get registerTermsService => 'Terms of Service';

  @override
  String get registerTermsAnd => 'and';

  @override
  String get registerPrivacyPolicy => 'Privacy Policy';

  @override
  String get recoverPasswordTitle => 'Reset Password';

  @override
  String get recoverPasswordSubtitle =>
      'Enter your registered email to receive recovery instructions.';

  @override
  String get recoverPasswordEmailSent => 'Email Sent';

  @override
  String get recoverPasswordEmailSentDesc =>
      'Check your email to reset your password.';

  @override
  String get recoverPasswordBackToLogin => 'Back to Sign In';

  @override
  String get recoverPasswordEnterCode => 'Enter Code';

  @override
  String get recoverPasswordSendLink => 'Send Link';

  @override
  String get recoverPasswordRemember => 'Remember your password?';

  @override
  String get recoverPasswordDoLogin => 'Sign in';

  @override
  String get homeTitle => 'Home';

  @override
  String homeGreeting(String nome) {
    return 'Hello, $nome';
  }

  @override
  String get homeResearcher => 'Researcher';

  @override
  String get homeSubtitle => 'Ready for new discoveries today?';

  @override
  String get homeWelcome => 'Welcome';

  @override
  String homePendingBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count collections awaiting upload',
      one: '$count collection awaiting upload',
    );
    return '$_temp0';
  }

  @override
  String get homeNewCollection => 'New Collection';

  @override
  String get homeViewCollections => 'View My Collections';

  @override
  String get homeSyncNow => 'Sync Now';

  @override
  String get homeActivitySummary => 'Activity Summary';

  @override
  String get homeTotal => 'TOTAL';

  @override
  String get homePendingLabel => 'PENDING';

  @override
  String get homeRecentActivities => 'Recent Activities';

  @override
  String get homeViewAll => 'View all';

  @override
  String get homeRecentCollections => 'Recent Collections';

  @override
  String get homeNoCollections => 'No collections registered yet.';

  @override
  String get homeNoTitle => 'Untitled collection';

  @override
  String homeTodayAt(String hora) {
    return 'Today at $hora';
  }

  @override
  String homeYesterdayAt(String hora) {
    return 'Yesterday at $hora';
  }

  @override
  String get coletaTitle => 'Collection';

  @override
  String get coletaNewTitle => 'New Collection';

  @override
  String get coletaEditTitle => 'Edit Collection';

  @override
  String get coletaFieldLocation => 'Location';

  @override
  String get coletaFieldDate => 'Date';

  @override
  String get coletaFieldDescription => 'Description';

  @override
  String get coletaSaveButton => 'Save';

  @override
  String get coletaCancelButton => 'Cancel';

  @override
  String get coletaDeleteButton => 'Delete';

  @override
  String get coletaDeleteConfirm =>
      'Are you sure you want to delete this collection?';

  @override
  String get coletaSuccess => 'Collection saved successfully!';

  @override
  String get coletasTitle => 'My Collections';

  @override
  String get coletasTabAll => 'ALL';

  @override
  String get coletasTabPending => 'PENDING';

  @override
  String get coletasTabApproved => 'APPROVED';

  @override
  String get coletasTabRejected => 'REJECTED';

  @override
  String get coletasDraftBanner => 'You have a saved draft. Continue?';

  @override
  String get coletasDraftDiscard => 'Discard';

  @override
  String get coletasDraftContinue => 'Continue';

  @override
  String get coletasEmptyFirst =>
      'Register your first archaeological collection.';

  @override
  String get coletasEmptyPending => 'No pending collections.';

  @override
  String get coletasEmptyApproved => 'No approved collections.';

  @override
  String get coletasEmptyRejected => 'No rejected collections.';

  @override
  String get coletasRetry => 'Try again';

  @override
  String get coletasNoRegistered => 'No collections registered';

  @override
  String get coletasDataSynced => 'Data Synced';

  @override
  String coletasSyncProgress(int synced, int total) {
    return '$synced of $total synced';
  }

  @override
  String get bemMaterialTitle => 'Material Asset';

  @override
  String get bemMaterialNewTitle => 'New Asset';

  @override
  String get bemMaterialEditTitle => 'Edit Asset';

  @override
  String get bemMaterialFieldName => 'Name';

  @override
  String get bemMaterialFieldCode => 'Code';

  @override
  String get bemMaterialFieldCategory => 'Category';

  @override
  String get bemMaterialSaveButton => 'Save';

  @override
  String get bemMaterialDeleteConfirm => 'Confirm asset deletion?';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUserBadge => 'USER';

  @override
  String get profileFieldStats => 'Field Statistics';

  @override
  String get profileRegisteredCollections => 'REGISTERED COLLECTIONS';

  @override
  String get profilePendingSyncLabel => 'PENDING SYNC';

  @override
  String get profileNotificationsSection => 'Notifications';

  @override
  String get profileSyncAlerts => 'Sync Alerts';

  @override
  String get profileCurationStatus => 'Curation Status';

  @override
  String get profileProximityAlerts => 'Proximity Alerts';

  @override
  String get profileNotificationPrefs => 'Notification Preferences';

  @override
  String get profileAppPreferences => 'App Preferences';

  @override
  String get profileDarkMode => 'Dark Mode';

  @override
  String get profileUnits => 'Units of Measurement';

  @override
  String get profileMetric => 'Metric';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageValue => 'English';

  @override
  String get profileExportLogs => 'Export error logs';

  @override
  String get profileLogoutButton => 'Sign Out';

  @override
  String get profileLogoutTitle => 'Sign Out';

  @override
  String get profileLogoutContent =>
      'Do you want to end the session? Unsynchronized collections must be sent before signing out.';

  @override
  String get profileLogoutCancel => 'Cancel';

  @override
  String get profileLogoutConfirm => 'Sign Out';

  @override
  String get profilePendingWarning =>
      'You have collections pending synchronization. Sync before signing out.';

  @override
  String get profileEditButton => 'Edit Profile';

  @override
  String get profileFieldName => 'Name';

  @override
  String get profileFieldEmail => 'Email';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications found.';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsRetry => 'Try again';

  @override
  String get notificationsFilterAll => 'All';

  @override
  String get notificationsFilterColeta => 'Collection';

  @override
  String get notificationsFilterSync => 'Sync';

  @override
  String get notificationsFilterSystem => 'System';

  @override
  String notificationsFilterLabel(String name) {
    return 'Filter by $name';
  }

  @override
  String notificationsMinutesAgo(int min) {
    return '$min min ago';
  }

  @override
  String notificationsHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get notificationsYesterday => 'Yesterday';

  @override
  String notificationsDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get syncTitle => 'Synchronization';

  @override
  String get syncPageTitle => 'Sync';

  @override
  String get syncConnectionStatus => 'Connection Status';

  @override
  String get syncOnline => 'You\'re Online';

  @override
  String get syncOffline => 'You\'re Offline';

  @override
  String get syncOnlineLabel => 'Online';

  @override
  String get syncOfflineLabel => 'Offline';

  @override
  String get syncGeneralProgress => 'Overall Progress';

  @override
  String syncPercentLabel(int percent) {
    return '$percent% synced';
  }

  @override
  String get syncPendingItems => 'Pending items';

  @override
  String syncPendingCountLabel(int count) {
    return '$count pending';
  }

  @override
  String get syncDetails => 'BREAKDOWN';

  @override
  String get syncGpsData => 'GPS Data';

  @override
  String get syncPendingForms => 'Pending Forms';

  @override
  String get syncConflictsLabel => 'Conflicts';

  @override
  String get syncSendErrors => 'Send Errors';

  @override
  String syncConflictCount(int count) {
    return '$count conflict(s)';
  }

  @override
  String syncErrorCount(int count) {
    return '$count error(s)';
  }

  @override
  String get syncButton => 'Sync now';

  @override
  String get syncStartButton => 'Start Full Synchronization';

  @override
  String get syncSuccess => 'Synced successfully!';

  @override
  String get syncSuccessAll => 'Everything synced successfully!';

  @override
  String get syncError => 'Sync failed. Please try again.';

  @override
  String syncNeedsReview(int count) {
    return '$count conflict(s) need review.';
  }

  @override
  String get syncExpiredSession => 'Session expired. Please sign in again.';

  @override
  String get syncNoConnection =>
      'No connection. Connect to the internet to sync.';

  @override
  String get syncInProgress => 'Syncing…';

  @override
  String get syncUnexpectedError => 'Unexpected error.';

  @override
  String get syncLastSync => 'Last sync';

  @override
  String get syncLastSyncNever => 'Last sync: --';

  @override
  String get syncOk => 'OK';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonError => 'An unexpected error occurred.';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRequired => 'Required field';

  @override
  String get commonInvalidEmail => 'Invalid email';

  @override
  String get commonRetry => 'Try again';

  @override
  String get navHome => 'Home';

  @override
  String get navCollections => 'Collections';

  @override
  String get navSync => 'Sync';

  @override
  String get navProfile => 'Profile';
}
