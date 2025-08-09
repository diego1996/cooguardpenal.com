from django.shortcuts import render


def index(request):
    return render(request, 'website/index.html')


def about(request):
    return render(request, 'website/about.html')


def services(request):
    return render(request, 'website/services.html')


def news(request):
    return render(request, 'website/news.html')


def contact(request):
    return render(request, 'website/contact.html')


def portal(request):
    return render(request, 'website/portal.html')
