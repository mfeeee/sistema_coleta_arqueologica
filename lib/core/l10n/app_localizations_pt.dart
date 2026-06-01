// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loginTitle => 'Entrar';

  @override
  String get loginSystemTitle => 'Acesso ao Sistema';

  @override
  String get loginPlatformDesc => 'Plataforma de Coleta de Dados Arqueológicos';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginEmailHint => 'exemplo@arqueo.org';

  @override
  String get loginPasswordLabel => 'Senha';

  @override
  String get loginPasswordHint => 'Digite sua senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginCreateAccount => 'Criar Conta';

  @override
  String get loginForgotPassword => 'Esqueceu sua senha?';

  @override
  String get loginNoAccount => 'Não tem uma conta? Cadastre-se';

  @override
  String get loginEmailRequired => 'Informe seu e-mail';

  @override
  String get loginPasswordRequired => 'Informe sua senha';

  @override
  String get registerTitle => 'Criar Conta';

  @override
  String get registerSubtitle =>
      'Junte-se à nossa comunidade de exploração arqueológica.';

  @override
  String get registerFullName => 'Nome Completo';

  @override
  String get registerFullNameHint => 'Digite seu nome completo';

  @override
  String get registerFullNameRequired => 'Informe seu nome';

  @override
  String get registerEmailHint => 'exemplo@instituicao.br';

  @override
  String get registerClassification => 'Classificação';

  @override
  String get registerClassificationHint => 'Selecione seu perfil';

  @override
  String get registerClassStudent => 'Estudante';

  @override
  String get registerClassTeacher => 'Professor';

  @override
  String get registerClassArchaeologist => 'Arqueólogo';

  @override
  String get registerPasswordLabel => 'Senha';

  @override
  String get registerPasswordHint => 'Crie uma senha';

  @override
  String get registerPasswordMin => 'Mínimo 8 caracteres';

  @override
  String get registerConfirmPassword => 'Confirmar Senha';

  @override
  String get registerConfirmPasswordHint => 'Repita a senha';

  @override
  String get registerPasswordMismatch => 'Senhas não coincidem';

  @override
  String get registerButton => 'Criar Conta';

  @override
  String get registerHaveAccount => 'Já tenho uma conta, entrar';

  @override
  String get registerTermsText => 'Ao se cadastrar, você concorda com nossos';

  @override
  String get registerTermsService => 'Termos de Serviço';

  @override
  String get registerTermsAnd => 'e';

  @override
  String get registerPrivacyPolicy => 'Política de Privacidade';

  @override
  String get recoverPasswordTitle => 'Recuperar Senha';

  @override
  String get recoverPasswordSubtitle =>
      'Insira o e-mail cadastrado para receber as instruções de recuperação.';

  @override
  String get recoverPasswordEmailSent => 'E-mail Enviado';

  @override
  String get recoverPasswordEmailSentDesc =>
      'Verifique seu e-mail para redefinir a senha.';

  @override
  String get recoverPasswordBackToLogin => 'Voltar ao Login';

  @override
  String get recoverPasswordEnterCode => 'Inserir Código';

  @override
  String get recoverPasswordSendLink => 'Enviar Link';

  @override
  String get recoverPasswordRemember => 'Lembrou sua senha?';

  @override
  String get recoverPasswordDoLogin => 'Fazer login';

  @override
  String get homeTitle => 'Início';

  @override
  String homeGreeting(String nome) {
    return 'Olá, $nome';
  }

  @override
  String get homeResearcher => 'Pesquisador';

  @override
  String get homeSubtitle => 'Pronto para novas descobertas hoje?';

  @override
  String get homeWelcome => 'Bem-vindo(a)';

  @override
  String homePendingBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count coletas aguardando envio',
      one: '$count coleta aguardando envio',
    );
    return '$_temp0';
  }

  @override
  String get homeNewCollection => 'Nova Coleta';

  @override
  String get homeViewCollections => 'Ver Minhas Coletas';

  @override
  String get homeSyncNow => 'Sincronizar Agora';

  @override
  String get homeActivitySummary => 'Resumo das Atividades';

  @override
  String get homeTotal => 'TOTAL';

  @override
  String get homePendingLabel => 'PENDENTES';

  @override
  String get homeRecentActivities => 'Atividades Recentes';

  @override
  String get homeViewAll => 'Ver tudo';

  @override
  String get homeRecentCollections => 'Coletas Recentes';

  @override
  String get homeNoCollections => 'Nenhuma coleta registrada ainda.';

  @override
  String get homeNoTitle => 'Coleta sem título';

  @override
  String homeTodayAt(String hora) {
    return 'Hoje, às $hora';
  }

  @override
  String homeYesterdayAt(String hora) {
    return 'Ontem, às $hora';
  }

  @override
  String get coletaTitle => 'Coleta';

  @override
  String get coletaNewTitle => 'Nova Coleta';

  @override
  String get coletaEditTitle => 'Editar Coleta';

  @override
  String get coletaFieldLocation => 'Localização';

  @override
  String get coletaFieldDate => 'Data';

  @override
  String get coletaFieldDescription => 'Descrição';

  @override
  String get coletaSaveButton => 'Salvar';

  @override
  String get coletaCancelButton => 'Cancelar';

  @override
  String get coletaDeleteButton => 'Excluir';

  @override
  String get coletaDeleteConfirm =>
      'Tem certeza que deseja excluir esta coleta?';

  @override
  String get coletaSuccess => 'Coleta salva com sucesso!';

  @override
  String get coletasTitle => 'Minhas Coletas';

  @override
  String get coletasTabAll => 'TODOS';

  @override
  String get coletasTabPending => 'PENDENTES';

  @override
  String get coletasTabApproved => 'APROVADOS';

  @override
  String get coletasTabRejected => 'REJEITADOS';

  @override
  String get coletasDraftBanner => 'Você tem um rascunho salvo. Continuar?';

  @override
  String get coletasDraftDiscard => 'Descartar';

  @override
  String get coletasDraftContinue => 'Continuar';

  @override
  String get coletasEmptyFirst => 'Registre sua primeira coleta arqueológica.';

  @override
  String get coletasEmptyPending => 'Nenhuma coleta pendente.';

  @override
  String get coletasEmptyApproved => 'Nenhuma coleta aprovada.';

  @override
  String get coletasEmptyRejected => 'Nenhuma coleta rejeitada.';

  @override
  String get coletasRetry => 'Tentar novamente';

  @override
  String get coletasNoRegistered => 'Nenhuma coleta registrada';

  @override
  String get coletasDataSynced => 'Dados Sincronizados';

  @override
  String coletasSyncProgress(int synced, int total) {
    return '$synced de $total sincronizadas';
  }

  @override
  String get bemMaterialTitle => 'Bem Material';

  @override
  String get bemMaterialNewTitle => 'Novo Bem';

  @override
  String get bemMaterialEditTitle => 'Editar Bem';

  @override
  String get bemMaterialFieldName => 'Nome';

  @override
  String get bemMaterialFieldCode => 'Código';

  @override
  String get bemMaterialFieldCategory => 'Categoria';

  @override
  String get bemMaterialSaveButton => 'Salvar';

  @override
  String get bemMaterialDeleteConfirm => 'Confirmar exclusão do bem?';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileUserBadge => 'USUÁRIO';

  @override
  String get profileFieldStats => 'Estatísticas de Campo';

  @override
  String get profileRegisteredCollections => 'COLETAS REGISTRADAS';

  @override
  String get profilePendingSyncLabel => 'PENDENTES SYNC';

  @override
  String get profileNotificationsSection => 'Notificações';

  @override
  String get profileSyncAlerts => 'Alertas de Sincronização';

  @override
  String get profileCurationStatus => 'Status de Curadoria';

  @override
  String get profileProximityAlerts => 'Avisos de Proximidade';

  @override
  String get profileNotificationPrefs => 'Preferências de Notificação';

  @override
  String get profileAppPreferences => 'Preferências do App';

  @override
  String get profileDarkMode => 'Modo Escuro';

  @override
  String get profileUnits => 'Unidades de Medida';

  @override
  String get profileMetric => 'Métrico';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileLanguageValue => 'Português';

  @override
  String get profileExportLogs => 'Exportar logs de erro';

  @override
  String get profileLogoutButton => 'Sair da conta';

  @override
  String get profileLogoutTitle => 'Sair da conta';

  @override
  String get profileLogoutContent =>
      'Deseja encerrar a sessão? Coletas não sincronizadas precisam ser enviadas antes de sair.';

  @override
  String get profileLogoutCancel => 'Cancelar';

  @override
  String get profileLogoutConfirm => 'Sair';

  @override
  String get profilePendingWarning =>
      'Você tem coletas pendentes de sincronização. Sincronize antes de sair.';

  @override
  String get profileEditButton => 'Editar Perfil';

  @override
  String get profileFieldName => 'Nome';

  @override
  String get profileFieldEmail => 'E-mail';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsEmpty => 'Nenhuma notificação encontrada.';

  @override
  String get notificationsMarkAllRead => 'Marcar todas como lidas';

  @override
  String get notificationsRetry => 'Tentar novamente';

  @override
  String get notificationsFilterAll => 'Todos';

  @override
  String get notificationsFilterColeta => 'Coleta';

  @override
  String get notificationsFilterSync => 'Sync';

  @override
  String get notificationsFilterSystem => 'Sistema';

  @override
  String notificationsFilterLabel(String name) {
    return 'Filtrar por $name';
  }

  @override
  String notificationsMinutesAgo(int min) {
    return 'Há $min min';
  }

  @override
  String notificationsHoursAgo(int hours) {
    return 'Há ${hours}h';
  }

  @override
  String get notificationsYesterday => 'Ontem';

  @override
  String notificationsDaysAgo(int days) {
    return 'Há $days dias';
  }

  @override
  String get syncTitle => 'Sincronização';

  @override
  String get syncPageTitle => 'Sincronizar';

  @override
  String get syncConnectionStatus => 'Status da Conexão';

  @override
  String get syncOnline => 'Você está Online';

  @override
  String get syncOffline => 'Você está Offline';

  @override
  String get syncOnlineLabel => 'Online';

  @override
  String get syncOfflineLabel => 'Offline';

  @override
  String get syncGeneralProgress => 'Progresso Geral';

  @override
  String syncPercentLabel(int percent) {
    return '$percent% sincronizado';
  }

  @override
  String get syncPendingItems => 'Itens pendentes';

  @override
  String syncPendingCountLabel(int count) {
    return '$count pendente(s)';
  }

  @override
  String get syncDetails => 'DETALHAMENTO';

  @override
  String get syncGpsData => 'Dados de GPS';

  @override
  String get syncPendingForms => 'Formulários Pendentes';

  @override
  String get syncConflictsLabel => 'Conflitos';

  @override
  String get syncSendErrors => 'Erros de Envio';

  @override
  String syncConflictCount(int count) {
    return '$count conflito(s)';
  }

  @override
  String syncErrorCount(int count) {
    return '$count erro(s)';
  }

  @override
  String get syncButton => 'Sincronizar agora';

  @override
  String get syncStartButton => 'Iniciar Sincronização Total';

  @override
  String get syncSuccess => 'Sincronizado com sucesso!';

  @override
  String get syncSuccessAll => 'Tudo sincronizado com sucesso!';

  @override
  String get syncError => 'Erro ao sincronizar. Tente novamente.';

  @override
  String syncNeedsReview(int count) {
    return '$count conflito(s) precisam de revisão.';
  }

  @override
  String get syncExpiredSession => 'Sessão expirada. Faça login novamente.';

  @override
  String get syncNoConnection =>
      'Sem conexão. Conecte-se à internet para sincronizar.';

  @override
  String get syncInProgress => 'Sincronizando…';

  @override
  String get syncUnexpectedError => 'Erro inesperado.';

  @override
  String get syncLastSync => 'Última sincronização';

  @override
  String get syncLastSyncNever => 'Última sincronização: --';

  @override
  String get syncOk => 'OK';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonYes => 'Sim';

  @override
  String get commonNo => 'Não';

  @override
  String get commonError => 'Ocorreu um erro inesperado.';

  @override
  String get commonLoading => 'Carregando...';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonSearch => 'Buscar';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonRequired => 'Campo obrigatório';

  @override
  String get commonInvalidEmail => 'E-mail inválido';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get navHome => 'Início';

  @override
  String get navCollections => 'Coletas';

  @override
  String get navSync => 'Sincronizar';

  @override
  String get navProfile => 'Perfil';
}
