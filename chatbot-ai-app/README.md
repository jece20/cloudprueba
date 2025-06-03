# Chatbot AI App

Este proyecto es un chatbot con inteligencia artificial diseñado para permitir a los clientes consultar el estado de sus equipos en reparación, diagnóstico, etc.

## Estructura del Proyecto

El proyecto está organizado de la siguiente manera:

```
chatbot-ai-app
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── empresa
│   │   │           └── chatbot
│   │   │               ├── ChatbotApplication.java
│   │   │               ├── controller
│   │   │               │   └── ChatbotController.java
│   │   │               ├── service
│   │   │               │   └── ChatbotService.java
│   │   │               └── model
│   │   │                   └── ConsultaEstadoRequest.java
│   │   └── resources
│   │       ├── application.properties
│   │       └── templates
│   │           └── index.html
│   └── test
│       └── java
│           └── com
│               └── empresa
│                   └── chatbot
│                       └── ChatbotApplicationTests.java
├── pom.xml
└── README.md
```

## Requisitos

- Java 11 o superior
- Maven

## Configuración

1. Clona el repositorio:
   ```
   git clone <URL_DEL_REPOSITORIO>
   ```

2. Navega al directorio del proyecto:
   ```
   cd chatbot-ai-app
   ```

3. Compila el proyecto usando Maven:
   ```
   mvn clean install
   ```

4. Configura la base de datos en `src/main/resources/application.properties`.

## Ejecución

Para ejecutar la aplicación, utiliza el siguiente comando:
```
mvn spring-boot:run
```

La aplicación estará disponible en `http://localhost:8080`.

## Uso

Los clientes pueden interactuar con el chatbot a través de la interfaz de usuario en `index.html`, donde podrán consultar el estado de sus equipos ingresando el ID del equipo.

## Pruebas

Las pruebas unitarias se encuentran en `src/test/java/com/empresa/chatbot/ChatbotApplicationTests.java`. Para ejecutar las pruebas, utiliza el siguiente comando:
```
mvn test
```

## Contribuciones

Las contribuciones son bienvenidas. Si deseas contribuir, por favor abre un issue o envía un pull request.

## Licencia

Este proyecto está bajo la Licencia MIT.