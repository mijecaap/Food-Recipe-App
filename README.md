# Food Recipe App

Una aplicación móvil para gestionar y compartir recetas de comida, desarrollada con Flutter y Firebase.

## Características

- Autenticación de usuarios mediante:
  - Google Sign In
  - Facebook Login
  - Firebase Authentication

- Gestión de recetas:
  - Crear nuevas recetas
  - Subir fotos de los platos
  - Guardar recetas favoritas
  - Ver mis recetas
  
- Almacenamiento de datos:
  - Firebase Cloud Firestore para la base de datos
  - Firebase Storage para las imágenes

## Tecnologías Utilizadas

- Flutter
- Firebase
  - Authentication
  - Cloud Firestore
  - Storage
- Google Sign In
- Facebook Authentication
- Image Picker
- File Picker

## Requisitos Previos

- Flutter SDK
- Android Studio / VS Code
- Firebase CLI
- Una cuenta de Firebase
- Configuración de proyecto en Facebook Developers para el login con Facebook

## Instalación

1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/Food-Recipe-App.git
```

2. Instalar dependencias
```bash
flutter pub get
```

3. Configurar Firebase:
   - Agregar el archivo google-services.json en android/app/
   - Configurar firebase_options.dart con tus credenciales

4. Ejecutar la aplicación
```bash
flutter run
```

## Estructura del Proyecto

- `lib/`
  - `core/` - Funcionalidades principales
  - `features/` - Características de la aplicación
  - `Recipe/` - Lógica relacionada con recetas
  - `Shared/` - Componentes compartidos
  - `User/` - Gestión de usuarios

## Contribución

Las contribuciones son bienvenidas. Para cambios importantes:

1. Fork el proyecto
2. Crea una rama para tu característica
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
