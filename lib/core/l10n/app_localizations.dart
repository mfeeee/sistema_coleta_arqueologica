import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
    Locale('pt'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginTitle;

  /// No description provided for @loginSystemTitle.
  ///
  /// In pt, this message translates to:
  /// **'Acesso ao Sistema'**
  String get loginSystemTitle;

  /// No description provided for @loginPlatformDesc.
  ///
  /// In pt, this message translates to:
  /// **'Plataforma de Coleta de Dados Arqueológicos'**
  String get loginPlatformDesc;

  /// No description provided for @loginEmailLabel.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In pt, this message translates to:
  /// **'exemplo@arqueo.org'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua senha'**
  String get loginPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @loginCreateAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar Conta'**
  String get loginCreateAccount;

  /// No description provided for @loginForgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueceu sua senha?'**
  String get loginForgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In pt, this message translates to:
  /// **'Não tem uma conta? Cadastre-se'**
  String get loginNoAccount;

  /// No description provided for @loginEmailRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu e-mail'**
  String get loginEmailRequired;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe sua senha'**
  String get loginPasswordRequired;

  /// No description provided for @registerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar Conta'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Junte-se à nossa comunidade de exploração arqueológica.'**
  String get registerSubtitle;

  /// No description provided for @registerFullName.
  ///
  /// In pt, this message translates to:
  /// **'Nome Completo'**
  String get registerFullName;

  /// No description provided for @registerFullNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite seu nome completo'**
  String get registerFullNameHint;

  /// No description provided for @registerFullNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu nome'**
  String get registerFullNameRequired;

  /// No description provided for @registerEmailHint.
  ///
  /// In pt, this message translates to:
  /// **'exemplo@instituicao.br'**
  String get registerEmailHint;

  /// No description provided for @registerClassification.
  ///
  /// In pt, this message translates to:
  /// **'Classificação'**
  String get registerClassification;

  /// No description provided for @registerClassificationHint.
  ///
  /// In pt, this message translates to:
  /// **'Selecione seu perfil'**
  String get registerClassificationHint;

  /// No description provided for @registerClassStudent.
  ///
  /// In pt, this message translates to:
  /// **'Estudante'**
  String get registerClassStudent;

  /// No description provided for @registerClassTeacher.
  ///
  /// In pt, this message translates to:
  /// **'Professor'**
  String get registerClassTeacher;

  /// No description provided for @registerClassArchaeologist.
  ///
  /// In pt, this message translates to:
  /// **'Arqueólogo'**
  String get registerClassArchaeologist;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In pt, this message translates to:
  /// **'Crie uma senha'**
  String get registerPasswordHint;

  /// No description provided for @registerPasswordMin.
  ///
  /// In pt, this message translates to:
  /// **'Mínimo 8 caracteres'**
  String get registerPasswordMin;

  /// No description provided for @registerConfirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Senha'**
  String get registerConfirmPassword;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In pt, this message translates to:
  /// **'Repita a senha'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerPasswordMismatch.
  ///
  /// In pt, this message translates to:
  /// **'Senhas não coincidem'**
  String get registerPasswordMismatch;

  /// No description provided for @registerButton.
  ///
  /// In pt, this message translates to:
  /// **'Criar Conta'**
  String get registerButton;

  /// No description provided for @registerHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Já tenho uma conta, entrar'**
  String get registerHaveAccount;

  /// No description provided for @registerTermsText.
  ///
  /// In pt, this message translates to:
  /// **'Ao se cadastrar, você concorda com nossos'**
  String get registerTermsText;

  /// No description provided for @registerTermsService.
  ///
  /// In pt, this message translates to:
  /// **'Termos de Serviço'**
  String get registerTermsService;

  /// No description provided for @registerTermsAnd.
  ///
  /// In pt, this message translates to:
  /// **'e'**
  String get registerTermsAnd;

  /// No description provided for @registerPrivacyPolicy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get registerPrivacyPolicy;

  /// No description provided for @recoverPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Recuperar Senha'**
  String get recoverPasswordTitle;

  /// No description provided for @recoverPasswordSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Insira o e-mail cadastrado para receber as instruções de recuperação.'**
  String get recoverPasswordSubtitle;

  /// No description provided for @recoverPasswordEmailSent.
  ///
  /// In pt, this message translates to:
  /// **'E-mail Enviado'**
  String get recoverPasswordEmailSent;

  /// No description provided for @recoverPasswordEmailSentDesc.
  ///
  /// In pt, this message translates to:
  /// **'Verifique seu e-mail para redefinir a senha.'**
  String get recoverPasswordEmailSentDesc;

  /// No description provided for @recoverPasswordBackToLogin.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao Login'**
  String get recoverPasswordBackToLogin;

  /// No description provided for @recoverPasswordEnterCode.
  ///
  /// In pt, this message translates to:
  /// **'Inserir Código'**
  String get recoverPasswordEnterCode;

  /// No description provided for @recoverPasswordSendLink.
  ///
  /// In pt, this message translates to:
  /// **'Enviar Link'**
  String get recoverPasswordSendLink;

  /// No description provided for @recoverPasswordRemember.
  ///
  /// In pt, this message translates to:
  /// **'Lembrou sua senha?'**
  String get recoverPasswordRemember;

  /// No description provided for @recoverPasswordDoLogin.
  ///
  /// In pt, this message translates to:
  /// **'Fazer login'**
  String get recoverPasswordDoLogin;

  /// No description provided for @homeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In pt, this message translates to:
  /// **'Olá, {nome}'**
  String homeGreeting(String nome);

  /// No description provided for @homeResearcher.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisador'**
  String get homeResearcher;

  /// No description provided for @homeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Pronto para novas descobertas hoje?'**
  String get homeSubtitle;

  /// No description provided for @homeWelcome.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo(a)'**
  String get homeWelcome;

  /// No description provided for @homePendingBanner.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, one{{count} coleta aguardando envio} other{{count} coletas aguardando envio}}'**
  String homePendingBanner(int count);

  /// No description provided for @homeNewCollection.
  ///
  /// In pt, this message translates to:
  /// **'Nova Coleta'**
  String get homeNewCollection;

  /// No description provided for @homeViewCollections.
  ///
  /// In pt, this message translates to:
  /// **'Ver Minhas Coletas'**
  String get homeViewCollections;

  /// No description provided for @homeSyncNow.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizar Agora'**
  String get homeSyncNow;

  /// No description provided for @homeActivitySummary.
  ///
  /// In pt, this message translates to:
  /// **'Resumo das Atividades'**
  String get homeActivitySummary;

  /// No description provided for @homeTotal.
  ///
  /// In pt, this message translates to:
  /// **'TOTAL'**
  String get homeTotal;

  /// No description provided for @homePendingLabel.
  ///
  /// In pt, this message translates to:
  /// **'PENDENTES'**
  String get homePendingLabel;

  /// No description provided for @homeRecentActivities.
  ///
  /// In pt, this message translates to:
  /// **'Atividades Recentes'**
  String get homeRecentActivities;

  /// No description provided for @homeViewAll.
  ///
  /// In pt, this message translates to:
  /// **'Ver tudo'**
  String get homeViewAll;

  /// No description provided for @homeRecentCollections.
  ///
  /// In pt, this message translates to:
  /// **'Coletas Recentes'**
  String get homeRecentCollections;

  /// No description provided for @homeNoCollections.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma coleta registrada ainda.'**
  String get homeNoCollections;

  /// No description provided for @homeNoTitle.
  ///
  /// In pt, this message translates to:
  /// **'Coleta sem título'**
  String get homeNoTitle;

  /// No description provided for @homeTodayAt.
  ///
  /// In pt, this message translates to:
  /// **'Hoje, às {hora}'**
  String homeTodayAt(String hora);

  /// No description provided for @homeYesterdayAt.
  ///
  /// In pt, this message translates to:
  /// **'Ontem, às {hora}'**
  String homeYesterdayAt(String hora);

  /// No description provided for @coletaTitle.
  ///
  /// In pt, this message translates to:
  /// **'Coleta'**
  String get coletaTitle;

  /// No description provided for @coletaNewTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova Coleta'**
  String get coletaNewTitle;

  /// No description provided for @coletaEditTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar Coleta'**
  String get coletaEditTitle;

  /// No description provided for @coletaFieldLocation.
  ///
  /// In pt, this message translates to:
  /// **'Localização'**
  String get coletaFieldLocation;

  /// No description provided for @coletaFieldDate.
  ///
  /// In pt, this message translates to:
  /// **'Data'**
  String get coletaFieldDate;

  /// No description provided for @coletaFieldDescription.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get coletaFieldDescription;

  /// No description provided for @coletaSaveButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get coletaSaveButton;

  /// No description provided for @coletaCancelButton.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get coletaCancelButton;

  /// No description provided for @coletaDeleteButton.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get coletaDeleteButton;

  /// No description provided for @coletaDeleteConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja excluir esta coleta?'**
  String get coletaDeleteConfirm;

  /// No description provided for @coletaSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Coleta salva com sucesso!'**
  String get coletaSuccess;

  /// No description provided for @coletaStatusSincronizado.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizado'**
  String get coletaStatusSincronizado;

  /// No description provided for @coletaStatusNaoSincronizado.
  ///
  /// In pt, this message translates to:
  /// **'Não sincronizado'**
  String get coletaStatusNaoSincronizado;

  /// No description provided for @coletaStatusAprovado.
  ///
  /// In pt, this message translates to:
  /// **'Aprovado'**
  String get coletaStatusAprovado;

  /// No description provided for @coletaStatusRejeitado.
  ///
  /// In pt, this message translates to:
  /// **'Rejeitado'**
  String get coletaStatusRejeitado;

  /// No description provided for @coletaStatusRascunho.
  ///
  /// In pt, this message translates to:
  /// **'Rascunho'**
  String get coletaStatusRascunho;

  /// No description provided for @coletaStatusPendente.
  ///
  /// In pt, this message translates to:
  /// **'Pendente'**
  String get coletaStatusPendente;

  /// No description provided for @coletaDatePrefix.
  ///
  /// In pt, this message translates to:
  /// **'Coletado em: {date}'**
  String coletaDatePrefix(String date);

  /// No description provided for @coletaActionEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get coletaActionEdit;

  /// No description provided for @coletaActionSyncNow.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizar Agora'**
  String get coletaActionSyncNow;

  /// No description provided for @coletaActionViewDetails.
  ///
  /// In pt, this message translates to:
  /// **'Ver Detalhes'**
  String get coletaActionViewDetails;

  /// No description provided for @coletaActionContinueDraft.
  ///
  /// In pt, this message translates to:
  /// **'Continuar Rascunho'**
  String get coletaActionContinueDraft;

  /// No description provided for @coletaActionDeleteDraft.
  ///
  /// In pt, this message translates to:
  /// **'Excluir Rascunho'**
  String get coletaActionDeleteDraft;

  /// No description provided for @coletaActionDiscard.
  ///
  /// In pt, this message translates to:
  /// **'Descartar'**
  String get coletaActionDiscard;

  /// No description provided for @coletaActionContinueEditing.
  ///
  /// In pt, this message translates to:
  /// **'Continuar Editando'**
  String get coletaActionContinueEditing;

  /// No description provided for @coletaActionSaveDraft.
  ///
  /// In pt, this message translates to:
  /// **'Salvar Rascunho'**
  String get coletaActionSaveDraft;

  /// No description provided for @coletaActionFinish.
  ///
  /// In pt, this message translates to:
  /// **'Finalizar Coleta'**
  String get coletaActionFinish;

  /// No description provided for @coletaExitTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sair da Coleta?'**
  String get coletaExitTitle;

  /// No description provided for @coletaExitContent.
  ///
  /// In pt, this message translates to:
  /// **'Você tem alterações não salvas. Deseja salvar como rascunho ou descartar tudo?'**
  String get coletaExitContent;

  /// No description provided for @coletaDraftSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Rascunho salvo com sucesso.'**
  String get coletaDraftSuccess;

  /// No description provided for @coletaDraftError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar rascunho.'**
  String get coletaDraftError;

  /// No description provided for @coletaCoordsUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Coordenadas não disponíveis.'**
  String get coletaCoordsUnavailable;

  /// No description provided for @coletaFinishSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Coleta finalizada com sucesso! Pronta para envio.'**
  String get coletaFinishSuccess;

  /// No description provided for @coletaFinishError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao finalizar. Tente novamente.'**
  String get coletaFinishError;

  /// No description provided for @coletaOfflineBanner.
  ///
  /// In pt, this message translates to:
  /// **'Você está offline. A coleta será salva localmente.'**
  String get coletaOfflineBanner;

  /// No description provided for @coletaLoadingGps.
  ///
  /// In pt, this message translates to:
  /// **'Obtendo sua localização e verificando sítios próximos...'**
  String get coletaLoadingGps;

  /// No description provided for @coletaRetryGps.
  ///
  /// In pt, this message translates to:
  /// **'Tentar Novamente'**
  String get coletaRetryGps;

  /// No description provided for @coletaGrantPermission.
  ///
  /// In pt, this message translates to:
  /// **'Conceder Permissão'**
  String get coletaGrantPermission;

  /// No description provided for @coletaOpenAppSettings.
  ///
  /// In pt, this message translates to:
  /// **'Abrir Configurações do App'**
  String get coletaOpenAppSettings;

  /// No description provided for @coletaEnableLocation.
  ///
  /// In pt, this message translates to:
  /// **'Ativar Localização'**
  String get coletaEnableLocation;

  /// No description provided for @coletaRetakeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Retomar Coleta'**
  String get coletaRetakeTitle;

  /// No description provided for @coletaStepPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Passo {current} de {total}'**
  String coletaStepPrefix(int current, int total);

  /// No description provided for @coletaSectionAccess.
  ///
  /// In pt, this message translates to:
  /// **'Meios de Acesso'**
  String get coletaSectionAccess;

  /// No description provided for @coletaSectionVisuals.
  ///
  /// In pt, this message translates to:
  /// **'Evidências Visuais'**
  String get coletaSectionVisuals;

  /// No description provided for @coletaAudioBadge.
  ///
  /// In pt, this message translates to:
  /// **'ÁUDIO'**
  String get coletaAudioBadge;

  /// No description provided for @coletaCameraBadge.
  ///
  /// In pt, this message translates to:
  /// **'CÂMERA'**
  String get coletaCameraBadge;

  /// No description provided for @coletaAudioHint.
  ///
  /// In pt, this message translates to:
  /// **'Toque no microfone para descrever os meios de acesso.'**
  String get coletaAudioHint;

  /// No description provided for @coletaManualNotes.
  ///
  /// In pt, this message translates to:
  /// **'TRANSCRIÇÃO OU NOTAS MANUAIS (OPCIONAL)'**
  String get coletaManualNotes;

  /// No description provided for @coletaNotesHint.
  ///
  /// In pt, this message translates to:
  /// **'Insira notas adicionais sobre os meios de acesso...'**
  String get coletaNotesHint;

  /// No description provided for @coletaFinishBanner.
  ///
  /// In pt, this message translates to:
  /// **'A COLETA SERÁ SALVA LOCALMENTE E FICARÁ PENDENTE PARA SINCRONIZAÇÃO.'**
  String get coletaFinishBanner;

  /// No description provided for @coletaRecording.
  ///
  /// In pt, this message translates to:
  /// **'GRAVANDO...'**
  String get coletaRecording;

  /// No description provided for @coletaTapToRecord.
  ///
  /// In pt, this message translates to:
  /// **'TOQUE PARA GRAVAR'**
  String get coletaTapToRecord;

  /// No description provided for @coletaStopRecording.
  ///
  /// In pt, this message translates to:
  /// **'Parar gravação'**
  String get coletaStopRecording;

  /// No description provided for @coletaStartRecording.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar gravação de áudio'**
  String get coletaStartRecording;

  /// No description provided for @coletaGpsCoords.
  ///
  /// In pt, this message translates to:
  /// **'COORDENADAS GPS'**
  String get coletaGpsCoords;

  /// No description provided for @coletaLatitude.
  ///
  /// In pt, this message translates to:
  /// **'LATITUDE'**
  String get coletaLatitude;

  /// No description provided for @coletaLongitude.
  ///
  /// In pt, this message translates to:
  /// **'LONGITUDE'**
  String get coletaLongitude;

  /// No description provided for @coletaAssetLocation.
  ///
  /// In pt, this message translates to:
  /// **'LOCALIZAÇÃO DO BEM'**
  String get coletaAssetLocation;

  /// No description provided for @coletaAssetName.
  ///
  /// In pt, this message translates to:
  /// **'NOME DO BEM'**
  String get coletaAssetName;

  /// No description provided for @coletaPopularNames.
  ///
  /// In pt, this message translates to:
  /// **'NOMES POPULARES'**
  String get coletaPopularNames;

  /// No description provided for @coletaOptional.
  ///
  /// In pt, this message translates to:
  /// **'(opcional)'**
  String get coletaOptional;

  /// No description provided for @coletaNature.
  ///
  /// In pt, this message translates to:
  /// **'NATUREZA'**
  String get coletaNature;

  /// No description provided for @coletaType.
  ///
  /// In pt, this message translates to:
  /// **'TIPO'**
  String get coletaType;

  /// No description provided for @coletaActionNextStep.
  ///
  /// In pt, this message translates to:
  /// **'Prosseguir para Artefatos'**
  String get coletaActionNextStep;

  /// No description provided for @coletaActionCancel.
  ///
  /// In pt, this message translates to:
  /// **'CANCELAR COLETA'**
  String get coletaActionCancel;

  /// No description provided for @coletaNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Muro de Arrimo - Setor A'**
  String get coletaNameHint;

  /// No description provided for @coletaPopularNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Como a comunidade local se refere a este bem?'**
  String get coletaPopularNameHint;

  /// No description provided for @coletaArtifactTypes.
  ///
  /// In pt, this message translates to:
  /// **'TIPOS DE ARTEFATO'**
  String get coletaArtifactTypes;

  /// No description provided for @coletaArtifactHint.
  ///
  /// In pt, this message translates to:
  /// **'Selecione os que foram identificados ou adicione um novo tipo.'**
  String get coletaArtifactHint;

  /// No description provided for @coletaActionNextStepDocs.
  ///
  /// In pt, this message translates to:
  /// **'Prosseguir para Documentação'**
  String get coletaActionNextStepDocs;

  /// No description provided for @coletaArtifactRequired.
  ///
  /// In pt, this message translates to:
  /// **'Selecione ao menos um tipo de artefato.'**
  String get coletaArtifactRequired;

  /// No description provided for @coletasTitle.
  ///
  /// In pt, this message translates to:
  /// **'Minhas Coletas'**
  String get coletasTitle;

  /// No description provided for @coletasTabAll.
  ///
  /// In pt, this message translates to:
  /// **'TODOS'**
  String get coletasTabAll;

  /// No description provided for @coletasTabDrafts.
  ///
  /// In pt, this message translates to:
  /// **'RASCUNHOS'**
  String get coletasTabDrafts;

  /// No description provided for @coletasTabPending.
  ///
  /// In pt, this message translates to:
  /// **'PENDENTES'**
  String get coletasTabPending;

  /// No description provided for @coletasTabApproved.
  ///
  /// In pt, this message translates to:
  /// **'APROVADOS'**
  String get coletasTabApproved;

  /// No description provided for @coletasTabRejected.
  ///
  /// In pt, this message translates to:
  /// **'REJEITADOS'**
  String get coletasTabRejected;

  /// No description provided for @coletasDraftBanner.
  ///
  /// In pt, this message translates to:
  /// **'Você tem um rascunho salvo. Continuar?'**
  String get coletasDraftBanner;

  /// No description provided for @coletasDraftDiscard.
  ///
  /// In pt, this message translates to:
  /// **'Descartar'**
  String get coletasDraftDiscard;

  /// No description provided for @coletasDraftContinue.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get coletasDraftContinue;

  /// No description provided for @coletasEmptyFirst.
  ///
  /// In pt, this message translates to:
  /// **'Registre sua primeira coleta arqueológica.'**
  String get coletasEmptyFirst;

  /// No description provided for @coletasEmptyDrafts.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum rascunho salvo.'**
  String get coletasEmptyDrafts;

  /// No description provided for @coletasEmptyPending.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma coleta pendente.'**
  String get coletasEmptyPending;

  /// No description provided for @coletasEmptyApproved.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma coleta aprovada.'**
  String get coletasEmptyApproved;

  /// No description provided for @coletasEmptyRejected.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma coleta rejeitada.'**
  String get coletasEmptyRejected;

  /// No description provided for @coletasRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get coletasRetry;

  /// No description provided for @coletasNoRegistered.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma coleta registrada'**
  String get coletasNoRegistered;

  /// No description provided for @coletasDataSynced.
  ///
  /// In pt, this message translates to:
  /// **'Dados Sincronizados'**
  String get coletasDataSynced;

  /// No description provided for @coletasSyncProgress.
  ///
  /// In pt, this message translates to:
  /// **'{synced} de {total} sincronizadas'**
  String coletasSyncProgress(int synced, int total);

  /// No description provided for @bemMaterialTitle.
  ///
  /// In pt, this message translates to:
  /// **'Bem Material'**
  String get bemMaterialTitle;

  /// No description provided for @bemMaterialNewTitle.
  ///
  /// In pt, this message translates to:
  /// **'Novo Bem'**
  String get bemMaterialNewTitle;

  /// No description provided for @bemMaterialEditTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar Bem'**
  String get bemMaterialEditTitle;

  /// No description provided for @bemMaterialFieldName.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get bemMaterialFieldName;

  /// No description provided for @bemMaterialFieldCode.
  ///
  /// In pt, this message translates to:
  /// **'Código'**
  String get bemMaterialFieldCode;

  /// No description provided for @bemMaterialFieldCategory.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get bemMaterialFieldCategory;

  /// No description provided for @bemMaterialSaveButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get bemMaterialSaveButton;

  /// No description provided for @bemMaterialDeleteConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar exclusão do bem?'**
  String get bemMaterialDeleteConfirm;

  /// No description provided for @profileTitle.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @profileUserBadge.
  ///
  /// In pt, this message translates to:
  /// **'USUÁRIO'**
  String get profileUserBadge;

  /// No description provided for @profileFieldStats.
  ///
  /// In pt, this message translates to:
  /// **'Estatísticas de Campo'**
  String get profileFieldStats;

  /// No description provided for @profileRegisteredCollections.
  ///
  /// In pt, this message translates to:
  /// **'COLETAS REGISTRADAS'**
  String get profileRegisteredCollections;

  /// No description provided for @profilePendingSyncLabel.
  ///
  /// In pt, this message translates to:
  /// **'PENDENTES SYNC'**
  String get profilePendingSyncLabel;

  /// No description provided for @profileNotificationsSection.
  ///
  /// In pt, this message translates to:
  /// **'Notificações'**
  String get profileNotificationsSection;

  /// No description provided for @profileSyncAlerts.
  ///
  /// In pt, this message translates to:
  /// **'Alertas de Sincronização'**
  String get profileSyncAlerts;

  /// No description provided for @profileCurationStatus.
  ///
  /// In pt, this message translates to:
  /// **'Status de Curadoria'**
  String get profileCurationStatus;

  /// No description provided for @profileProximityAlerts.
  ///
  /// In pt, this message translates to:
  /// **'Avisos de Proximidade'**
  String get profileProximityAlerts;

  /// No description provided for @profileNotificationPrefs.
  ///
  /// In pt, this message translates to:
  /// **'Preferências de Notificação'**
  String get profileNotificationPrefs;

  /// No description provided for @profileAppPreferences.
  ///
  /// In pt, this message translates to:
  /// **'Preferências do App'**
  String get profileAppPreferences;

  /// No description provided for @profileDarkMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo Escuro'**
  String get profileDarkMode;

  /// No description provided for @profileUnits.
  ///
  /// In pt, this message translates to:
  /// **'Unidades de Medida'**
  String get profileUnits;

  /// No description provided for @profileMetric.
  ///
  /// In pt, this message translates to:
  /// **'Métrico'**
  String get profileMetric;

  /// No description provided for @profileLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get profileLanguage;

  /// No description provided for @profileLanguageValue.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get profileLanguageValue;

  /// No description provided for @profileExportLogs.
  ///
  /// In pt, this message translates to:
  /// **'Exportar logs de erro'**
  String get profileExportLogs;

  /// No description provided for @profileLogoutButton.
  ///
  /// In pt, this message translates to:
  /// **'Sair da conta'**
  String get profileLogoutButton;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sair da conta'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutContent.
  ///
  /// In pt, this message translates to:
  /// **'Deseja encerrar a sessão? Coletas não sincronizadas precisam ser enviadas antes de sair.'**
  String get profileLogoutContent;

  /// No description provided for @profileLogoutCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get profileLogoutCancel;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get profileLogoutConfirm;

  /// No description provided for @profilePendingWarning.
  ///
  /// In pt, this message translates to:
  /// **'Você tem coletas pendentes de sincronização. Sincronize antes de sair.'**
  String get profilePendingWarning;

  /// No description provided for @profileEditButton.
  ///
  /// In pt, this message translates to:
  /// **'Editar Perfil'**
  String get profileEditButton;

  /// No description provided for @profileFieldName.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get profileFieldName;

  /// No description provided for @profileFieldEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get profileFieldEmail;

  /// No description provided for @notificationsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Notificações'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma notificação encontrada.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In pt, this message translates to:
  /// **'Marcar todas como lidas'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get notificationsRetry;

  /// No description provided for @notificationsFilterAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get notificationsFilterAll;

  /// No description provided for @notificationsFilterColeta.
  ///
  /// In pt, this message translates to:
  /// **'Coleta'**
  String get notificationsFilterColeta;

  /// No description provided for @notificationsFilterSync.
  ///
  /// In pt, this message translates to:
  /// **'Sync'**
  String get notificationsFilterSync;

  /// No description provided for @notificationsFilterSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get notificationsFilterSystem;

  /// No description provided for @notificationsFilterLabel.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar por {name}'**
  String notificationsFilterLabel(String name);

  /// No description provided for @notificationsMinutesAgo.
  ///
  /// In pt, this message translates to:
  /// **'Há {min} min'**
  String notificationsMinutesAgo(int min);

  /// No description provided for @notificationsHoursAgo.
  ///
  /// In pt, this message translates to:
  /// **'Há {hours}h'**
  String notificationsHoursAgo(int hours);

  /// No description provided for @notificationsYesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get notificationsYesterday;

  /// No description provided for @notificationsDaysAgo.
  ///
  /// In pt, this message translates to:
  /// **'Há {days} dias'**
  String notificationsDaysAgo(int days);

  /// No description provided for @syncTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sincronização'**
  String get syncTitle;

  /// No description provided for @syncPageTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizar'**
  String get syncPageTitle;

  /// No description provided for @syncConnectionStatus.
  ///
  /// In pt, this message translates to:
  /// **'Status da Conexão'**
  String get syncConnectionStatus;

  /// No description provided for @syncOnline.
  ///
  /// In pt, this message translates to:
  /// **'Você está Online'**
  String get syncOnline;

  /// No description provided for @syncOffline.
  ///
  /// In pt, this message translates to:
  /// **'Você está Offline'**
  String get syncOffline;

  /// No description provided for @syncOnlineLabel.
  ///
  /// In pt, this message translates to:
  /// **'Online'**
  String get syncOnlineLabel;

  /// No description provided for @syncOfflineLabel.
  ///
  /// In pt, this message translates to:
  /// **'Offline'**
  String get syncOfflineLabel;

  /// No description provided for @syncGeneralProgress.
  ///
  /// In pt, this message translates to:
  /// **'Progresso Geral'**
  String get syncGeneralProgress;

  /// No description provided for @syncPercentLabel.
  ///
  /// In pt, this message translates to:
  /// **'{percent}% sincronizado'**
  String syncPercentLabel(int percent);

  /// No description provided for @syncPendingItems.
  ///
  /// In pt, this message translates to:
  /// **'Itens pendentes'**
  String get syncPendingItems;

  /// No description provided for @syncPendingCountLabel.
  ///
  /// In pt, this message translates to:
  /// **'{count} pendente(s)'**
  String syncPendingCountLabel(int count);

  /// No description provided for @syncDetails.
  ///
  /// In pt, this message translates to:
  /// **'DETALHAMENTO'**
  String get syncDetails;

  /// No description provided for @syncGpsData.
  ///
  /// In pt, this message translates to:
  /// **'Dados de GPS'**
  String get syncGpsData;

  /// No description provided for @syncPendingForms.
  ///
  /// In pt, this message translates to:
  /// **'Formulários Pendentes'**
  String get syncPendingForms;

  /// No description provided for @syncConflictsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Conflitos'**
  String get syncConflictsLabel;

  /// No description provided for @syncSendErrors.
  ///
  /// In pt, this message translates to:
  /// **'Erros de Envio'**
  String get syncSendErrors;

  /// No description provided for @syncConflictCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} conflito(s)'**
  String syncConflictCount(int count);

  /// No description provided for @syncErrorCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} erro(s)'**
  String syncErrorCount(int count);

  /// No description provided for @syncButton.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizar agora'**
  String get syncButton;

  /// No description provided for @syncStartButton.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar Sincronização Total'**
  String get syncStartButton;

  /// No description provided for @syncSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizado com sucesso!'**
  String get syncSuccess;

  /// No description provided for @syncSuccessAll.
  ///
  /// In pt, this message translates to:
  /// **'Tudo sincronizado com sucesso!'**
  String get syncSuccessAll;

  /// No description provided for @syncError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao sincronizar. Tente novamente.'**
  String get syncError;

  /// No description provided for @syncNeedsReview.
  ///
  /// In pt, this message translates to:
  /// **'{count} conflito(s) precisam de revisão.'**
  String syncNeedsReview(int count);

  /// No description provided for @syncExpiredSession.
  ///
  /// In pt, this message translates to:
  /// **'Sessão expirada. Faça login novamente.'**
  String get syncExpiredSession;

  /// No description provided for @syncNoConnection.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão. Conecte-se à internet para sincronizar.'**
  String get syncNoConnection;

  /// No description provided for @syncInProgress.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizando…'**
  String get syncInProgress;

  /// No description provided for @syncUnexpectedError.
  ///
  /// In pt, this message translates to:
  /// **'Erro inesperado.'**
  String get syncUnexpectedError;

  /// No description provided for @syncLastSync.
  ///
  /// In pt, this message translates to:
  /// **'Última sincronização'**
  String get syncLastSync;

  /// No description provided for @syncLastSyncNever.
  ///
  /// In pt, this message translates to:
  /// **'Última sincronização: --'**
  String get syncLastSyncNever;

  /// No description provided for @syncOk.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get syncOk;

  /// No description provided for @commonConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get commonConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get commonCancel;

  /// No description provided for @commonYes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get commonNo;

  /// No description provided for @commonError.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro inesperado.'**
  String get commonError;

  /// No description provided for @commonLoading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get commonLoading;

  /// No description provided for @commonSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get commonEdit;

  /// No description provided for @commonSearch.
  ///
  /// In pt, this message translates to:
  /// **'Buscar'**
  String get commonSearch;

  /// No description provided for @commonBack.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get commonBack;

  /// No description provided for @commonRequired.
  ///
  /// In pt, this message translates to:
  /// **'Campo obrigatório'**
  String get commonRequired;

  /// No description provided for @commonInvalidEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail inválido'**
  String get commonInvalidEmail;

  /// No description provided for @commonRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get commonRetry;

  /// No description provided for @navHome.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get navHome;

  /// No description provided for @navCollections.
  ///
  /// In pt, this message translates to:
  /// **'Coletas'**
  String get navCollections;

  /// No description provided for @navSync.
  ///
  /// In pt, this message translates to:
  /// **'Sincronizar'**
  String get navSync;

  /// No description provided for @navProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get navProfile;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
