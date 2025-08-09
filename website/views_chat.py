"""
Views para el sistema de chat con N8N
"""
import json
import time
from datetime import datetime, timedelta
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.core.cache import cache
from django.utils.decorators import method_decorator
from django.views.generic import View
import logging

logger = logging.getLogger(__name__)


class ChatResponseStorage:
    """Manejo de almacenamiento temporal de respuestas del chat"""
    
    @staticmethod
    def store_response(session_id, conversation_id, response_text):
        """Almacenar respuesta del agente N8N"""
        cache_key = f"chat_response_{session_id}_{conversation_id}"
        response_data = {
            'response': response_text,
            'timestamp': datetime.now().isoformat(),
            'has_response': True
        }
        # Almacenar por 5 minutos
        cache.set(cache_key, response_data, timeout=300)
        logger.info(f"✅ Stored N8N response for {cache_key}")
        
    @staticmethod
    def get_response(session_id, conversation_id):
        """Obtener respuesta almacenada"""
        cache_key = f"chat_response_{session_id}_{conversation_id}"
        response_data = cache.get(cache_key)
        
        if response_data:
            # Limpiar después de obtener
            cache.delete(cache_key)
            logger.info(f"📤 Retrieved and cleared response for {cache_key}")
        
        return response_data


@method_decorator(csrf_exempt, name='dispatch')
class N8NResponseReceiver(View):
    """Endpoint para recibir respuestas del agente N8N"""
    
    def post(self, request):
        try:
            data = json.loads(request.body)
            
            # Extraer datos del webhook de N8N
            session_id = data.get('session_id')
            conversation_id = data.get('conversation_id')  
            agent_response = data.get('response', data.get('agent_response'))
            
            if not all([session_id, conversation_id, agent_response]):
                return JsonResponse({
                    'success': False,
                    'error': 'Missing required fields: session_id, conversation_id, response'
                }, status=400)
            
            # Almacenar respuesta
            ChatResponseStorage.store_response(
                session_id=session_id,
                conversation_id=conversation_id,
                response_text=agent_response
            )
            
            logger.info(f"🎯 N8N response received for session {session_id}")
            
            return JsonResponse({
                'success': True,
                'message': 'Response stored successfully',
                'session_id': session_id,
                'conversation_id': conversation_id
            })
            
        except json.JSONDecodeError:
            return JsonResponse({
                'success': False,
                'error': 'Invalid JSON payload'
            }, status=400)
            
        except Exception as e:
            logger.error(f"❌ Error processing N8N response: {e}")
            return JsonResponse({
                'success': False,
                'error': 'Internal server error'
            }, status=500)


@method_decorator(csrf_exempt, name='dispatch')  
class ChatPollingView(View):
    """Endpoint para polling de respuestas del chat"""
    
    def post(self, request):
        try:
            data = json.loads(request.body)
            session_id = data.get('session_id')
            conversation_id = data.get('conversation_id')
            
            if not all([session_id, conversation_id]):
                return JsonResponse({
                    'has_response': False,
                    'error': 'Missing session_id or conversation_id'
                }, status=400)
            
            # Buscar respuesta
            response_data = ChatResponseStorage.get_response(session_id, conversation_id)
            
            if response_data:
                return JsonResponse({
                    'has_response': True,
                    'response': response_data['response'],
                    'timestamp': response_data['timestamp']
                })
            else:
                return JsonResponse({
                    'has_response': False,
                    'waiting': True
                })
                
        except json.JSONDecodeError:
            return JsonResponse({
                'has_response': False,
                'error': 'Invalid JSON payload'
            }, status=400)
            
        except Exception as e:
            logger.error(f"❌ Error in chat polling: {e}")
            return JsonResponse({
                'has_response': False,
                'error': 'Internal server error'
            }, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def chat_status(request):
    """Endpoint para verificar el estado del sistema de chat"""
    return JsonResponse({
        'status': 'active',
        'system': 'N8N Chat Integration',
        'version': '1.0',
        'timestamp': datetime.now().isoformat(),
        'capabilities': [
            'Real-time chat with N8N',
            'Session management',
            'Response polling',
            'Fallback responses'
        ]
    })


@csrf_exempt  
@require_http_methods(["GET"])
def chat_health(request):
    """Health check para el sistema de chat"""
    try:
        # Test cache connection
        test_key = f"health_check_{int(time.time())}"
        cache.set(test_key, 'ok', timeout=60)
        cache_status = cache.get(test_key) == 'ok'
        cache.delete(test_key)
        
        return JsonResponse({
            'healthy': True,
            'cache_working': cache_status,
            'timestamp': datetime.now().isoformat(),
            'uptime': 'OK'
        })
        
    except Exception as e:
        return JsonResponse({
            'healthy': False,
            'error': str(e),
            'timestamp': datetime.now().isoformat()
        }, status=500)
