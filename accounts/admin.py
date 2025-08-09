from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin
from .models import User


@admin.register(User)
class UserAdmin(DjangoUserAdmin):
    ordering = ('email',)
    list_display = (
        'email', 'nombres', 'apellidos', 'role', 'status', 'is_active', 'is_staff', 'created_at'
    )
    list_filter = ('role', 'status', 'is_active', 'is_staff')
    search_fields = ('email', 'cedula', 'nombres', 'apellidos', 'numero_asociado')

    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Información Personal', {
            'fields': (
                'cedula', 'nombres', 'apellidos', 'fecha_nacimiento', 'telefono', 'celular',
                'direccion', 'ciudad', 'departamento',
            )
        }),
        ('Información Laboral', {
            'fields': (
                'lugar_trabajo', 'cargo', 'salario_base', 'fecha_ingreso_cooperativa', 'numero_asociado'
            )
        }),
        ('Configuración Financiera', {'fields': ('descuento_maximo_porcentaje',)}),
        ('Permisos', {'fields': ('role', 'status', 'is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Fechas', {'fields': ('last_login', 'created_at', 'updated_at')}),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2', 'cedula', 'nombres', 'apellidos', 'role', 'status')
        }),
    )
