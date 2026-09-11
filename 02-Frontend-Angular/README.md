# Prueba técnica Frontend Angular

## Solución implementada

Aplicación Angular 17 con componentes standalone y Angular Material.

### Funcionalidades
- Dashboard responsive.
- Tabla de clima de 8 ciudades.
- Consumo de APIs públicas de Open-Meteo.
- Servicio separado para datos meteorológicos.
- Servicio separado para geocodificación (`GeocodingService`), preparado para búsquedas de ciudad.
- Filtro por nombre de ciudad.
- Paginación con Angular Material.
- Indicador de carga.
- Manejo de errores con `MatSnackBar` y estado visual.
- Interfaces TypeScript para los modelos.
- Tests unitarios básicos.

## Instalación

Requisitos:
- Node.js 18.13+ recomendado.
- npm.

Ejecutar:

```bash
npm install
npm start
```

Abrir `http://localhost:4200`.

Producción:

```bash
npm run build
```

## APIs

Se utiliza Open-Meteo:
- Forecast: datos meteorológicos actuales.
- Geocoding: servicio independiente para búsqueda de ciudades.

No requiere API key.

## Arquitectura

```text
src/app/
├── models/
│   └── weather.models.ts
├── services/
│   ├── geocoding.service.ts
│   ├── weather.service.ts
│   └── weather.service.spec.ts
└── pages/
    └── home/
        ├── home.component.ts
        ├── home.component.html
        ├── home.component.css
        └── home.component.spec.ts
```

## Nota de diseño

La solución usa standalone components, separación por responsabilidades, tipado fuerte,
Angular Material y una UI responsive. El endpoint de geocoding queda desacoplado para
poder evolucionar el buscador a una búsqueda dinámica de ciudades sin mezclar esa lógica
con el consumo del pronóstico.
