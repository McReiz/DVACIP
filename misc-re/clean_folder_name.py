#!/usr/bin/env python3

import os
import re
import unicodedata
import shutil

def limpiar_texto(texto):
    # 1. Quitar (SPOTISAVER)
    texto = texto.replace(" (SPOTISAVER)", "")
    
    # 2. Normalizar acentos (á -> a, ñ -> n)
    texto = unicodedata.normalize('NFKD', texto).encode('ASCII', 'ignore').decode('utf-8')
    
    # 3. Eliminar caracteres especiales (mantener solo letras, números, espacios, puntos y guiones)
    # [^a-zA-Z0-9\s\.\-] significa: "borra todo lo que no sea esto"
    texto = re.sub(r'[^a-zA-Z0-9\s\.\-]', '', texto)
    
    # 4. Limpiar espacios extra y espacios al inicio/final
    texto = re.sub(r'\s+', ' ', texto).strip()
    return texto

def procesar_archivos():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    dir_espera = os.path.join(base_dir, "espera")
    dir_listo = os.path.join(base_dir, "listo")

    if not os.path.exists(dir_listo):
        os.makedirs(dir_listo)

    archivos = [f for f in os.listdir(dir_espera) if f.endswith(".mp3")]
    
    for i, archivo in enumerate(archivos, 1):
        nombre_base, ext = os.path.splitext(archivo)
        
        # Limpiar el nombre
        nombre_limpio = limpiar_texto(nombre_base)
        
        # Invertir el nombre usando " - "
        if " - " in nombre_limpio:
            partes = nombre_limpio.split(" - ", 1)
            artista = partes[0].strip()
            cancion = partes[1].strip()
            nuevo_nombre = f"{cancion} - {artista}{ext}"
        else:
            # Si no hay guion, solo se limpia el nombre
            nuevo_nombre = f"{nombre_limpio}{ext}"
        
        # Mover archivo
        origen = os.path.join(dir_espera, archivo)
        destino = os.path.join(dir_listo, nuevo_nombre)
        
        shutil.move(origen, destino)
        print(f"[{i}] Procesado: {archivo} -> {nuevo_nombre}")

if __name__ == "__main__":
    procesar_archivos()
    print("\nTarea completada con éxito.")