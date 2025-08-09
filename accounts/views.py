from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.views.decorators.http import require_http_methods
from django.core.mail import send_mail
from django.conf import settings
from .models import User
from .forms import RegisterForm, LoginForm
import uuid


def register_view(request):
    """Vista de pre-registro para usuarios"""
    if request.method == 'POST':
        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            user.status = 'pending_approval'
            user.is_active = False  # Usuario inactivo hasta aprobación
            user.save()
            
            # Enviar notificación a admins
            try:
                send_mail(
                    'Nuevo Pre-registro en COOGUARDPENAL',
                    f'Un nuevo usuario se ha pre-registrado:\n\n'
                    f'Nombre: {user.nombres} {user.apellidos}\n'
                    f'Email: {user.email}\n'
                    f'Cédula: {user.cedula}\n'
                    f'Cargo: {user.cargo}\n\n'
                    f'Ingresa al admin para revisar y aprobar.',
                    settings.DEFAULT_FROM_EMAIL,
                    [admin.email for admin in User.objects.filter(role='admin', is_active=True)],
                    fail_silently=True,
                )
            except:
                pass
            
            messages.success(request, 
                '¡Pre-registro exitoso! Tu solicitud será revisada por nuestro equipo. '
                'Recibirás un email cuando tu cuenta sea aprobada.')
            return redirect('accounts:login')
    else:
        form = RegisterForm()
    
    return render(request, 'accounts/register.html', {'form': form})


def login_view(request):
    """Vista de login"""
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            
            user = authenticate(request, username=email, password=password)
            if user is not None:
                if user.status == 'pending_approval':
                    messages.warning(request, 
                        'Tu cuenta está pendiente de aprobación. '
                        'Serás notificado por email cuando sea activada.')
                    return render(request, 'accounts/login.html', {'form': form})
                elif user.status == 'suspended':
                    messages.error(request, 
                        'Tu cuenta ha sido suspendida. Contacta al administrador.')
                    return render(request, 'accounts/login.html', {'form': form})
                elif user.status == 'active':
                    login(request, user)
                    messages.success(request, f'¡Bienvenido, {user.nombres}!')
                    
                    # Redirección según rol
                    if user.role == 'admin' and user.is_staff:
                        return redirect('/admin/')
                    else:
                        return redirect('website:portal')
                else:
                    messages.error(request, 'Estado de cuenta no válido.')
            else:
                messages.error(request, 'Email o contraseña incorrectos.')
    else:
        form = LoginForm()
    
    return render(request, 'accounts/login.html', {'form': form})


@require_http_methods(["POST"])
def logout_view(request):
    """Vista de logout"""
    user_name = request.user.nombres if request.user.is_authenticated else None
    logout(request)
    if user_name:
        messages.success(request, f'¡Hasta pronto, {user_name}!')
    return redirect('website:index')


@login_required
def profile_view(request):
    """Vista del perfil del usuario"""
    return render(request, 'accounts/profile.html', {'user': request.user})


@login_required
def portal_view(request):
    """Vista del portal para usuarios aprobados"""
    if request.user.status != 'active':
        messages.error(request, 'Tu cuenta no está activa. Contacta al administrador.')
        return redirect('website:index')
    
    return render(request, 'accounts/portal.html', {'user': request.user})