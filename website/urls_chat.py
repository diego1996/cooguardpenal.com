"""
URLs para el sistema de chat con N8N
"""
from django.urls import path
from .views_chat import (
    N8NResponseReceiver,
    ChatPollingView,
    chat_status,
    chat_health
)

app_name = 'chat'

urlpatterns = [
    # Endpoint para recibir respuestas de N8N
    path('n8n/response/', N8NResponseReceiver.as_view(), name='n8n_response'),
    
    # Endpoint para polling de respuestas
    path('poll-response/', ChatPollingView.as_view(), name='poll_response'),
    
    # Status y health checks
    path('status/', chat_status, name='status'),
    path('health/', chat_health, name='health'),
]
