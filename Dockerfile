# ---------- Builder stage ----------
    FROM python:3.11-slim AS builder

    # Instala dependencias de compilación
    RUN apt-get update \
        && apt-get install -y --no-install-recommends \
           build-essential \
           libpq-dev \
        && rm -rf /var/lib/apt/lists/*
    
    # Prepara pip para generar ruedas
    RUN pip install --upgrade pip setuptools wheel
    
    WORKDIR /wheels
    
    # Copia únicamente requirements.txt y genera los wheels
    COPY requirements.txt requirements.txt
    RUN pip wheel --no-cache-dir --no-deps --wheel-dir . -r requirements.txt
    
    # ---------- Final stage ----------
    FROM python:3.11-slim
    
    # Instala dependencias de runtime
    RUN apt-get update \
        && apt-get install -y --no-install-recommends \
           libpq5 \
        && rm -rf /var/lib/apt/lists/*
    
    WORKDIR /app
    
    # Copia solo los .whl del builder e instálalos
    COPY --from=builder /wheels/*.whl /wheels/
    RUN pip install --no-cache-dir /wheels/*.whl
    
    # Copia el resto de la aplicación
    COPY . .
    
    # Define variables de entorno para producción
    ENV PYTHONUNBUFFERED=1 \
        DJANGO_SETTINGS_MODULE=cooguardpenal.settings \
        DEBUG=False \
        ALLOWED_HOSTS=cooguardpenal.online,www.cooguardpenal.online
    
    # Crea directorios necesarios
    RUN mkdir -p /app/media /app/statics /app/logs
    
    # Configura permisos para archivos media
    RUN chmod -R 755 /app/media /app/statics /app/logs
    
    # Colecta archivos estáticos con WhiteNoise
    RUN python manage.py collectstatic --noinput --clear
    
    # Expone el puerto de la aplicación
    EXPOSE 8000
    
    # Arranca con Gunicorn optimizado para WhiteNoise
    CMD ["gunicorn", "cooguardpenal.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3", "--timeout", "120", "--max-requests", "1000", "--max-requests-jitter", "100"]