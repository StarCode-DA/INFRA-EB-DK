# 🐳 Eclipse Bar — Infraestructura (INFRA-EB-DK)

Repositorio de infraestructura del sistema **Eclipse Bar**. Contiene la configuración de Docker Compose, base de datos PostgreSQL y el script de inicialización SQL.

---

## 📋 Tabla de contenido

- [Estructura del repositorio](#estructura-del-repositorio)
- [Requisitos previos](#requisitos-previos)
- [Servicios](#servicios)
- [Variables de entorno](#variables-de-entorno)
- [Base de datos](#base-de-datos)
- [Levantar el sistema](#levantar-el-sistema)
- [Usuarios de prueba](#usuarios-de-prueba)
- [Comandos útiles](#comandos-útiles)

---

## 📁 Estructura del repositorio

```
INFRA-EB-DK/
├── compose/
│   ├── docker-compose.yml      # Compose principal (producción)
│   └── .env                    # Variables de entorno
└── database/
    └── init.sql                # Script de inicialización de la base de datos
```

---

## ✅ Requisitos previos

- [Docker](https://www.docker.com/) >= 24
- [Docker Compose](https://docs.docker.com/compose/) >= 2
- Los repositorios de los microservicios y frontend deben estar clonados en la misma carpeta raíz:

```
/StarCode-DA/
├── INFRA-EB-DK/
├── FR-EB-RT/           # Frontend React
├── MS-AUTH-PY/         # Microservicio de autenticación
└── MS-USER-PY/         # Microservicio de usuarios
```

---

## 🧩 Servicios

| Contenedor     | Descripción                        | Puerto externo |
|----------------|------------------------------------|---------------|
| `eb-frontend`  | Interfaz web (React + Nginx)       | 3000          |
| `eb-auth`      | Microservicio de autenticación     | 8001          |
| `eb-user`      | Microservicio de usuarios          | 8002          |
| `eb-postgres`  | Base de datos PostgreSQL           | 5437          |

> El puerto externo de PostgreSQL es `5437` para evitar conflictos con instalaciones locales en el puerto por defecto `5432`.

---

## 🔧 Variables de entorno

Crea o edita el archivo `.env` dentro de la carpeta `compose/` con los siguientes valores:

```env
# Base de datos
POSTGRES_DB=eclipsebar_db
POSTGRES_USER=eb_user
POSTGRES_PASSWORD=eb_pass
POSTGRES_PORT=5437

# Seguridad JWT
SECRET_KEY=super-secret-key-change-this
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60

# Puertos de servicios
FRONTEND_PORT=3000
MS_AUTH_PORT=8001
MS_USER_PORT=8002

# Entorno
DEBUG=False
ENVIRONMENT=production
```

> ⚠️ **Importante:** Cambia `SECRET_KEY` por una clave segura antes de desplegar en producción.

---

## 🗄️ Base de datos

El archivo `database/init.sql` se ejecuta automáticamente la primera vez que se levanta el contenedor de PostgreSQL. Crea las siguientes tablas:

| Tabla            | Descripción                              |
|------------------|------------------------------------------|
| `sedes`          | Sucursales del bar                       |
| `usuarios`       | Credenciales y roles de acceso           |
| `meseros`        | Perfil de meseros                        |
| `cajeros`        | Perfil de cajeros                        |
| `administradores`| Perfil de administradores                |

Los datos de la base de datos persisten en un volumen Docker llamado `postgres_data`, por lo que no se pierden al reiniciar los contenedores.

> ⚠️ El script `init.sql` solo se ejecuta si la base de datos está vacía. Si ya existe el volumen, no se vuelve a ejecutar.

---

## 🚀 Levantar el sistema

```bash
# Ubicarse en la carpeta compose
cd INFRA-EB-DK/compose

# Levantar todos los servicios
docker compose up -d

# Ver logs en tiempo real
docker compose logs -f

# Detener todos los servicios
docker compose down
```

Para reconstruir las imágenes (por ejemplo, tras cambios en el código):

```bash
docker compose up -d --build
```

Para eliminar también los volúmenes (⚠️ borra los datos de la base de datos):

```bash
docker compose down -v
```

---

## 👥 Usuarios de prueba

El script `init.sql` inserta los siguientes usuarios por defecto:

| Email                      | Contraseña   | Rol            | Sede      |
|----------------------------|--------------|----------------|-----------|
| admin@eclipsebar.com       | Admin1234    | Administrador  | Todas     |
| mesero1@eclipsebar.com     | Mesero1234   | Mesero         | Galerías  |
| cajero1@eclipsebar.com     | Cajero1234   | Cajero         | Restrepo  |

> ⚠️ Cambia estas contraseñas en producción.

---

## 🛠️ Comandos útiles

```bash
# Ver contenedores corriendo
docker ps

# Ver logs de un servicio específico
docker compose logs eb-auth
docker compose logs eb-user
docker compose logs eb-frontend

# Acceder a la base de datos
docker exec -it eb-postgres psql -U eb_user -d eclipsebar_db

# Reiniciar un servicio específico
docker compose restart eb-auth
```
