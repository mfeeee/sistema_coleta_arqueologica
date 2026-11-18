// Outra API (ex.: novo deploy no Railway):
// flutter build apk --dart-define=API_BASE_URL=https://<servico>.up.railway.app/api
const kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://sistemaarqueologicoapi-production.up.railway.app/api',
);
