# crud_rest

Esta sección tiene por objetivo trabajar con data y enviarla a un servicio REST como también poder trabajar con las fotografías e imágenes.
Para logarlo se hace uso de Firebase y su servicio API. 
Para la subida de imagenes se hace uso del servicio [Cloudinary](https://cloudinary.com/). 
ESto debido a que Firebase no provee una API REST para su servicio de Storage, debe ser programada mediante un lenguaje backend.

## Temas de la sección:

- Formularios sin Bloc
- Modelos
- CRUD hacia Firebase
- Llamados de servicios REST
- Cargar imágenes
- Cámara
- Galería de imágenes

## Rama Login 

En esta rama en particular, se implementa la funcionalidad de la pantalla de Login usando Firebase.  
Se abordan temas como:  
- Funcionamiento completo del login
- Registro de nuevos usuarios
- Firebase Auth Rest API
- Manejo de Tokens
- Alertas
- Habilitar autenticación en Firebase

Aquí vamos a trabajar en hacer funcional nuestro login y que nuestros servicios utilicen el token que Firebase nos regresará.