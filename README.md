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

## Capturas de Pantalla

### Pantalla de Inicio de Sesión
![Pantalla de Inicio de Sesión](https://firebasestorage.googleapis.com/v0/b/recipez-d861e.appspot.com/o/screens%2Flogin-screen.jpeg?alt=media&token=331c5543-2826-49f3-9980-99379e88b1a1)

### Pantalla Principal
![Pantalla Principal](https://firebasestorage.googleapis.com/v0/b/recipez-d861e.appspot.com/o/screens%2Fmain-home-screen.jpeg?alt=media&token=a28768be-77ce-49d5-9115-3dc480940ad3)

### Pantalla de Inicio de Creación
![Pantalla de Inicio de Creación](https://firebasestorage.googleapis.com/v0/b/recipez-d861e.appspot.com/o/screens%2Finitialize-create-screen.jpeg?alt=media&token=0a23483f-aaf4-429a-92df-132ac840ac29)

### Perfil de Usuario
![Perfil de Usuario](https://firebasestorage.googleapis.com/v0/b/recipez-d861e.appspot.com/o/screens%2Fprofile-screen.jpeg?alt=media&token=ec7f6c2f-54a9-424d-affc-8e91197fb503)

### Detalles de Receta
![Detalles de Receta](https://firebasestorage.googleapis.com/v0/b/recipez-d861e.appspot.com/o/screens%2Frecipe-screen.jpeg?alt=media&token=acf33e85-facc-4bfa-a3fd-157537905629)

### Formulario de Receta
![Formulario de Receta](https://firebasestorage.googleapis.com/v0/b/recipez-d861e.appspot.com/o/screens%2Frecipe-form.jpeg?alt=media&token=1b42578e-8f0d-4169-b76d-cb6a702a1d66)

### Modal de Ingredientes
![Modal de Ingredientes](https://firebasestorage.googleapis.com/v0/b/recipez-d861e.appspot.com/o/screens%2Fmodal-ingredient-recipe.jpeg?alt=media&token=7a8148cd-f841-46d3-88a1-2ed2b78ffc55)

## Contribución

Las contribuciones son bienvenidas. Para cambios importantes:

1. Fork el proyecto
2. Crea una rama para tu característica
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
