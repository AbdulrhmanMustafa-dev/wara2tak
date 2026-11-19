import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Wara2tak'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInToAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Sign in to analyze your documents with AI'**
  String get signInToAnalyze;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @byContinuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get byContinuing;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0+1'**
  String get versionInfo;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @welcomeToWara2tak.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Wara2tak'**
  String get welcomeToWara2tak;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload your documents and let AI extract key clauses, deadlines, and financial obligations.'**
  String get onboardingDescription;

  /// No description provided for @aiDocumentIntelligence.
  ///
  /// In en, this message translates to:
  /// **'AI Document Intelligence'**
  String get aiDocumentIntelligence;

  /// No description provided for @extractClausesFindDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Extract clauses • Find deadlines • Plan applications'**
  String get extractClausesFindDeadlines;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @uploadAndAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Upload & Analyze'**
  String get uploadAndAnalyze;

  /// No description provided for @reviewDocument.
  ///
  /// In en, this message translates to:
  /// **'Review Document'**
  String get reviewDocument;

  /// No description provided for @analyzingDocument.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Document'**
  String get analyzingDocument;

  /// No description provided for @analysisProgress.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analysisProgress;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis Failed'**
  String get analysisFailed;

  /// No description provided for @analysisErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong during analysis. Please try again.'**
  String get analysisErrorMessage;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @dragDropFileHere.
  ///
  /// In en, this message translates to:
  /// **'Drag & drop a file here'**
  String get dragDropFileHere;

  /// No description provided for @orTapToBrowse.
  ///
  /// In en, this message translates to:
  /// **'or tap to browse'**
  String get orTapToBrowse;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @cameraGallery.
  ///
  /// In en, this message translates to:
  /// **'Camera/Gallery'**
  String get cameraGallery;

  /// No description provided for @documentTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Title'**
  String get documentTitle;

  /// No description provided for @enterDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter document title'**
  String get enterDocumentTitle;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentType;

  /// No description provided for @supportedFormats.
  ///
  /// In en, this message translates to:
  /// **'Supported formats: PDF, PNG, JPG (max 50MB)'**
  String get supportedFormats;

  /// No description provided for @pdfDocument.
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get pdfDocument;

  /// No description provided for @imageFile.
  ///
  /// In en, this message translates to:
  /// **'Image File'**
  String get imageFile;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @analyzeNewDocument.
  ///
  /// In en, this message translates to:
  /// **'Analyze a new document'**
  String get analyzeNewDocument;

  /// No description provided for @uploadDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload a PDF or image to extract key clauses, deadlines, and financial obligations'**
  String get uploadDescription;

  /// No description provided for @recentDocuments.
  ///
  /// In en, this message translates to:
  /// **'Recent Documents'**
  String get recentDocuments;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noDocumentsYet.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get noDocumentsYet;

  /// No description provided for @uploadFirstDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload your first document to get started'**
  String get uploadFirstDocument;

  /// No description provided for @totalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Total Documents'**
  String get totalDocuments;

  /// No description provided for @analyzed.
  ///
  /// In en, this message translates to:
  /// **'Analyzed'**
  String get analyzed;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @myDocuments.
  ///
  /// In en, this message translates to:
  /// **'My Documents'**
  String get myDocuments;

  /// No description provided for @loadingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Loading documents...'**
  String get loadingDocuments;

  /// No description provided for @failedToLoadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load documents'**
  String get failedToLoadDocuments;

  /// No description provided for @deleteDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocumentTitle;

  /// No description provided for @deleteDocumentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? This action cannot be undone.'**
  String deleteDocumentConfirmation(Object title);

  /// No description provided for @documentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted successfully'**
  String get documentDeleted;

  /// No description provided for @documentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully!'**
  String get documentUploaded;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @toggleDarkLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle dark/light theme'**
  String get toggleDarkLightTheme;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enablePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable push notifications'**
  String get enablePushNotifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @appLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the app interface language (English/Arabic)'**
  String get appLanguageSubtitle;

  /// No description provided for @defaultTranslationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Default Translation Language'**
  String get defaultTranslationLanguage;

  /// No description provided for @defaultTranslationLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default target language for document translations'**
  String get defaultTranslationLanguageSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInfo;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @managePasswordBiometric.
  ///
  /// In en, this message translates to:
  /// **'Manage password and biometric auth'**
  String get managePasswordBiometric;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your documents, analyses, and data will be permanently deleted.'**
  String get deleteAccountConfirmation;

  /// No description provided for @deleteAccountPermanently.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and data'**
  String get deleteAccountPermanently;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  /// No description provided for @readTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Read our terms and conditions'**
  String get readTermsConditions;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @learnDataProtection.
  ///
  /// In en, this message translates to:
  /// **'Learn how we protect your data'**
  String get learnDataProtection;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @getHelpContact.
  ///
  /// In en, this message translates to:
  /// **'Get help or contact support'**
  String get getHelpContact;

  /// No description provided for @documentDetails.
  ///
  /// In en, this message translates to:
  /// **'Document Details'**
  String get documentDetails;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @keyClauses.
  ///
  /// In en, this message translates to:
  /// **'Key Clauses'**
  String get keyClauses;

  /// No description provided for @deadlines.
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get deadlines;

  /// No description provided for @financials.
  ///
  /// In en, this message translates to:
  /// **'Financials'**
  String get financials;

  /// No description provided for @aiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get aiSummary;

  /// No description provided for @redFlags.
  ///
  /// In en, this message translates to:
  /// **'Red Flags'**
  String get redFlags;

  /// No description provided for @checklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get checklist;

  /// No description provided for @viewAllItems.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAllItems;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @clauses.
  ///
  /// In en, this message translates to:
  /// **'Clauses'**
  String get clauses;

  /// No description provided for @financialObligations.
  ///
  /// In en, this message translates to:
  /// **'Financials'**
  String get financialObligations;

  /// No description provided for @statusAnalyzed.
  ///
  /// In en, this message translates to:
  /// **'Analyzed'**
  String get statusAnalyzed;

  /// No description provided for @statusAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing'**
  String get statusAnalyzing;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @statusUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get statusUploaded;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'OVERDUE'**
  String get overdue;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get completed;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String dueDate(Object date);

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring: {frequency}'**
  String recurring(Object frequency);

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation: {recommendation}'**
  String recommendation(Object recommendation);

  /// No description provided for @importanceCritical.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get importanceCritical;

  /// No description provided for @importanceHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get importanceHigh;

  /// No description provided for @importanceMedium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get importanceMedium;

  /// No description provided for @importanceLow.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get importanceLow;

  /// No description provided for @severityCritical.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get severityCritical;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get severityHigh;

  /// No description provided for @severityMedium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get severityMedium;

  /// No description provided for @severityLow.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get severityLow;

  /// No description provided for @rentalContract.
  ///
  /// In en, this message translates to:
  /// **'Rental Contract'**
  String get rentalContract;

  /// No description provided for @employmentContract.
  ///
  /// In en, this message translates to:
  /// **'Employment Contract'**
  String get employmentContract;

  /// No description provided for @termsOfServiceType.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceType;

  /// No description provided for @privacyPolicyType.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyType;

  /// No description provided for @otherType.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherType;

  /// No description provided for @documentChat.
  ///
  /// In en, this message translates to:
  /// **'Document Chat'**
  String get documentChat;

  /// No description provided for @askAboutDocument.
  ///
  /// In en, this message translates to:
  /// **'Ask about the document...'**
  String get askAboutDocument;

  /// No description provided for @startConversation.
  ///
  /// In en, this message translates to:
  /// **'Start a Conversation'**
  String get startConversation;

  /// No description provided for @askQuestionsAboutDocument.
  ///
  /// In en, this message translates to:
  /// **'Ask questions about your document. The AI will answer based on the analyzed content.'**
  String get askQuestionsAboutDocument;

  /// No description provided for @suggestedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Suggested Questions'**
  String get suggestedQuestions;

  /// No description provided for @keyDeadlinesQuestion.
  ///
  /// In en, this message translates to:
  /// **'What are the key deadlines?'**
  String get keyDeadlinesQuestion;

  /// No description provided for @documentsToPrepareQuestion.
  ///
  /// In en, this message translates to:
  /// **'What documents do I need to prepare?'**
  String get documentsToPrepareQuestion;

  /// No description provided for @terminationConditionsQuestion.
  ///
  /// In en, this message translates to:
  /// **'What are the termination conditions?'**
  String get terminationConditionsQuestion;

  /// No description provided for @penaltiesFeesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are there any penalties or fees?'**
  String get penaltiesFeesQuestion;

  /// No description provided for @summarizeFinancialsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Summarize the financial obligations.'**
  String get summarizeFinancialsQuestion;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get thinking;

  /// No description provided for @clearConversation.
  ///
  /// In en, this message translates to:
  /// **'Clear Conversation'**
  String get clearConversation;

  /// No description provided for @clearConversationConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all messages? This cannot be undone.'**
  String get clearConversationConfirmation;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translation;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @textToTranslate.
  ///
  /// In en, this message translates to:
  /// **'Text to Translate'**
  String get textToTranslate;

  /// No description provided for @enterTextToTranslate.
  ///
  /// In en, this message translates to:
  /// **'Enter text to translate...'**
  String get enterTextToTranslate;

  /// No description provided for @originalContent.
  ///
  /// In en, this message translates to:
  /// **'Original ({language})'**
  String originalContent(Object language);

  /// No description provided for @translationResult.
  ///
  /// In en, this message translates to:
  /// **'Translation ({language})'**
  String translationResult(Object language);

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @translationCopied.
  ///
  /// In en, this message translates to:
  /// **'Translation copied to clipboard'**
  String get translationCopied;

  /// No description provided for @noContentToTranslate.
  ///
  /// In en, this message translates to:
  /// **'No content to translate'**
  String get noContentToTranslate;

  /// No description provided for @analysisHasNoContent.
  ///
  /// In en, this message translates to:
  /// **'The analysis does not have content for this section'**
  String get analysisHasNoContent;

  /// No description provided for @summaryTab.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTab;

  /// No description provided for @deadlinesTab.
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get deadlinesTab;

  /// No description provided for @financialObligationsTab.
  ///
  /// In en, this message translates to:
  /// **'Financial Obligations'**
  String get financialObligationsTab;

  /// No description provided for @keyClausesTab.
  ///
  /// In en, this message translates to:
  /// **'Key Clauses'**
  String get keyClausesTab;

  /// No description provided for @redFlagsTab.
  ///
  /// In en, this message translates to:
  /// **'Red Flags'**
  String get redFlagsTab;

  /// No description provided for @customTextTab.
  ///
  /// In en, this message translates to:
  /// **'Custom Text'**
  String get customTextTab;

  /// No description provided for @sourceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Source Language'**
  String get sourceLanguage;

  /// No description provided for @targetLanguage.
  ///
  /// In en, this message translates to:
  /// **'Target Language'**
  String get targetLanguage;

  /// No description provided for @matchDocumentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Match document language'**
  String get matchDocumentLanguage;

  /// No description provided for @alwaysArabic.
  ///
  /// In en, this message translates to:
  /// **'Always Arabic'**
  String get alwaysArabic;

  /// No description provided for @alwaysEnglish.
  ///
  /// In en, this message translates to:
  /// **'Always English'**
  String get alwaysEnglish;

  /// No description provided for @documentAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Document Analysis'**
  String get documentAnalysis;

  /// No description provided for @loadingAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Loading analysis...'**
  String get loadingAnalysis;

  /// No description provided for @documentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Document not found'**
  String get documentNotFound;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'Delete account permanently?'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountWarningDescription.
  ///
  /// In en, this message translates to:
  /// **'This will delete your personal account and all documents, checklists, and data permanently and cannot be recovered.'**
  String get deleteAccountWarningDescription;

  /// No description provided for @confirmDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete my account permanently'**
  String get confirmDeleteAccount;

  /// No description provided for @deletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account...'**
  String get deletingAccount;

  /// No description provided for @deletingAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Your documents and personal data are being removed from your workspace.'**
  String get deletingAccountDescription;

  /// No description provided for @linkedToGoogle.
  ///
  /// In en, this message translates to:
  /// **'Linked to Google Account'**
  String get linkedToGoogle;

  /// No description provided for @uploadStep1of2.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get uploadStep1of2;

  /// No description provided for @uploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadTitle;

  /// No description provided for @selectFileToAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Select a file to analyze'**
  String get selectFileToAnalyze;

  /// No description provided for @extractDeadlinesEligibility.
  ///
  /// In en, this message translates to:
  /// **'Wara2tak extracts deadlines, eligibility criteria, and required documents directly from the opportunity announcement.'**
  String get extractDeadlinesEligibility;

  /// No description provided for @browsePDFs.
  ///
  /// In en, this message translates to:
  /// **'Browse PDF Files'**
  String get browsePDFs;

  /// No description provided for @chooseGuideOrInvitation.
  ///
  /// In en, this message translates to:
  /// **'Choose the official guide, publications, or invitation letter'**
  String get chooseGuideOrInvitation;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'From Gallery'**
  String get fromGallery;

  /// No description provided for @chooseScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Choose screenshots, saved announcement images, and posters'**
  String get chooseScreenshots;

  /// No description provided for @scanPaper.
  ///
  /// In en, this message translates to:
  /// **'Scan Paper'**
  String get scanPaper;

  /// No description provided for @useCameraForPaper.
  ///
  /// In en, this message translates to:
  /// **'Use camera to scan paper announcements and printed flyers'**
  String get useCameraForPaper;

  /// No description provided for @supportedFormatsList.
  ///
  /// In en, this message translates to:
  /// **'Supported formats:'**
  String get supportedFormatsList;

  /// No description provided for @clearDocumentsGiveBetterResults.
  ///
  /// In en, this message translates to:
  /// **'Clear, high-contrast documents yield more accurate results. Maximum file size and page count limits apply.'**
  String get clearDocumentsGiveBetterResults;

  /// No description provided for @noPersonalRecords.
  ///
  /// In en, this message translates to:
  /// **'Do not upload passports, ID cards, or personal records. Upload opportunity announcements only.'**
  String get noPersonalRecords;

  /// No description provided for @fileSelected.
  ///
  /// In en, this message translates to:
  /// **'{fileName} selected'**
  String fileSelected(Object fileName);

  /// No description provided for @pdfFile.
  ///
  /// In en, this message translates to:
  /// **'PDF File'**
  String get pdfFile;

  /// No description provided for @imageFileSelected.
  ///
  /// In en, this message translates to:
  /// **'Image File'**
  String get imageFileSelected;

  /// No description provided for @removeFile.
  ///
  /// In en, this message translates to:
  /// **'Remove file'**
  String get removeFile;

  /// No description provided for @selectDocumentType.
  ///
  /// In en, this message translates to:
  /// **'Select document type'**
  String get selectDocumentType;

  /// No description provided for @documentTypeRental.
  ///
  /// In en, this message translates to:
  /// **'Rental Contract'**
  String get documentTypeRental;

  /// No description provided for @documentTypeEmployment.
  ///
  /// In en, this message translates to:
  /// **'Employment Contract'**
  String get documentTypeEmployment;

  /// No description provided for @documentTypeTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get documentTypeTerms;

  /// No description provided for @documentTypePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get documentTypePrivacy;

  /// No description provided for @documentTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get documentTypeOther;

  /// No description provided for @uploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload & Analyze'**
  String get uploadButton;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @analysisComplete.
  ///
  /// In en, this message translates to:
  /// **'Analysis complete'**
  String get analysisComplete;

  /// No description provided for @analysisError.
  ///
  /// In en, this message translates to:
  /// **'Analysis error'**
  String get analysisError;

  /// No description provided for @checklistProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get checklistProgress;

  /// No description provided for @checklistCompletedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {total}'**
  String checklistCompletedOfTotal(Object completed, Object total);

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitle;

  /// No description provided for @taskDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get taskDescription;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority (1-5, optional)'**
  String get priority;

  /// No description provided for @dueDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Set Due Date (optional)'**
  String get dueDateOptional;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @deleteTaskConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteTaskConfirmation(Object title);

  /// No description provided for @beforeSigning.
  ///
  /// In en, this message translates to:
  /// **'Before Signing'**
  String get beforeSigning;

  /// No description provided for @afterSigning.
  ///
  /// In en, this message translates to:
  /// **'After Signing'**
  String get afterSigning;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @financial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get financial;

  /// No description provided for @otherCategory.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherCategory;

  /// No description provided for @fromDocument.
  ///
  /// In en, this message translates to:
  /// **'From Document'**
  String get fromDocument;

  /// No description provided for @personalTasks.
  ///
  /// In en, this message translates to:
  /// **'Personal Tasks'**
  String get personalTasks;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String page(Object number);

  /// No description provided for @completedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @overdueStatus.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdueStatus;

  /// No description provided for @loadingChecklist.
  ///
  /// In en, this message translates to:
  /// **'Loading checklist...'**
  String get loadingChecklist;

  /// No description provided for @failedToLoadChecklist.
  ///
  /// In en, this message translates to:
  /// **'Failed to load checklist'**
  String get failedToLoadChecklist;

  /// No description provided for @noChecklistItems.
  ///
  /// In en, this message translates to:
  /// **'No checklist items'**
  String get noChecklistItems;

  /// No description provided for @tasksGeneratedFromAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Tasks will be generated from document analysis'**
  String get tasksGeneratedFromAnalysis;

  /// No description provided for @reviewDocumentSummary.
  ///
  /// In en, this message translates to:
  /// **'Review Document Summary'**
  String get reviewDocumentSummary;

  /// No description provided for @interactiveChecklist.
  ///
  /// In en, this message translates to:
  /// **'Interactive Checklist'**
  String get interactiveChecklist;

  /// No description provided for @itemsReady.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} items ready'**
  String itemsReady(Object count, Object total);

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @documentsStayPrivate.
  ///
  /// In en, this message translates to:
  /// **'Your documents stay saved in your private space only.'**
  String get documentsStayPrivate;

  /// No description provided for @opportunitiesClearAndUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Your academic opportunities, clear and understood.'**
  String get opportunitiesClearAndUnderstood;

  /// No description provided for @uploadGrantDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload grant, internship, or exchange documents and let AI extract what matters to you.'**
  String get uploadGrantDocuments;

  /// No description provided for @prepareYourWorkspace.
  ///
  /// In en, this message translates to:
  /// **'PREPARING YOUR WORKSPACE'**
  String get prepareYourWorkspace;

  /// No description provided for @getStartedNow.
  ///
  /// In en, this message translates to:
  /// **'Get Started Now'**
  String get getStartedNow;

  /// No description provided for @errorScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorScreenTitle;

  /// No description provided for @errorScreenMessage.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get errorScreenMessage;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @documentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get documentTypeLabel;

  /// No description provided for @documentStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get documentStatus;

  /// No description provided for @analyzedOn.
  ///
  /// In en, this message translates to:
  /// **'Analyzed on {date} • {pages} pages'**
  String analyzedOn(Object date, Object pages);

  /// No description provided for @readyForReview.
  ///
  /// In en, this message translates to:
  /// **'Ready for review'**
  String get readyForReview;

  /// No description provided for @analyzingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} analyzing'**
  String analyzingCount(Object count);

  /// No description provided for @pageNumber.
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String pageNumber(Object number);

  /// No description provided for @amountCurrency.
  ///
  /// In en, this message translates to:
  /// **'{currency} {amount}'**
  String amountCurrency(Object amount, Object currency);

  /// No description provided for @financialTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get financialTitle;

  /// No description provided for @deadlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadlineTitle;

  /// No description provided for @clauseTitle.
  ///
  /// In en, this message translates to:
  /// **'Clause'**
  String get clauseTitle;

  /// No description provided for @redFlagTitle.
  ///
  /// In en, this message translates to:
  /// **'Red Flag'**
  String get redFlagTitle;

  /// No description provided for @checklistItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Checklist Item'**
  String get checklistItemTitle;

  /// No description provided for @chatMessage.
  ///
  /// In en, this message translates to:
  /// **'Chat Message'**
  String get chatMessage;

  /// No description provided for @translationContent.
  ///
  /// In en, this message translates to:
  /// **'Translation Content'**
  String get translationContent;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No items to display'**
  String get emptyStateSubtitle;

  /// No description provided for @actionRequired.
  ///
  /// In en, this message translates to:
  /// **'Action required'**
  String get actionRequired;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @deselect.
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get deselect;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @filterHint.
  ///
  /// In en, this message translates to:
  /// **'Filter...'**
  String get filterHint;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortAscending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sortAscending;

  /// No description provided for @sortDescending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get sortDescending;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'MM/dd/yyyy'**
  String get dateFormat;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'HH:mm'**
  String get timeFormat;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// No description provided for @languagePersian.
  ///
  /// In en, this message translates to:
  /// **'Persian'**
  String get languagePersian;

  /// No description provided for @selectAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select App Language'**
  String get selectAppLanguage;

  /// No description provided for @selectTranslationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Translation Language'**
  String get selectTranslationLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @updatePersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInformation;

  /// No description provided for @permanentlyDeleteAccountData.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and data'**
  String get permanentlyDeleteAccountData;

  /// No description provided for @learnHowWeProtectData.
  ///
  /// In en, this message translates to:
  /// **'Learn how we protect your data'**
  String get learnHowWeProtectData;

  /// No description provided for @getHelpContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Get help or contact support'**
  String get getHelpContactSupport;

  /// No description provided for @homeScreenTagline.
  ///
  /// In en, this message translates to:
  /// **'Understand every document. Plan your next step.'**
  String get homeScreenTagline;

  /// No description provided for @previewScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Document preview'**
  String get previewScreenTitle;

  /// No description provided for @previewScreenDescription.
  ///
  /// In en, this message translates to:
  /// **'The document preview and confirmation options will appear here.'**
  String get previewScreenDescription;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @failedToPickFile.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t select the file. Please try again.'**
  String get failedToPickFile;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t select the image. Please try again.'**
  String get failedToPickImage;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your profile'**
  String get failedToLoadProfile;

  /// No description provided for @loadingDocument.
  ///
  /// In en, this message translates to:
  /// **'Loading document...'**
  String get loadingDocument;

  /// No description provided for @failedToLoadDocument.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the document'**
  String get failedToLoadDocument;

  /// No description provided for @noKeyClausesFound.
  ///
  /// In en, this message translates to:
  /// **'No key clauses found'**
  String get noKeyClausesFound;

  /// No description provided for @noKeyClausesDescription.
  ///
  /// In en, this message translates to:
  /// **'The analysis did not identify any key clauses.'**
  String get noKeyClausesDescription;

  /// No description provided for @noDeadlinesFound.
  ///
  /// In en, this message translates to:
  /// **'No deadlines found'**
  String get noDeadlinesFound;

  /// No description provided for @noDeadlinesDescription.
  ///
  /// In en, this message translates to:
  /// **'The analysis did not identify any deadlines.'**
  String get noDeadlinesDescription;

  /// No description provided for @noFinancialObligationsFound.
  ///
  /// In en, this message translates to:
  /// **'No financial obligations found'**
  String get noFinancialObligationsFound;

  /// No description provided for @noFinancialObligationsDescription.
  ///
  /// In en, this message translates to:
  /// **'The analysis did not identify any financial obligations.'**
  String get noFinancialObligationsDescription;

  /// No description provided for @viewChecklistItems.
  ///
  /// In en, this message translates to:
  /// **'View items ({count})'**
  String viewChecklistItems(Object count);

  /// No description provided for @priorityLevel.
  ///
  /// In en, this message translates to:
  /// **'Priority {priority}'**
  String priorityLevel(Object priority);

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String sourceLabel(Object source);

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @selectFileFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a file first'**
  String get selectFileFirst;

  /// No description provided for @signInFirst.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first'**
  String get signInFirst;

  /// No description provided for @uploadedOn.
  ///
  /// In en, this message translates to:
  /// **'Uploaded on {date} • {pages} pages'**
  String uploadedOn(Object date, Object pages);

  /// No description provided for @readingFile.
  ///
  /// In en, this message translates to:
  /// **'Reading file...'**
  String get readingFile;

  /// No description provided for @preparingAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Preparing analysis...'**
  String get preparingAnalysis;

  /// No description provided for @processingAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Processing analysis results...'**
  String get processingAnalysis;

  /// No description provided for @savingResults.
  ///
  /// In en, this message translates to:
  /// **'Saving results...'**
  String get savingResults;

  /// No description provided for @reviewPrefix.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewPrefix;

  /// No description provided for @chatPlaceholderResponse.
  ///
  /// In en, this message translates to:
  /// **'This is a temporary response. The live AI response will be available once the chat service is connected.'**
  String get chatPlaceholderResponse;

  /// No description provided for @importanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Importance: {importance}'**
  String importanceLabel(Object importance);

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity: {severity}'**
  String severityLabel(Object severity);

  /// No description provided for @noDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get noDueDate;

  /// No description provided for @frequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'monthly'**
  String get frequencyMonthly;

  /// No description provided for @frequencyQuarterly.
  ///
  /// In en, this message translates to:
  /// **'quarterly'**
  String get frequencyQuarterly;

  /// No description provided for @frequencyYearly.
  ///
  /// In en, this message translates to:
  /// **'yearly'**
  String get frequencyYearly;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
