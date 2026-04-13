# 🚗 Catálogo de Vehículos – Flutter Clean Architecture

Aplicación móvil desarrollada en **Flutter** para gestionar un catálogo de vehículos con soporte para múltiples imágenes por vehículo. Utiliza **Clean Architecture** con persistencia local mediante **SQLite**.

---

## 📱 Funcionalidades

- **Listar vehículos** con imagen, marca, modelo, año y precio.
- **Agregar vehículos** con múltiples fotos desde la cámara o galería del dispositivo.
- **Editar vehículos** existentes (datos e imágenes).
- **Eliminar vehículos** con diálogo de confirmación.
- **Ver detalle** con carrusel de imágenes deslizable e indicadores de página.
- **Validación de formulario** con imagen obligatoria (al menos una).

---

## 🧱 Arquitectura

El proyecto sigue el patrón **Clean Architecture** con separación en 3 capas:

| Capa | Responsabilidad | Componentes principales |
|------|----------------|------------------------|
| **Presentation** | UI y gestión de estado | Pages, Widgets, BLoC (Events/States) |
| **Domain** | Lógica de negocio pura | Entity, UseCases, Repository (abstracto) |
| **Data** | Acceso y persistencia de datos | Model, DataSource, RepositoryImpl, DatabaseService |

### Flujo de datos

```
UI (Pages/Widgets)
    ↓ eventos
BLoC (VehicleBloc)
    ↓ llamadas
UseCases (Get, Add, Update, Delete)
    ↓ contrato
Repository (abstracto)
    ↓ implementación
RepositoryImpl
    ↓ conversión Entity ↔ Model
DataSource (LocalDataSourceImpl)
    ↓ queries SQL
SQLite (DatabaseService)
```

---

## 📁 Estructura de carpetas

```
lib/
├── core/
│   └── services/
│       └── database_service.dart        # Inicialización SQLite y creación de tablas
│
├── features/
│   └── vehicles/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── vehicle_local_datasource.dart   # CRUD con sqflite
│       │   ├── models/
│       │   │   └── vehicle_model.dart               # toMap / fromMap / fromEntity
│       │   └── repositories/
│       │       └── vehicle_repository_impl.dart     # Implementación del contrato
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── vehicle.dart                     # Entidad pura (sin dependencias)
│       │   ├── repositories/
│       │   │   └── vehicle_repository.dart          # Contrato abstracto
│       │   └── usecases/
│       │       ├── add_vehicle.dart
│       │       ├── delete_vehicle.dart
│       │       ├── get_vehicles.dart
│       │       └── update_vehicle.dart
│       │
│       └── presentation/
│           ├── bloc/
│           │   ├── vehicle_bloc.dart                # Lógica de eventos → estados
│           │   ├── vehicle_event.dart               # Load, Add, Update, Delete
│           │   └── vehicle_state.dart               # Initial, Loading, Loaded, Error
│           ├── pages/
│           │   ├── add_vehicle_page.dart            # Pantalla agregar/editar
│           │   ├── vehicle_detail_page.dart         # Pantalla detalle con carrusel
│           │   └── vehicle_list_page.dart           # Pantalla principal (lista)
│           └── widgets/
│               ├── vehicle_card.dart                # Tarjeta en la lista
│               └── vehicle_form.dart                # Formulario con selector de imágenes
│
└── main.dart                                        # Inyección de dependencias y arranque
```

---

## 🗄️ Base de datos

SQLite con dos tablas relacionadas:

```sql
CREATE TABLE vehicles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    brand TEXT NOT NULL,
    model TEXT NOT NULL,
    year INTEGER NOT NULL,
    price REAL NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE vehicle_images (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vehicleId INTEGER NOT NULL,
    imagePath TEXT NOT NULL,
    FOREIGN KEY (vehicleId) REFERENCES vehicles (id) ON DELETE CASCADE
);
```

La tabla `vehicle_images` permite almacenar **múltiples imágenes** por vehículo. Al eliminar un vehículo, sus imágenes se borran automáticamente gracias al `ON DELETE CASCADE`.

---

## 📦 Dependencias

| Paquete | Versión | Uso |
|---------|---------|-----|
| `sqflite` | ^2.0.0 | Base de datos SQLite |
| `path` | ^1.8.0 | Manejo de rutas de archivos |
| `flutter_bloc` | ^8.1.0 | Gestión de estado con BLoC |
| `equatable` | ^2.0.5 | Comparación de objetos |
| `image_picker` | ^1.0.0 | Selección de imágenes (cámara/galería) |

### Instalación de dependencias

```bash
flutter pub add sqflite path flutter_bloc equatable image_picker
```

---

## 🚀 Cómo ejecutar

### Requisitos previos

- Flutter SDK instalado (3.x o superior)
- Emulador Android / dispositivo físico conectado
- Android Studio o VS Code con extensión Flutter

### Pasos

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd elementos_multimedia

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar en emulador o dispositivo
flutter run
```

> **Nota:** La app requiere ejecutarse en un **emulador o dispositivo real** (Android/iOS/Windows). No es compatible con Chrome/Web porque `sqflite` no soporta la plataforma web de forma nativa.

---

## 🔄 Patrón BLoC

El BLoC (Business Logic Component) gestiona el estado de la aplicación mediante eventos y estados:

### Events (acciones del usuario)

| Evento | Descripción |
|--------|-------------|
| `LoadVehicles` | Cargar la lista completa |
| `AddVehicleEvent` | Agregar un vehículo nuevo |
| `UpdateVehicleEvent` | Actualizar un vehículo existente |
| `DeleteVehicleEvent` | Eliminar un vehículo por ID |

### States (estado de la UI)

| Estado | Descripción |
|--------|-------------|
| `VehicleInitial` | Estado inicial, sin datos |
| `VehicleLoading` | Cargando datos (muestra spinner) |
| `VehicleLoaded` | Datos disponibles (muestra lista) |
| `VehicleError` | Error con mensaje descriptivo |

---

## 📌 Reglas de arquitectura

### ✅ Se cumple

- La UI no accede directamente a SQLite.
- El Domain Layer no depende de Flutter ni de ningún paquete externo.
- El Data Layer implementa los repositorios definidos en Domain.
- Se usa BLoC como único gestor de estado.
- Las imágenes se seleccionan desde el dispositivo (cámara o galería).

### ❌ Prohibido

- Lógica de negocio dentro de widgets o pages.
- Acceso directo al DataSource desde la UI.
- Uso de `Map<String, dynamic>` fuera del Data Layer.
- Mezclar responsabilidades entre capas.

---

## 👨‍💻 Autor

Desarrollado como laboratorio de Flutter con Clean Architecture y elementos multimedia por Héctor Gómez, Jonathan Campos y Enoc Abarca.