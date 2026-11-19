// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wara2tak';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInToAnalyze => 'Sign in to analyze your documents with AI';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get byContinuing => 'By continuing, you agree to our ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get versionInfo => 'Version 1.0.0+1';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get welcomeToWara2tak => 'Welcome to Wara2tak';

  @override
  String get onboardingDescription =>
      'Upload your documents and let AI extract key clauses, deadlines, and financial obligations.';

  @override
  String get aiDocumentIntelligence => 'AI Document Intelligence';

  @override
  String get extractClausesFindDeadlines =>
      'Extract clauses • Find deadlines • Plan applications';

  @override
  String get uploadDocument => 'Upload Document';

  @override
  String get uploadAndAnalyze => 'Upload & Analyze';

  @override
  String get reviewDocument => 'Review Document';

  @override
  String get analyzingDocument => 'Analyzing Document';

  @override
  String get analysisProgress => 'Analyzing...';

  @override
  String get analysisFailed => 'Analysis Failed';

  @override
  String get analysisErrorMessage =>
      'Something went wrong during analysis. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get confirm => 'Confirm';

  @override
  String get selectFile => 'Select File';

  @override
  String get dragDropFileHere => 'Drag & drop a file here';

  @override
  String get orTapToBrowse => 'or tap to browse';

  @override
  String get chooseFile => 'Choose File';

  @override
  String get cameraGallery => 'Camera/Gallery';

  @override
  String get documentTitle => 'Document Title';

  @override
  String get enterDocumentTitle => 'Enter document title';

  @override
  String get documentType => 'Document Type';

  @override
  String get supportedFormats => 'Supported formats: PDF, PNG, JPG (max 50MB)';

  @override
  String get pdfDocument => 'PDF Document';

  @override
  String get imageFile => 'Image File';

  @override
  String get change => 'Change';

  @override
  String get analyzeNewDocument => 'Analyze a new document';

  @override
  String get uploadDescription =>
      'Upload a PDF or image to extract key clauses, deadlines, and financial obligations';

  @override
  String get recentDocuments => 'Recent Documents';

  @override
  String get viewAll => 'View All';

  @override
  String get noDocumentsYet => 'No documents yet';

  @override
  String get uploadFirstDocument => 'Upload your first document to get started';

  @override
  String get totalDocuments => 'Total Documents';

  @override
  String get analyzed => 'Analyzed';

  @override
  String get processing => 'Processing';

  @override
  String get myDocuments => 'My Documents';

  @override
  String get loadingDocuments => 'Loading documents...';

  @override
  String get failedToLoadDocuments => 'Failed to load documents';

  @override
  String get deleteDocumentTitle => 'Delete Document';

  @override
  String deleteDocumentConfirmation(Object title) {
    return 'Are you sure you want to delete \"$title\"? This action cannot be undone.';
  }

  @override
  String get documentDeleted => 'Document deleted successfully';

  @override
  String get documentUploaded => 'Document uploaded successfully!';

  @override
  String get profile => 'Profile';

  @override
  String get preferences => 'Preferences';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get toggleDarkLightTheme => 'Toggle dark/light theme';

  @override
  String get notifications => 'Notifications';

  @override
  String get enablePushNotifications => 'Enable push notifications';

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App Language';

  @override
  String get appLanguageSubtitle =>
      'Select the app interface language (English/Arabic)';

  @override
  String get defaultTranslationLanguage => 'Default Translation Language';

  @override
  String get defaultTranslationLanguageSubtitle =>
      'Default target language for document translations';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get updatePersonalInfo => 'Update your personal information';

  @override
  String get displayName => 'Display Name';

  @override
  String get security => 'Security';

  @override
  String get managePasswordBiometric => 'Manage password and biometric auth';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmation =>
      'This action cannot be undone. All your documents, analyses, and data will be permanently deleted.';

  @override
  String get deleteAccountPermanently =>
      'Permanently delete your account and data';

  @override
  String get signOut => 'Sign Out';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get readTermsConditions => 'Read our terms and conditions';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get learnDataProtection => 'Learn how we protect your data';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get getHelpContact => 'Get help or contact support';

  @override
  String get documentDetails => 'Document Details';

  @override
  String get summary => 'Summary';

  @override
  String get keyClauses => 'Key Clauses';

  @override
  String get deadlines => 'Deadlines';

  @override
  String get financials => 'Financials';

  @override
  String get aiSummary => 'AI Summary';

  @override
  String get redFlags => 'Red Flags';

  @override
  String get checklist => 'Checklist';

  @override
  String get viewAllItems => 'View All';

  @override
  String get chat => 'Chat';

  @override
  String get translate => 'Translate';

  @override
  String get refresh => 'Refresh';

  @override
  String get pages => 'Pages';

  @override
  String get size => 'Size';

  @override
  String get uploaded => 'Uploaded';

  @override
  String get clauses => 'Clauses';

  @override
  String get financialObligations => 'Financials';

  @override
  String get statusAnalyzed => 'Analyzed';

  @override
  String get statusAnalyzing => 'Analyzing';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusUploaded => 'Uploaded';

  @override
  String get overdue => 'OVERDUE';

  @override
  String get completed => 'DONE';

  @override
  String dueDate(Object date) {
    return 'Due: $date';
  }

  @override
  String recurring(Object frequency) {
    return 'Recurring: $frequency';
  }

  @override
  String recommendation(Object recommendation) {
    return 'Recommendation: $recommendation';
  }

  @override
  String get importanceCritical => 'CRITICAL';

  @override
  String get importanceHigh => 'HIGH';

  @override
  String get importanceMedium => 'MEDIUM';

  @override
  String get importanceLow => 'LOW';

  @override
  String get severityCritical => 'CRITICAL';

  @override
  String get severityHigh => 'HIGH';

  @override
  String get severityMedium => 'MEDIUM';

  @override
  String get severityLow => 'LOW';

  @override
  String get rentalContract => 'Rental Contract';

  @override
  String get employmentContract => 'Employment Contract';

  @override
  String get termsOfServiceType => 'Terms of Service';

  @override
  String get privacyPolicyType => 'Privacy Policy';

  @override
  String get otherType => 'Other';

  @override
  String get documentChat => 'Document Chat';

  @override
  String get askAboutDocument => 'Ask about the document...';

  @override
  String get startConversation => 'Start a Conversation';

  @override
  String get askQuestionsAboutDocument =>
      'Ask questions about your document. The AI will answer based on the analyzed content.';

  @override
  String get suggestedQuestions => 'Suggested Questions';

  @override
  String get keyDeadlinesQuestion => 'What are the key deadlines?';

  @override
  String get documentsToPrepareQuestion =>
      'What documents do I need to prepare?';

  @override
  String get terminationConditionsQuestion =>
      'What are the termination conditions?';

  @override
  String get penaltiesFeesQuestion => 'Are there any penalties or fees?';

  @override
  String get summarizeFinancialsQuestion =>
      'Summarize the financial obligations.';

  @override
  String get thinking => 'Thinking...';

  @override
  String get clearConversation => 'Clear Conversation';

  @override
  String get clearConversationConfirmation =>
      'Are you sure you want to delete all messages? This cannot be undone.';

  @override
  String get translation => 'Translate';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get textToTranslate => 'Text to Translate';

  @override
  String get enterTextToTranslate => 'Enter text to translate...';

  @override
  String originalContent(Object language) {
    return 'Original ($language)';
  }

  @override
  String translationResult(Object language) {
    return 'Translation ($language)';
  }

  @override
  String get copy => 'Copy';

  @override
  String get translationCopied => 'Translation copied to clipboard';

  @override
  String get noContentToTranslate => 'No content to translate';

  @override
  String get analysisHasNoContent =>
      'The analysis does not have content for this section';

  @override
  String get summaryTab => 'Summary';

  @override
  String get deadlinesTab => 'Deadlines';

  @override
  String get financialObligationsTab => 'Financial Obligations';

  @override
  String get keyClausesTab => 'Key Clauses';

  @override
  String get redFlagsTab => 'Red Flags';

  @override
  String get customTextTab => 'Custom Text';

  @override
  String get sourceLanguage => 'Source Language';

  @override
  String get targetLanguage => 'Target Language';

  @override
  String get matchDocumentLanguage => 'Match document language';

  @override
  String get alwaysArabic => 'Always Arabic';

  @override
  String get alwaysEnglish => 'Always English';

  @override
  String get documentAnalysis => 'Document Analysis';

  @override
  String get loadingAnalysis => 'Loading analysis...';

  @override
  String get documentNotFound => 'Document not found';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get tryAgain => 'Try again';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get documents => 'Documents';

  @override
  String get upload => 'Upload';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get moreOptions => 'More options';

  @override
  String get deleteAccountWarning => 'Delete account permanently?';

  @override
  String get deleteAccountWarningDescription =>
      'This will delete your personal account and all documents, checklists, and data permanently and cannot be recovered.';

  @override
  String get confirmDeleteAccount => 'Confirm delete my account permanently';

  @override
  String get deletingAccount => 'Deleting your account...';

  @override
  String get deletingAccountDescription =>
      'Your documents and personal data are being removed from your workspace.';

  @override
  String get linkedToGoogle => 'Linked to Google Account';

  @override
  String get uploadStep1of2 => 'Step 1 of 2';

  @override
  String get uploadTitle => 'Upload Document';

  @override
  String get selectFileToAnalyze => 'Select a file to analyze';

  @override
  String get extractDeadlinesEligibility =>
      'Wara2tak extracts deadlines, eligibility criteria, and required documents directly from the opportunity announcement.';

  @override
  String get browsePDFs => 'Browse PDF Files';

  @override
  String get chooseGuideOrInvitation =>
      'Choose the official guide, publications, or invitation letter';

  @override
  String get fromGallery => 'From Gallery';

  @override
  String get chooseScreenshots =>
      'Choose screenshots, saved announcement images, and posters';

  @override
  String get scanPaper => 'Scan Paper';

  @override
  String get useCameraForPaper =>
      'Use camera to scan paper announcements and printed flyers';

  @override
  String get supportedFormatsList => 'Supported formats:';

  @override
  String get clearDocumentsGiveBetterResults =>
      'Clear, high-contrast documents yield more accurate results. Maximum file size and page count limits apply.';

  @override
  String get noPersonalRecords =>
      'Do not upload passports, ID cards, or personal records. Upload opportunity announcements only.';

  @override
  String fileSelected(Object fileName) {
    return '$fileName selected';
  }

  @override
  String get pdfFile => 'PDF File';

  @override
  String get imageFileSelected => 'Image File';

  @override
  String get removeFile => 'Remove file';

  @override
  String get selectDocumentType => 'Select document type';

  @override
  String get documentTypeRental => 'Rental Contract';

  @override
  String get documentTypeEmployment => 'Employment Contract';

  @override
  String get documentTypeTerms => 'Terms of Service';

  @override
  String get documentTypePrivacy => 'Privacy Policy';

  @override
  String get documentTypeOther => 'Other';

  @override
  String get uploadButton => 'Upload & Analyze';

  @override
  String get uploading => 'Uploading...';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get analysisComplete => 'Analysis complete';

  @override
  String get analysisError => 'Analysis error';

  @override
  String get checklistProgress => 'Progress';

  @override
  String checklistCompletedOfTotal(Object completed, Object total) {
    return '$completed / $total';
  }

  @override
  String get addTask => 'Add Task';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get taskDescription => 'Description (optional)';

  @override
  String get category => 'Category';

  @override
  String get priority => 'Priority (1-5, optional)';

  @override
  String get dueDateOptional => 'Set Due Date (optional)';

  @override
  String get add => 'Add';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String deleteTaskConfirmation(Object title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get beforeSigning => 'Before Signing';

  @override
  String get afterSigning => 'After Signing';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get legal => 'Legal';

  @override
  String get financial => 'Financial';

  @override
  String get otherCategory => 'Other';

  @override
  String get fromDocument => 'From Document';

  @override
  String get personalTasks => 'Personal Tasks';

  @override
  String page(Object number) {
    return 'Page $number';
  }

  @override
  String get completedStatus => 'Completed';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get overdueStatus => 'Overdue';

  @override
  String get loadingChecklist => 'Loading checklist...';

  @override
  String get failedToLoadChecklist => 'Failed to load checklist';

  @override
  String get noChecklistItems => 'No checklist items';

  @override
  String get tasksGeneratedFromAnalysis =>
      'Tasks will be generated from document analysis';

  @override
  String get reviewDocumentSummary => 'Review Document Summary';

  @override
  String get interactiveChecklist => 'Interactive Checklist';

  @override
  String itemsReady(Object count, Object total) {
    return '$count of $total items ready';
  }

  @override
  String get signIn => 'Sign In';

  @override
  String get documentsStayPrivate =>
      'Your documents stay saved in your private space only.';

  @override
  String get opportunitiesClearAndUnderstood =>
      'Your academic opportunities, clear and understood.';

  @override
  String get uploadGrantDocuments =>
      'Upload grant, internship, or exchange documents and let AI extract what matters to you.';

  @override
  String get prepareYourWorkspace => 'PREPARING YOUR WORKSPACE';

  @override
  String get getStartedNow => 'Get Started Now';

  @override
  String get errorScreenTitle => 'Something went wrong';

  @override
  String get errorScreenMessage => 'Unknown error';

  @override
  String get goHome => 'Go Home';

  @override
  String get documentTypeLabel => 'Type';

  @override
  String get documentStatus => 'Status';

  @override
  String analyzedOn(Object date, Object pages) {
    return 'Analyzed on $date • $pages pages';
  }

  @override
  String get readyForReview => 'Ready for review';

  @override
  String analyzingCount(Object count) {
    return '$count analyzing';
  }

  @override
  String pageNumber(Object number) {
    return 'Page $number';
  }

  @override
  String amountCurrency(Object amount, Object currency) {
    return '$currency $amount';
  }

  @override
  String get financialTitle => 'Financial';

  @override
  String get deadlineTitle => 'Deadline';

  @override
  String get clauseTitle => 'Clause';

  @override
  String get redFlagTitle => 'Red Flag';

  @override
  String get checklistItemTitle => 'Checklist Item';

  @override
  String get chatMessage => 'Chat Message';

  @override
  String get translationContent => 'Translation Content';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get emptyStateTitle => 'Nothing here yet';

  @override
  String get emptyStateSubtitle => 'No items to display';

  @override
  String get actionRequired => 'Action required';

  @override
  String get optional => 'Optional';

  @override
  String get required => 'Required';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get error => 'Error';

  @override
  String get info => 'Info';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Clear';

  @override
  String get select => 'Select';

  @override
  String get deselect => 'Deselect';

  @override
  String get all => 'All';

  @override
  String get none => 'None';

  @override
  String get searchHint => 'Search...';

  @override
  String get filterHint => 'Filter...';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortAscending => 'Ascending';

  @override
  String get sortDescending => 'Descending';

  @override
  String get dateFormat => 'MM/dd/yyyy';

  @override
  String get timeFormat => 'HH:mm';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageFrench => 'French';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageGerman => 'German';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageTurkish => 'Turkish';

  @override
  String get languagePersian => 'Persian';

  @override
  String get selectAppLanguage => 'Select App Language';

  @override
  String get selectTranslationLanguage => 'Select Translation Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get account => 'Account';

  @override
  String get updatePersonalInformation => 'Update your personal information';

  @override
  String get permanentlyDeleteAccountData =>
      'Permanently delete your account and data';

  @override
  String get learnHowWeProtectData => 'Learn how we protect your data';

  @override
  String get getHelpContactSupport => 'Get help or contact support';

  @override
  String get homeScreenTagline =>
      'Understand every document. Plan your next step.';

  @override
  String get previewScreenTitle => 'Document preview';

  @override
  String get previewScreenDescription =>
      'The document preview and confirmation options will appear here.';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get failedToPickFile => 'Couldn\'t select the file. Please try again.';

  @override
  String get failedToPickImage =>
      'Couldn\'t select the image. Please try again.';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get failedToLoadProfile => 'Couldn\'t load your profile';

  @override
  String get loadingDocument => 'Loading document...';

  @override
  String get failedToLoadDocument => 'Couldn\'t load the document';

  @override
  String get noKeyClausesFound => 'No key clauses found';

  @override
  String get noKeyClausesDescription =>
      'The analysis did not identify any key clauses.';

  @override
  String get noDeadlinesFound => 'No deadlines found';

  @override
  String get noDeadlinesDescription =>
      'The analysis did not identify any deadlines.';

  @override
  String get noFinancialObligationsFound => 'No financial obligations found';

  @override
  String get noFinancialObligationsDescription =>
      'The analysis did not identify any financial obligations.';

  @override
  String viewChecklistItems(Object count) {
    return 'View items ($count)';
  }

  @override
  String priorityLevel(Object priority) {
    return 'Priority $priority';
  }

  @override
  String sourceLabel(Object source) {
    return 'Source: $source';
  }

  @override
  String get user => 'User';

  @override
  String get selectFileFirst => 'Please select a file first';

  @override
  String get signInFirst => 'Please sign in first';

  @override
  String uploadedOn(Object date, Object pages) {
    return 'Uploaded on $date • $pages pages';
  }

  @override
  String get readingFile => 'Reading file...';

  @override
  String get preparingAnalysis => 'Preparing analysis...';

  @override
  String get processingAnalysis => 'Processing analysis results...';

  @override
  String get savingResults => 'Saving results...';

  @override
  String get reviewPrefix => 'Review';

  @override
  String get chatPlaceholderResponse =>
      'This is a temporary response. The live AI response will be available once the chat service is connected.';

  @override
  String importanceLabel(Object importance) {
    return 'Importance: $importance';
  }

  @override
  String severityLabel(Object severity) {
    return 'Severity: $severity';
  }

  @override
  String get noDueDate => 'No due date';

  @override
  String get frequencyMonthly => 'monthly';

  @override
  String get frequencyQuarterly => 'quarterly';

  @override
  String get frequencyYearly => 'yearly';
}
