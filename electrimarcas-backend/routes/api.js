// backend/routes/api.js
const express = require('express');
const router = express.Router();
//acceso a la bd
const db = require('../models/consumos.js'); 
const { formatDataForChartJS } = require('../utils/dataFormatter'); // Función de formato
const { formatDataForCardList } = require('../utils/dataFormatter');

// Importar módulos de autenticación
const authModel = require('../models/auth.js');
const { generateToken, authenticateToken } = require('../middleware/auth.js');
// La ruta que el frontend de Vue llamará: http://localhost:3000/api/data-grafica
router.get('/data-grafica', async (req, res) => {
  try {
    // 1. Obtención de datos brutos de la DB
    const datosRaw = await db.fetchConsumoData(); 
    // 2. Formateo de los datos para la librería de gráficas (Chart.js)
    const datosGrafico = formatDataForChartJS(datosRaw);

    // 3. Respuesta de éxito (Status 200 OK)
    res.status(200).json({
      success: true,
      data: datosGrafico // El objeto que Vue usará
    });

  } catch (error) {
    console.error('Error en la ruta /data-grafica:', error);
    // Respuesta de error (Status 500 Internal Server Error)
    res.status(500).json({ 
      success: false, 
      message: 'Error al procesar los datos del servidor.' 
    });
  }
});

// ENDPOINT para la Lista de Cards
router.get('/dispositivos-lista', async (req, res) => {
    try {
        // 1. Obtención de datos brutos de la DB
        const dispositivosRaw = await db.fetchElectrodomesticosList(); 

        // 2. Formateo de los datos para la Card
        const cardList = formatDataForCardList(dispositivosRaw);

        // 3. Respuesta de éxito (Status 200 OK)
        res.status(200).json({
            success: true,
            data: cardList // Array de Cards listos para Vue
        });

    } catch (error) {
        console.error('❌ Error en la ruta /dispositivos-lista:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error al obtener la lista de dispositivos.' 
        });
    }
});

// ===========================================
// RUTAS DE AUTENTICACIÓN
// ===========================================

/**
 * POST /api/login
 * Iniciar sesión de usuario
 */
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validar datos de entrada
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email y contraseña son requeridos'
      });
    }

    // Buscar usuario en la base de datos
    const user = await authModel.findUserByEmail(email);
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales incorrectas'
      });
    }

    // Verificar contraseña
    const isValidPassword = await authModel.verifyPassword(password, user.contraseña_hash);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales incorrectas'
      });
    }

    // Generar token JWT
    const token = generateToken(user);

    // Respuesta exitosa
    res.status(200).json({
      success: true,
      message: 'Inicio de sesión exitoso',
      data: {
        token,
        user: {
          id: user.id_usuario,
          nombre: user.nombre_completo,
          email: user.correo_electronico
        }
      }
    });

  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
});

/**
 * POST /api/register
 * Registrar nuevo usuario
 */
router.post('/register', async (req, res) => {
  try {
    const { nombre, email, password, id_municipio } = req.body;

    // Validar datos de entrada
    if (!nombre || !email || !password || !id_municipio) {
      return res.status(400).json({
        success: false,
        message: 'Todos los campos son requeridos'
      });
    }

    // Verificar si el usuario ya existe
    const existingUser = await authModel.findUserByEmail(email);
    if (existingUser) {
      return res.status(409).json({
        success: false,
        message: 'El usuario ya existe'
      });
    }

    // Generar ID único para el usuario
    const id_usuario = 'U' + Date.now().toString().slice(-5);

    // Hashear contraseña
    const contraseña_hash = await authModel.hashPassword(password);

    // Crear usuario
    await authModel.createUser({
      id_usuario,
      id_municipio: parseInt(id_municipio),
      nombre_completo: nombre,
      correo_electronico: email,
      contraseña_hash
    });

    res.status(201).json({
      success: true,
      message: 'Usuario registrado exitosamente'
    });

  } catch (error) {
    console.error('Error en registro:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
});

/**
 * GET /api/verify-token
 * Verificar si el token es válido
 */
router.get('/verify-token', authenticateToken, (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Token válido',
    data: {
      user: req.user
    }
  });
});

/**
 * POST /api/logout
 * Cerrar sesión (el frontend debe eliminar el token)
 */
router.post('/logout', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Sesión cerrada exitosamente'
  });
});

// ===========================================
// RUTAS PROTEGIDAS (requieren autenticación)
// ===========================================

// Proteger las rutas existentes con autenticación
router.get('/data-grafica', authenticateToken, async (req, res) => {
  try {
    // 1. Obtención de datos brutos de la DB
    const datosRaw = await db.fetchConsumoData(); 
    // 2. Formateo de los datos para la librería de gráficas (Chart.js)
    const datosGrafico = formatDataForChartJS(datosRaw);

    // 3. Respuesta de éxito (Status 200 OK)
    res.status(200).json({
      success: true,
      data: datosGrafico // El objeto que Vue usará
    });

  } catch (error) {
    console.error('Error en la ruta /data-grafica:', error);
    // Respuesta de error (Status 500 Internal Server Error)
    res.status(500).json({ 
      success: false, 
      message: 'Error al procesar los datos del servidor.' 
    });
  }
});

// ENDPOINT para la Lista de Cards (protegido)
router.get('/dispositivos-lista', authenticateToken, async (req, res) => {
    try {
        // 1. Obtención de datos brutos de la DB
        const dispositivosRaw = await db.fetchElectrodomesticosList(); 

        // 2. Formateo de los datos para la Card
        const cardList = formatDataForCardList(dispositivosRaw);

        // 3. Respuesta de éxito (Status 200 OK)
        res.status(200).json({
            success: true,
            data: cardList // Array de Cards listos para Vue
        });

    } catch (error) {
        console.error('❌ Error en la ruta /dispositivos-lista:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error al obtener la lista de dispositivos.' 
        });
    }
});

module.exports = router;