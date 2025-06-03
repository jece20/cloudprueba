# Imagen base
FROM tomcat:9.0-jdk17

# Directorio de trabajo del contenedor
WORKDIR /usr/local/tomcat/webapps/AFORMULARIO_CLOUD

# Copia todo el contenido del proyecto JSP (menos los JARs)
COPY . /usr/local/tomcat/webapps/AFORMULARIO_CLOUD

# Copiar librerías necesarias al contenedor
COPY ./WEB-INF/lib/*.jar /usr/local/tomcat/webapps/AFORMULARIO_CLOUD/WEB-INF/lib/

# Exponer el puerto
EXPOSE 8080

# Comando para iniciar Tomcat (opcional, ya viene por defecto)
CMD ["catalina.sh", "run"]
