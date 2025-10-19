<template>
  <main class="inicio-sesion">
    <section class="login-container">
      <header class="login-header">
        <article class="logo-container">
          <img src="/electrimarcas.png" alt="ElectriMarcas Logo" class="logo" />
        </article>
        <h1>Iniciar Sesión</h1>
        <p>Accede a tu cuenta de ElectriMarcas</p>
      </header>
      
      <form @submit.prevent="iniciarSesion" class="login-form">
        <article class="form-group">
          <label for="email">Correo Electrónico</label>
          <input 
            type="email" 
            id="email" 
            v-model="credentials.email" 
            required 
            placeholder="usuario@ejemplo.com"
          />
        </article>
        
        <article class="form-group">
          <label for="password">Contraseña</label>
          <input 
            type="password" 
            id="password" 
            v-model="credentials.password" 
            required 
            placeholder="Tu contraseña"
          />
        </article>
        
        <article class="form-actions">
          <button type="submit" class="btn-login" :disabled="isLoading">
            {{ isLoading ? 'Iniciando...' : 'Iniciar Sesión' }}
          </button>
          
          <button type="button" @click="volverInicio" class="btn-back">
            Volver al Inicio
          </button>
        </article>
        
        <article class="login-links">
          <a href="#" @click.prevent="olvidoPassword">¿Olvidaste tu contraseña?</a>
          <a href="#" @click.prevent="crearCuenta">Crear nueva cuenta</a>
        </article>
      </form>
      
      <span v-if="error" class="error-message">
        {{ error }}
      </span>
    </section>
  </main>
</template>

<script>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

export default {
  name: 'InicioSesion',
  setup() {
    const router = useRouter()
    
    // Estado reactivo
    const credentials = ref({
      email: '',
      password: ''
    })
    
    const isLoading = ref(false)
    const error = ref('')
    
    // Métodos
    const iniciarSesion = async () => {
      isLoading.value = true
      error.value = ''
      
      try {
        // Aquí irá la lógica de autenticación
        console.log('Intentando iniciar sesión con:', credentials.value)
        
        // Simulación de autenticación (reemplazar con API real)
        await new Promise(resolve => setTimeout(resolve, 1000))
        
        // Si la autenticación es exitosa, redirigir al dashboard
        router.push('/Inicio')
        
      } catch (err) {
        error.value = 'Error al iniciar sesión. Verifica tus credenciales.'
        console.error('Error de autenticación:', err)
      } finally {
        isLoading.value = false
      }
    }
    
    const volverInicio = () => {
      router.push('/Inicio')
    }
    
    const olvidoPassword = () => {
      // Implementar lógica para recuperar contraseña
      console.log('Recuperar contraseña')
    }
    
    const crearCuenta = () => {
      // Implementar navegación a registro
      console.log('Crear nueva cuenta')
    }
    
    return {
      credentials,
      isLoading,
      error,
      iniciarSesion,
      volverInicio,
      olvidoPassword,
      crearCuenta
    }
  }
}
</script>

<style scoped lang="scss">
.inicio-sesion {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #66ea71 0%, #c3aed8 100%);
  padding: 20px;
}

.login-container {
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  max-width: 400px;
  width: 100%;
  padding: 40px;
  animation: fadeInUp 0.6s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
  
  .logo-container {
    margin-bottom: 20px;
    
    .logo {
      width: 120px;
      height: auto;
      max-width: 100%;
      filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
    }
  }
  
  h1 {
    color: #333;
    margin-bottom: 8px;
    font-size: 28px;
    font-weight: 600;
  }
  
  p {
    color: #666;
    font-size: 16px;
  }
}

.login-form {
  .form-group {
    margin-bottom: 20px;
    
    label {
      display: block;
      margin-bottom: 8px;
      color: #333;
      font-weight: 500;
      font-size: 14px;
    }
    
    input {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e1e5e9;
      border-radius: 8px;
      font-size: 16px;
      transition: all 0.3s ease;
      
      &:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
      }
      
      &::placeholder {
        color: #aaa;
      }
    }
  }
  
  .form-actions {
    margin: 30px 0 20px;
    display: flex;
    gap: 12px;
    flex-direction: column;
    
    .btn-login {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      padding: 14px 20px;
      border-radius: 8px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover:not(:disabled) {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
      }
      
      &:disabled {
        opacity: 0.7;
        cursor: not-allowed;
      }
    }
    
    .btn-back {
      background: transparent;
      color: #666;
      border: 2px solid #e1e5e9;
      padding: 12px 20px;
      border-radius: 8px;
      font-size: 14px;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover {
        background: #f8f9fa;
        border-color: #d1d5db;
      }
    }
  }
  
  .login-links {
    text-align: center;
    
    a {
      color: #667eea;
      text-decoration: none;
      font-size: 14px;
      display: block;
      margin: 8px 0;
      transition: color 0.3s ease;
      
      &:hover {
        color: #764ba2;
      }
    }
  }
}

.error-message {
  background: #fee;
  color: #c53030;
  padding: 12px;
  border-radius: 8px;
  font-size: 14px;
  margin-top: 20px;
  text-align: center;
}

// Responsivo
@media (max-width: 480px) {
  .login-container {
    margin: 20px;
    padding: 30px 20px;
  }
  
  .login-header h1 {
    font-size: 24px;
  }
  
  .form-actions {
    .btn-login, .btn-back {
      padding: 12px 16px;
    }
  }
}
</style>