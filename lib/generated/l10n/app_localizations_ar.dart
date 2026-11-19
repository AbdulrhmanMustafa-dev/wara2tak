// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ورقتك';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToAnalyze => 'سجّل دخولك لتحليل مستنداتك بالذكاء الاصطناعي';

  @override
  String get continueWithGoogle => 'متابعة باستخدام Google';

  @override
  String get signingIn => 'جاري تسجيل الدخول...';

  @override
  String get byContinuing => 'بالمتابعة، فإنك توافق على ';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get and => ' و ';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get versionInfo => 'الإصدار 1.0.0+1';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get skip => 'تخطي';

  @override
  String get welcomeToWara2tak => 'مرحباً بك في ورقتك';

  @override
  String get onboardingDescription =>
      'ارفع مستندات المنح، التدريب، أو التبادل الطلابي ودع الذكاء الاصطناعي يستخرج ما يهمك.';

  @override
  String get aiDocumentIntelligence => 'ذكاء اصطناعي للمستندات';

  @override
  String get extractClausesFindDeadlines =>
      'استخراج الشروط • العثور على المواعيد • تخطيط التقديم';

  @override
  String get uploadDocument => 'رفع مستند';

  @override
  String get uploadAndAnalyze => 'رفع وتحليل';

  @override
  String get reviewDocument => 'مراجعة المستند';

  @override
  String get analyzingDocument => 'جاري تحليل المستند';

  @override
  String get analysisProgress => 'جاري التحليل...';

  @override
  String get analysisFailed => 'فشل التحليل';

  @override
  String get analysisErrorMessage =>
      'حدث خطأ أثناء التحليل. يرجى المحاولة مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get confirm => 'تأكيد';

  @override
  String get selectFile => 'اختر ملفاً';

  @override
  String get dragDropFileHere => 'اسحب وأفلت ملفاً هنا';

  @override
  String get orTapToBrowse => 'أو اضغط للتصفح';

  @override
  String get chooseFile => 'اختر ملف';

  @override
  String get cameraGallery => 'الكاميرا/المعرض';

  @override
  String get documentTitle => 'عنوان المستند';

  @override
  String get enterDocumentTitle => 'أدخل عنوان المستند';

  @override
  String get documentType => 'نوع المستند';

  @override
  String get supportedFormats =>
      'الصيغ المدعومة: PDF, PNG, JPG (الحد الأقصى 50 ميجابايت)';

  @override
  String get pdfDocument => 'ملف PDF';

  @override
  String get imageFile => 'ملف صورة';

  @override
  String get change => 'تغيير';

  @override
  String get analyzeNewDocument => 'تحليل مستند جديد';

  @override
  String get uploadDescription =>
      'ارفع ملف PDF أو صورة لاستخراج الشروط الرئيسية، المواعيد النهائية، والالتزامات المالية';

  @override
  String get recentDocuments => 'المستندات الأخيرة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get noDocumentsYet => 'لا توجد مستندات بعد';

  @override
  String get uploadFirstDocument => 'ارفع أول مستند لك للبدء';

  @override
  String get totalDocuments => 'إجمالي المستندات';

  @override
  String get analyzed => 'تم التحليل';

  @override
  String get processing => 'قيد المعالجة';

  @override
  String get myDocuments => 'مستنداتي';

  @override
  String get loadingDocuments => 'جاري تحميل المستندات...';

  @override
  String get failedToLoadDocuments => 'فشل تحميل المستندات';

  @override
  String get deleteDocumentTitle => 'حذف المستند';

  @override
  String deleteDocumentConfirmation(Object title) {
    return 'هل أنت متأكد من حذف \"$title\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get documentDeleted => 'تم حذف المستند بنجاح';

  @override
  String get documentUploaded => 'تم رفع المستند بنجاح!';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get toggleDarkLightTheme => 'التبديل بين الوضع الداكن والفاتح';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get enablePushNotifications => 'تفعيل إشعارات الدفع';

  @override
  String get language => 'اللغة';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get appLanguageSubtitle => 'اختر لغة واجهة التطبيق (العربية/English)';

  @override
  String get defaultTranslationLanguage => 'لغة الترجمة الافتراضية';

  @override
  String get defaultTranslationLanguageSubtitle =>
      'اللغة الهدف الافتراضية لترجمة المستندات';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get updatePersonalInfo => 'تحديث معلوماتك الشخصية';

  @override
  String get displayName => 'الاسم المعروض';

  @override
  String get security => 'الأمان';

  @override
  String get managePasswordBiometric => 'إدارة كلمة المرور والمصادقة الحيوية';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountConfirmation =>
      'لا يمكن التراجع عن هذا الإجراء. سيتم حذف جميع مستنداتك وتحليلاتك وبياناتك نهائياً.';

  @override
  String get deleteAccountPermanently => 'حذف حسابك وبياناتك نهائياً';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get termsOfServiceTitle => 'شروط الخدمة';

  @override
  String get readTermsConditions => 'اقرأ شروطنا وأحكامنا';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get learnDataProtection => 'تعرف على كيف نحمي بياناتك';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get getHelpContact => 'احصل على المساعدة أو تواصل مع الدعم';

  @override
  String get documentDetails => 'تفاصيل المستند';

  @override
  String get summary => 'الملخص';

  @override
  String get keyClauses => 'الشروط الرئيسية';

  @override
  String get deadlines => 'المواعيد النهائية';

  @override
  String get financials => 'الالتزامات المالية';

  @override
  String get aiSummary => 'ملخص الذكاء الاصطناعي';

  @override
  String get redFlags => 'الإشارات الحمراء';

  @override
  String get checklist => 'قائمة المهام';

  @override
  String get viewAllItems => 'عرض الكل';

  @override
  String get chat => 'الدردشة';

  @override
  String get translate => 'ترجمة';

  @override
  String get refresh => 'تحديث';

  @override
  String get pages => 'صفحات';

  @override
  String get size => 'الحجم';

  @override
  String get uploaded => 'تم الرفع';

  @override
  String get clauses => 'الشروط';

  @override
  String get financialObligations => 'الالتزامات المالية';

  @override
  String get statusAnalyzed => 'تم التحليل';

  @override
  String get statusAnalyzing => 'قيد التحليل';

  @override
  String get statusFailed => 'فشل';

  @override
  String get statusUploaded => 'تم الرفع';

  @override
  String get overdue => 'متأخر';

  @override
  String get completed => 'مكتمل';

  @override
  String dueDate(Object date) {
    return 'الموعد: $date';
  }

  @override
  String recurring(Object frequency) {
    return 'متكرر: $frequency';
  }

  @override
  String recommendation(Object recommendation) {
    return 'التوصية: $recommendation';
  }

  @override
  String get importanceCritical => 'حرج';

  @override
  String get importanceHigh => 'عالي';

  @override
  String get importanceMedium => 'متوسط';

  @override
  String get importanceLow => 'منخفض';

  @override
  String get severityCritical => 'حرج';

  @override
  String get severityHigh => 'عالي';

  @override
  String get severityMedium => 'متوسط';

  @override
  String get severityLow => 'منخفض';

  @override
  String get rentalContract => 'عقد إيجار';

  @override
  String get employmentContract => 'عقد عمل';

  @override
  String get termsOfServiceType => 'شروط الخدمة';

  @override
  String get privacyPolicyType => 'سياسة الخصوصية';

  @override
  String get otherType => 'أخرى';

  @override
  String get documentChat => 'دردشة المستند';

  @override
  String get askAboutDocument => 'اسأل عن المستند...';

  @override
  String get startConversation => 'ابدأ محادثة';

  @override
  String get askQuestionsAboutDocument =>
      'اسأل أسئلة عن مستندك. سيجيب الذكاء الاصطناعي بناءً على المحتوى المحلل.';

  @override
  String get suggestedQuestions => 'أسئلة مقترحة';

  @override
  String get keyDeadlinesQuestion => 'ما هي المواعيد النهائية الرئيسية؟';

  @override
  String get documentsToPrepareQuestion =>
      'ما هي المستندات التي أحتاج لتحضيرها؟';

  @override
  String get terminationConditionsQuestion => 'ما هي شروط الإنهاء؟';

  @override
  String get penaltiesFeesQuestion => 'هل هناك غرامات أو رسوم؟';

  @override
  String get summarizeFinancialsQuestion => 'لخص الالتزامات المالية.';

  @override
  String get thinking => 'جاري التفكير...';

  @override
  String get clearConversation => 'مسح المحادثة';

  @override
  String get clearConversationConfirmation =>
      'هل أنت متأكد من حذف جميع الرسائل؟ لا يمكن التراجع عن ذلك.';

  @override
  String get translation => 'ترجمة';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get textToTranslate => 'النص المراد ترجمته';

  @override
  String get enterTextToTranslate => 'أدخل النص المراد ترجمته...';

  @override
  String originalContent(Object language) {
    return 'الأصلي ($language)';
  }

  @override
  String translationResult(Object language) {
    return 'الترجمة ($language)';
  }

  @override
  String get copy => 'نسخ';

  @override
  String get translationCopied => 'تم نسخ الترجمة إلى الحافظة';

  @override
  String get noContentToTranslate => 'لا يوجد محتوى للترجمة';

  @override
  String get analysisHasNoContent => 'التحليل لا يحتوي على محتوى لهذا القسم';

  @override
  String get summaryTab => 'الملخص';

  @override
  String get deadlinesTab => 'المواعيد النهائية';

  @override
  String get financialObligationsTab => 'الالتزامات المالية';

  @override
  String get keyClausesTab => 'الشروط الرئيسية';

  @override
  String get redFlagsTab => 'الإشارات الحمراء';

  @override
  String get customTextTab => 'نص مخصص';

  @override
  String get sourceLanguage => 'اللغة المصدر';

  @override
  String get targetLanguage => 'اللغة الهدف';

  @override
  String get matchDocumentLanguage => 'مطابقة لغة المستند';

  @override
  String get alwaysArabic => 'العربية دائماً';

  @override
  String get alwaysEnglish => 'الإنجليزية دائماً';

  @override
  String get documentAnalysis => 'تحليل المستند';

  @override
  String get loadingAnalysis => 'جاري تحميل التحليل...';

  @override
  String get documentNotFound => 'المستند غير موجود';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get settings => 'الإعدادات';

  @override
  String get home => 'الرئيسية';

  @override
  String get documents => 'المستندات';

  @override
  String get upload => 'رفع';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get moreOptions => 'خيارات إضافية';

  @override
  String get deleteAccountWarning => 'حذف الحساب نهائياً؟';

  @override
  String get deleteAccountWarningDescription =>
      'سيؤدي هذا إلى حذف حسابك الشخصي وجميع المستندات، قوائم المهام، والبيانات بشكل نهائي ولا يمكن استرجاعها.';

  @override
  String get confirmDeleteAccount => 'تأكيد حذف حسابي نهائياً';

  @override
  String get deletingAccount => 'جاري حذف حسابك...';

  @override
  String get deletingAccountDescription =>
      'يتم الآن مسح مستنداتك وبياناتك الشخصية من مساحة عملك.';

  @override
  String get linkedToGoogle => 'مرتبط بحساب Google';

  @override
  String get uploadStep1of2 => 'الخطوة 1 من 2';

  @override
  String get uploadTitle => 'رفع مستند';

  @override
  String get selectFileToAnalyze => 'اختر ملفاً لتحليله';

  @override
  String get extractDeadlinesEligibility =>
      'يقوم ورقتك باستخراج المواعيد النهائية، وشروط الأهلية، والمستندات المطلوبة للتقديم مباشرة من إعلان الفرصة.';

  @override
  String get browsePDFs => 'تصفح ملفات PDF';

  @override
  String get chooseGuideOrInvitation =>
      'اختر الدليل الإرشادي الرسمي، أو المنشورات، أو دعوة التقديم';

  @override
  String get fromGallery => 'من المعرض';

  @override
  String get chooseScreenshots =>
      'اختر لقطات الشاشة، أو صور الإعلانات والملصقات المحفوظة';

  @override
  String get scanPaper => 'مسح ضوئي ورقي';

  @override
  String get useCameraForPaper =>
      'استخدم الكاميرا لمسح الإعلانات الورقية والمطويات المطبوعة';

  @override
  String get supportedFormatsList => 'الصيغ المدعومة:';

  @override
  String get clearDocumentsGiveBetterResults =>
      'المستندات الواضحة وعالية التباين تمنح نتائج أكثر دقة. يُطبَّق حد أقصى لحجم الملف وعدد الصفحات.';

  @override
  String get noPersonalRecords =>
      'لا ترفع جوازات السفر أو بطاقات الهوية أو أي سجلات شخصية. ارفع إعلانات الفرص فقط.';

  @override
  String fileSelected(Object fileName) {
    return 'تم اختيار $fileName';
  }

  @override
  String get pdfFile => 'ملف PDF';

  @override
  String get imageFileSelected => 'ملف صورة';

  @override
  String get removeFile => 'إزالة الملف';

  @override
  String get selectDocumentType => 'اختر نوع المستند';

  @override
  String get documentTypeRental => 'عقد إيجار';

  @override
  String get documentTypeEmployment => 'عقد عمل';

  @override
  String get documentTypeTerms => 'شروط الخدمة';

  @override
  String get documentTypePrivacy => 'سياسة الخصوصية';

  @override
  String get documentTypeOther => 'أخرى';

  @override
  String get uploadButton => 'رفع وتحليل';

  @override
  String get uploading => 'جاري الرفع...';

  @override
  String get analyzing => 'جاري التحليل...';

  @override
  String get analysisComplete => 'اكتمل التحليل';

  @override
  String get analysisError => 'خطأ في التحليل';

  @override
  String get checklistProgress => 'التقدم';

  @override
  String checklistCompletedOfTotal(Object completed, Object total) {
    return '$completed / $total';
  }

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get taskTitle => 'عنوان المهمة';

  @override
  String get taskDescription => 'الوصف (اختياري)';

  @override
  String get category => 'الفئة';

  @override
  String get priority => 'الأولوية (1-5، اختياري)';

  @override
  String get dueDateOptional => 'تعيين تاريخ الاستحقاق (اختياري)';

  @override
  String get add => 'إضافة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String deleteTaskConfirmation(Object title) {
    return 'هل أنت متأكد من حذف \"$title\"؟';
  }

  @override
  String get beforeSigning => 'قبل التوقيع';

  @override
  String get afterSigning => 'بعد التوقيع';

  @override
  String get ongoing => 'مستمر';

  @override
  String get legal => 'قانوني';

  @override
  String get financial => 'مالي';

  @override
  String get otherCategory => 'أخرى';

  @override
  String get fromDocument => 'من المستند';

  @override
  String get personalTasks => 'مهام شخصية';

  @override
  String page(Object number) {
    return 'صفحة $number';
  }

  @override
  String get completedStatus => 'مكتمل';

  @override
  String get pendingStatus => 'قيد الانتظار';

  @override
  String get overdueStatus => 'متأخر';

  @override
  String get loadingChecklist => 'جاري تحميل قائمة المهام...';

  @override
  String get failedToLoadChecklist => 'فشل تحميل قائمة المهام';

  @override
  String get noChecklistItems => 'لا توجد مهام في القائمة';

  @override
  String get tasksGeneratedFromAnalysis => 'سيتم إنشاء المهام من تحليل المستند';

  @override
  String get reviewDocumentSummary => 'مراجعة ملخص المستند';

  @override
  String get interactiveChecklist => 'قائمة مهام تفاعلية';

  @override
  String itemsReady(Object count, Object total) {
    return '$count من $total عناصر جاهزة';
  }

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get documentsStayPrivate =>
      'تبقى مستنداتك محفوظة في مساحتك الخاصة فقط.';

  @override
  String get opportunitiesClearAndUnderstood =>
      'فرصك الأكاديمية، واضحة ومفهومة.';

  @override
  String get uploadGrantDocuments =>
      'ارفع مستندات المنح، التدريب، أو التبادل الطلابي ودع الذكاء الاصطناعي يستخرج ما يهمك.';

  @override
  String get prepareYourWorkspace => 'جاري تجهيز مساحة عملك';

  @override
  String get getStartedNow => 'ابدأ الآن';

  @override
  String get errorScreenTitle => 'حدث خطأ ما';

  @override
  String get errorScreenMessage => 'خطأ غير معروف';

  @override
  String get goHome => 'العودة للرئيسية';

  @override
  String get documentTypeLabel => 'النوع';

  @override
  String get documentStatus => 'الحالة';

  @override
  String analyzedOn(Object date, Object pages) {
    return 'تم التحليل في $date • $pages صفحات';
  }

  @override
  String get readyForReview => 'جاهز للمراجعة';

  @override
  String analyzingCount(Object count) {
    return '$count قيد التحليل';
  }

  @override
  String pageNumber(Object number) {
    return 'صفحة $number';
  }

  @override
  String amountCurrency(Object amount, Object currency) {
    return '$currency $amount';
  }

  @override
  String get financialTitle => 'مالي';

  @override
  String get deadlineTitle => 'موعد نهائي';

  @override
  String get clauseTitle => 'شرط';

  @override
  String get redFlagTitle => 'إشارة حمراء';

  @override
  String get checklistItemTitle => 'عنصر مهمة';

  @override
  String get chatMessage => 'رسالة دردشة';

  @override
  String get translationContent => 'محتوى الترجمة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get emptyStateTitle => 'لا يوجد شيء هنا بعد';

  @override
  String get emptyStateSubtitle => 'لا توجد عناصر للعرض';

  @override
  String get actionRequired => 'الإجراء مطلوب';

  @override
  String get optional => 'اختياري';

  @override
  String get required => 'مطلوب';

  @override
  String get success => 'نجاح';

  @override
  String get warning => 'تحذير';

  @override
  String get error => 'خطأ';

  @override
  String get info => 'معلومة';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get ok => 'موافق';

  @override
  String get apply => 'تطبيق';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get clear => 'مسح';

  @override
  String get select => 'اختيار';

  @override
  String get deselect => 'إلغاء الاختيار';

  @override
  String get all => 'الكل';

  @override
  String get none => 'لا شيء';

  @override
  String get searchHint => 'بحث...';

  @override
  String get filterHint => 'تصفية...';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get sortAscending => 'تصاعدي';

  @override
  String get sortDescending => 'تنازلي';

  @override
  String get dateFormat => 'dd/MM/yyyy';

  @override
  String get timeFormat => 'HH:mm';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageChinese => '中文';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get selectAppLanguage => 'اختر لغة التطبيق';

  @override
  String get selectTranslationLanguage => 'اختر لغة الترجمة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get account => 'الحساب';

  @override
  String get updatePersonalInformation => 'تحديث معلوماتك الشخصية';

  @override
  String get permanentlyDeleteAccountData => 'حذف حسابك وبياناتك نهائياً';

  @override
  String get learnHowWeProtectData => 'تعرف على كيفية حماية بياناتك';

  @override
  String get getHelpContactSupport => 'احصل على المساعدة أو تواصل مع الدعم';

  @override
  String get homeScreenTagline => 'افهم كل مستند، وخطط لخطوتك التالية.';

  @override
  String get previewScreenTitle => 'معاينة المستند';

  @override
  String get previewScreenDescription =>
      'ستظهر هنا معاينة المستند وخيارات تأكيده.';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get failedToPickFile => 'تعذّر اختيار الملف. حاول مرة أخرى.';

  @override
  String get failedToPickImage => 'تعذّر اختيار الصورة. حاول مرة أخرى.';

  @override
  String get loadingProfile => 'جارٍ تحميل الملف الشخصي...';

  @override
  String get failedToLoadProfile => 'تعذّر تحميل الملف الشخصي';

  @override
  String get loadingDocument => 'جارٍ تحميل المستند...';

  @override
  String get failedToLoadDocument => 'تعذّر تحميل المستند';

  @override
  String get noKeyClausesFound => 'لم يتم العثور على شروط رئيسية';

  @override
  String get noKeyClausesDescription => 'لم يحدد التحليل أي شروط رئيسية.';

  @override
  String get noDeadlinesFound => 'لم يتم العثور على مواعيد نهائية';

  @override
  String get noDeadlinesDescription => 'لم يحدد التحليل أي مواعيد نهائية.';

  @override
  String get noFinancialObligationsFound => 'لا توجد التزامات مالية';

  @override
  String get noFinancialObligationsDescription =>
      'لم يحدد التحليل أي التزامات مالية.';

  @override
  String viewChecklistItems(Object count) {
    return 'عرض العناصر ($count)';
  }

  @override
  String priorityLevel(Object priority) {
    return 'الأولوية $priority';
  }

  @override
  String sourceLabel(Object source) {
    return 'المصدر: $source';
  }

  @override
  String get user => 'مستخدم';

  @override
  String get selectFileFirst => 'اختر ملفاً أولاً';

  @override
  String get signInFirst => 'سجّل الدخول أولاً';

  @override
  String uploadedOn(Object date, Object pages) {
    return 'تم الرفع في $date • $pages صفحات';
  }

  @override
  String get readingFile => 'جارٍ قراءة الملف...';

  @override
  String get preparingAnalysis => 'جارٍ تجهيز التحليل...';

  @override
  String get processingAnalysis => 'جارٍ معالجة نتائج التحليل...';

  @override
  String get savingResults => 'جارٍ حفظ النتائج...';

  @override
  String get reviewPrefix => 'مراجعة';

  @override
  String get chatPlaceholderResponse =>
      'هذه إجابة مؤقتة. ستظهر إجابة الذكاء الاصطناعي الفعلية عند ربط خدمة الدردشة.';

  @override
  String importanceLabel(Object importance) {
    return 'الأهمية: $importance';
  }

  @override
  String severityLabel(Object severity) {
    return 'مستوى الخطورة: $severity';
  }

  @override
  String get noDueDate => 'دون موعد استحقاق';

  @override
  String get frequencyMonthly => 'شهرياً';

  @override
  String get frequencyQuarterly => 'كل ثلاثة أشهر';

  @override
  String get frequencyYearly => 'سنوياً';
}
