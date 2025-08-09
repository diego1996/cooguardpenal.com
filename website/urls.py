from django.urls import path, include
from .views import index, about, services, news, contact, portal

urlpatterns = [
    path('', index, name='website_index'),
    path('nosotros/', about, name='website_about'),
    path('servicios/', services, name='website_services'),
    path('noticias/', news, name='website_news'),
    path('contacto/', contact, name='website_contact'),
    path('portal/', portal, name='website_portal'),
    
    # Sistema de chat con N8N
    path('api/chat/', include('website.urls_chat')),
]


