import locale
import pandas as pd
import datetime
import unidecode

# Leer el CSV original (limpieza)
electrodomesticos = pd.read_csv(
    r'C:\Users\israe\OneDrive\Documentos\Universidad\Septimo Semestre\Taller de Inv 2\electrodomesticos_limpieza_200.csv',
    encoding='utf-8'
)

# Procesar limpieza
electrodomesticos['voltaje'] = electrodomesticos['voltaje'].astype(str).str.replace('V', '', regex=False).str.strip()
electrodomesticos['potencia'] = electrodomesticos['potencia'].astype(str).str.replace('W', '', regex=False).str.strip()
electrodomesticos['descripcion'] = electrodomesticos['descripcion'].astype(str).str.replace('"', '', regex=False).str.replace("'", '', regex=False)
electrodomesticos.insert(0, 'nombre_categoria', 'limpieza')

# Leer el CSV de cocina
cocina = pd.read_csv(
    r'C:\Users\israe\OneDrive\Documentos\Universidad\Septimo Semestre\Taller de Inv 2\electrodomesticos_cocina_200.csv',
    encoding='utf-8'
)

# Procesar cocina
cocina['voltaje'] = cocina['voltaje'].astype(str).str.replace('V', '', regex=False).str.strip()
cocina['potencia'] = cocina['potencia'].astype(str).str.replace('W', '', regex=False).str.strip()
cocina['descripcion'] = cocina['descripcion'].astype(str).str.replace('"', '', regex=False).str.replace("'", '', regex=False)
cocina.insert(0, 'nombre_categoria', 'cocina')

# Generar IDs continuando los existentes
ultimo_id = len(electrodomesticos)
cocina['id_electrodomestico'] = ['E{:05d}'.format(i) for i in range(ultimo_id + 1, ultimo_id + 1 + len(cocina))]
cocina['id_marca'] = ['M{:05d}'.format(i) for i in range(ultimo_id + 1, ultimo_id + 1 + len(cocina))]
cocina['id_modelo'] = ['MD{:04d}'.format(i) for i in range(ultimo_id + 1, ultimo_id + 1 + len(cocina))]

# Reordenar columnas para que coincidan
cocina = cocina[electrodomesticos.columns]

# Unir ambos DataFrames
tabla_final = pd.concat([electrodomesticos, cocina], ignore_index=True)

# Guardar el resultado
tabla_final.to_csv('tabla_electrodomesticos.csv', index=False)


