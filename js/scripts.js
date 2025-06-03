// Scripts.js - Versión corregida para el manejo de estados
document.addEventListener('DOMContentLoaded', function () {
    // Configuración de estados
    const estadosConfig = {
        "Recibido": { clase: "badge bg-info", icono: "bi-clipboard-check" },
        "En diagnóstico": { clase: "badge bg-warning", icono: "bi-search" },
        "En reparación": { clase: "badge bg-primary", icono: "bi-tools" },
        "Reparado": { clase: "badge bg-success", icono: "bi-check-circle" },
        "Entregado": { clase: "badge bg-secondary", icono: "bi-box-arrow-right" }
    };

    let idDispositivoActual = null;
    let estadoActualDispositivo = null;
    let filaActual = null;

    // Función para manejar el click en botones de cambio de estado
    document.querySelectorAll('.btn-estado-modal').forEach(btn => {
        btn.addEventListener('click', function () {
            // Obtener datos del dispositivo
            idDispositivoActual = this.getAttribute('data-id');
            estadoActualDispositivo = this.getAttribute('data-estado-actual');
            filaActual = this.closest('tr');
            
            console.log('ID dispositivo:', idDispositivoActual);
            console.log('Estado actual:', estadoActualDispositivo);
            
            // Mostrar modal con estados disponibles
            mostrarModalEstados();
        });
    });

    // Función para mostrar el modal con los estados
    function mostrarModalEstados() {
        const listaEstados = document.getElementById('listaEstados');
        listaEstados.innerHTML = '';

        // Crear botón para cada estado
        Object.keys(estadosConfig).forEach(estado => {
            const btnEstado = document.createElement('button');
            btnEstado.type = 'button';
            btnEstado.className = 'btn btn-outline-primary d-flex align-items-center justify-content-start';
            
            // Marcar el estado actual como activo
            if (estado === estadoActualDispositivo) {
                btnEstado.classList.add('active');
            }
            
            btnEstado.innerHTML = `<i class="bi ${estadosConfig[estado].icono} me-2"></i> ${estado}`;
            
            // Evento click para cambiar estado
            btnEstado.addEventListener('click', function () {
                if (estado !== estadoActualDispositivo) {
                    cambiarEstadoDispositivo(idDispositivoActual, estado);
                }
                // Cerrar modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('modalEstados'));
                modal.hide();
            });
            
            listaEstados.appendChild(btnEstado);
        });

        // Mostrar el modal
        const modal = new bootstrap.Modal(document.getElementById('modalEstados'));
        modal.show();
    }

    // Función para cambiar el estado del dispositivo
    function cambiarEstadoDispositivo(idDispositivo, nuevoEstado) {
        console.log('Cambiando estado a:', nuevoEstado, 'para dispositivo:', idDispositivo);
        
        // Mostrar indicador de carga
        const btnEstado = filaActual.querySelector('.btn-estado-modal');
        const textoOriginal = btnEstado.innerHTML;
        btnEstado.innerHTML = '<i class="bi bi-arrow-repeat spin me-1"></i> Actualizando...';
        btnEstado.disabled = true;

        // Realizar petición AJAX
        fetch(`completarServicio.jsp?id=${idDispositivo}&estado=${encodeURIComponent(nuevoEstado)}`, {
            method: 'GET',
            headers: {
                'Cache-Control': 'no-cache'
            }
        })
        .then(response => {
            console.log('Respuesta recibida:', response.status);
            if (!response.ok) {
                throw new Error(`Error HTTP: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Datos recibidos:', data);
            
            if (data.exito) {
                // Actualizar el badge de estado en la tabla
                const badge = filaActual.querySelector('td span.badge');
                if (badge) {
                    badge.className = estadosConfig[nuevoEstado].clase;
                    badge.innerHTML = `<i class="bi ${estadosConfig[nuevoEstado].icono}"></i> ${nuevoEstado}`;
                }

                // Actualizar el atributo data-estado-actual del botón
                btnEstado.setAttribute('data-estado-actual', nuevoEstado);

                // Mostrar mensaje de confirmación
                mostrarModalConfirmacion(nuevoEstado);
                
                console.log('Estado actualizado correctamente');
            } else {
                throw new Error(data.mensaje || 'Error desconocido');
            }
        })
        .catch(error => {
            console.error('Error al actualizar estado:', error);
            alert('Error al actualizar el estado: ' + error.message);
        })
        .finally(() => {
            // Restaurar botón
            btnEstado.innerHTML = textoOriginal;
            btnEstado.disabled = false;
        });
    }

    // Función para mostrar modal de confirmación
    function mostrarModalConfirmacion(nuevoEstado) {
        const modal = new bootstrap.Modal(document.getElementById('confirmacionModal'));
        const modalHeader = document.querySelector('#confirmacionModal .modal-header');
        const modalTitle = document.querySelector('#confirmacionModalLabel');
        const mensajeConfirmacion = document.getElementById('mensajeConfirmacion');

        // Configurar el modal según el estado
        modalHeader.className = 'modal-header ' + estadosConfig[nuevoEstado].clase.replace('badge', 'bg');
        modalTitle.innerHTML = `<i class="bi ${estadosConfig[nuevoEstado].icono} me-2"></i> Estado Actualizado`;
        mensajeConfirmacion.innerHTML = `El dispositivo ha sido actualizado a: <strong>${nuevoEstado}</strong>`;

        modal.show();
    }

    // Agregar estilos para la animación de carga
    if (!document.getElementById('spin-styles')) {
        const style = document.createElement('style');
        style.id = 'spin-styles';
        style.innerHTML = `
            .spin {
                animation: spin 1s linear infinite;
            }
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
        `;
        document.head.appendChild(style);
    }
});

// Validación de formularios y navegación multistep (mantener tal como está)
document.addEventListener('DOMContentLoaded', function () {
    // Elementos del formulario
    const servicioForm = document.getElementById('servicioForm');
    const formSections = document.querySelectorAll('.form-section');
    const nextButtons = document.querySelectorAll('.next-btn');
    const prevButtons = document.querySelectorAll('.prev-btn');
    const progressBar = document.getElementById('formProgress');
    const clienteExistente = document.getElementById('clienteExistente');
    const seleccionClienteExistente = document.getElementById('seleccionClienteExistente');
    const nuevoClienteForm = document.getElementById('nuevoClienteForm');
    const clienteSelect = document.getElementById('clienteSelect');

    let currentStep = 0;
    const totalSteps = formSections.length;

    // Mostrar el paso actual y actualizar barra de progreso
    function showStep(stepIndex) {
        formSections.forEach((section, idx) => {
            section.style.display = idx === stepIndex ? 'block' : 'none';
        });
        const percent = ((stepIndex + 1) / totalSteps * 100).toFixed(0);
        if (progressBar) {
            progressBar.style.width = percent + '%';
            progressBar.textContent = percent + '%';
            progressBar.setAttribute('aria-valuenow', percent);
        }
    }

    // Alternar cliente existente/nuevo
    if (clienteExistente) {
        clienteExistente.addEventListener('change', function () {
            if (this.checked) {
                seleccionClienteExistente.style.display = 'block';
                nuevoClienteForm.style.display = 'none';
                // Quitar required de los inputs de nuevo cliente
                nuevoClienteForm.querySelectorAll('input, select, textarea').forEach(input => {
                    if (input.hasAttribute('required')) {
                        input.dataset.wasRequired = 'true';
                        input.removeAttribute('required');
                    }
                });
                if (clienteSelect) clienteSelect.setAttribute('required', '');
            } else {
                seleccionClienteExistente.style.display = 'none';
                nuevoClienteForm.style.display = 'block';
                // Restaurar required
                nuevoClienteForm.querySelectorAll('input, select, textarea').forEach(input => {
                    if (input.dataset.wasRequired === 'true') {
                        input.setAttribute('required', '');
                        delete input.dataset.wasRequired;
                    }
                });
                if (clienteSelect) clienteSelect.removeAttribute('required');
            }
        });
    }

    // Obtener campos requeridos visibles
    function getVisibleRequiredInputs(section) {
        return Array.from(section.querySelectorAll('[required]')).filter(input => {
            return input.offsetParent !== null;
        });
    }

    // Botón siguiente
    nextButtons.forEach(button => {
        button.addEventListener('click', function () {
            const currentSection = formSections[currentStep];
            const inputs = getVisibleRequiredInputs(currentSection);
            let isValid = true;

            inputs.forEach(input => {
                if (!input.checkValidity()) {
                    input.classList.add('is-invalid');
                    isValid = false;
                } else {
                    input.classList.remove('is-invalid');
                    input.classList.add('is-valid');
                }
            });

            if (isValid) {
                currentStep++;
                if (currentStep < totalSteps) {
                    showStep(currentStep);
                    window.scrollTo(0, 0);
                }
            } else {
                // Foco en el primer campo inválido
                const firstInvalid = currentSection.querySelector('.is-invalid');
                if (firstInvalid) firstInvalid.focus();
            }
        });
    });

    // Botón anterior
    prevButtons.forEach(button => {
        button.addEventListener('click', function () {
            currentStep--;
            if (currentStep >= 0) {
                showStep(currentStep);
                window.scrollTo(0, 0);
            }
        });
    });

    // Validación final al enviar
    if (servicioForm) {
        servicioForm.addEventListener('submit', function (event) {
            let isValidForm = true;
            formSections.forEach((section, index) => {
                const inputs = getVisibleRequiredInputs(section);
                inputs.forEach(input => {
                    if (!input.checkValidity()) {
                        input.classList.add('is-invalid');
                        isValidForm = false;
                    } else {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                    }
                });
                if (!isValidForm && currentStep !== index) {
                    currentStep = index;
                    showStep(currentStep);
                }
            });
            if (!this.checkValidity() || !isValidForm) {
                event.preventDefault();
                event.stopPropagation();
            }
            this.classList.add('was-validated');
        });
    }

    // Mostrar primer paso
    if (formSections.length > 0) {
        showStep(currentStep);
    }

    // Efectos para tarjetas del dashboard
    const cards = document.querySelectorAll('.card');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function () {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 10px 15px rgba(0, 0, 0, 0.1)';
        });
        card.addEventListener('mouseleave', function () {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 4px 6px rgba(0, 0, 0, 0.1)';
        });
    });
});

// Manejo de eliminación de servicio - VERSIÓN CORREGIDA
document.addEventListener('DOMContentLoaded', function () {
    // Configurar la ruta base según tu estructura de proyecto
    const BASE_URL = window.location.origin + window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/') + 1);
    
    document.querySelectorAll('.btn-eliminar-servicio').forEach(btn => {
        btn.addEventListener('click', function () {
            const id = this.getAttribute('data-id');
            const fila = this.closest('tr');
            
            // Obtener información del servicio de la fila
            const celdas = fila.querySelectorAll('td');
            const cliente = celdas[1] ? celdas[1].textContent.trim() : 'N/A';
            const dispositivo = celdas[2] ? celdas[2].textContent.trim() : 'N/A';
            
            console.log('Intentando eliminar servicio:', { id, cliente, dispositivo });
            
            // Confirmación detallada
            const confirmacion = confirm(
                `⚠️ CONFIRMAR ELIMINACIÓN\n\n` +
                `Cliente: ${cliente}\n` +
                `Dispositivo: ${dispositivo}\n` +
                `ID: ${id}\n\n` +
                `Esta acción eliminará permanentemente:\n` +
                `• El registro del dispositivo\n` +
                `• Todos los servicios asociados\n` +
                `• El historial de estados\n\n` +
                `⚠️ ESTA ACCIÓN NO SE PUEDE DESHACER\n\n` +
                `¿Desea continuar?`
            );
            
            if (confirmacion) {
                eliminarServicio(id, this, fila);
            }
        });
    });
    
    function eliminarServicio(id, boton, fila) {
        // Guardar estado original del botón
        const textoOriginal = boton.innerHTML;
        const claseOriginal = boton.className;
        
        // Cambiar botón a estado de carga
        boton.innerHTML = '<i class="bi bi-arrow-repeat spin me-1"></i> Eliminando...';
        boton.className = 'btn btn-warning btn-sm';
        boton.disabled = true;
        
        // Construir URL - intentar diferentes rutas posibles
        const posiblesRutas = [
            `eliminarServicio.jsp?id=${encodeURIComponent(id)}`,
            `../eliminarServicio.jsp?id=${encodeURIComponent(id)}`,
            `${BASE_URL}eliminarServicio.jsp?id=${encodeURIComponent(id)}`
        ];
        
        console.log('Intentando eliminar con ID:', id);
        console.log('Rutas a probar:', posiblesRutas);
        
        // Función para probar las rutas una por una
        async function probarEliminacion(rutaIndex = 0) {
            if (rutaIndex >= posiblesRutas.length) {
                throw new Error('No se pudo encontrar el archivo eliminarServicio.jsp en ninguna ruta');
            }
            
            const url = posiblesRutas[rutaIndex];
            console.log(`Probando ruta ${rutaIndex + 1}/${posiblesRutas.length}: ${url}`);
            
            try {
                const response = await fetch(url, {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json',
                        'Cache-Control': 'no-cache'
                    }
                });
                
                console.log(`Respuesta de ${url}:`, response.status, response.statusText);
                
                if (response.status === 404) {
                    // Probar siguiente ruta
                    return probarEliminacion(rutaIndex + 1);
                }
                
                if (!response.ok) {
                    throw new Error(`Error HTTP ${response.status}: ${response.statusText}`);
                }
                
                // Verificar que sea JSON
                const contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    const textResponse = await response.text();
                    console.log('Respuesta no-JSON recibida:', textResponse);
                    throw new Error('La respuesta del servidor no es JSON válido');
                }
                
                const data = await response.json();
                console.log('Datos JSON recibidos:', data);
                
                return data;
                
            } catch (error) {
                if (error.message.includes('JSON') || error.message.includes('HTTP')) {
                    throw error; // No probar más rutas para errores de parsing o HTTP
                }
                // Para otros errores, probar siguiente ruta
                return probarEliminacion(rutaIndex + 1);
            }
        }
        
        // Ejecutar eliminación
        probarEliminacion()
            .then(data => {
                console.log('Respuesta final:', data);
                
                if (data.exito) {
                    // Éxito - animar eliminación de fila
                    fila.style.transition = 'all 0.5s ease-out';
                    fila.style.opacity = '0';
                    fila.style.transform = 'translateX(-100%)';
                    
                    setTimeout(() => {
                        fila.remove();
                        
                        // Mostrar mensaje de éxito
                        mostrarMensajeExito(data.mensaje);
                        
                        // Actualizar contadores si existen
                        actualizarContadores();
                        
                    }, 500);
                    
                } else {
                    throw new Error(data.mensaje || 'Error desconocido al eliminar el servicio');
                }
            })
            .catch(error => {
                console.error('Error al eliminar servicio:', error);
                
                // Restaurar botón
                boton.innerHTML = textoOriginal;
                boton.className = claseOriginal;
                boton.disabled = false;
                
                // Mostrar error detallado
                mostrarMensajeError(error.message);
            });
    }
    
    function mostrarMensajeExito(mensaje) {
        if (typeof Swal !== 'undefined') {
            // Si tienes SweetAlert2
            Swal.fire({
                icon: 'success',
                title: '¡Éxito!',
                text: mensaje,
                timer: 3000,
                showConfirmButton: false
            });
        } else {
            // Alert nativo con mejor formato
            alert('✅ SERVICIO ELIMINADO\n\n' + mensaje);
        }
    }
    
    function mostrarMensajeError(mensaje) {
        if (typeof Swal !== 'undefined') {
            // Si tienes SweetAlert2
            Swal.fire({
                icon: 'error',
                title: 'Error al eliminar',
                text: mensaje,
                confirmButtonText: 'Entendido'
            });
        } else {
            // Alert nativo con mejor formato
            alert(
                '❌ ERROR AL ELIMINAR SERVICIO\n\n' + 
                mensaje + 
                '\n\n' +
                'Posibles soluciones:\n' +
                '• Verifica tu conexión a internet\n' +
                '• Asegúrate de que el servidor esté funcionando\n' +
                '• Revisa que el archivo eliminarServicio.jsp existe\n' +
                '• Consulta la consola del navegador para más detalles'
            );
        }
    }
    
    function actualizarContadores() {
        // Actualizar contadores en el dashboard si existen
        const contadores = document.querySelectorAll('[data-contador]');
        contadores.forEach(contador => {
            const valorActual = parseInt(contador.textContent) || 0;
            if (valorActual > 0) {
                contador.textContent = valorActual - 1;
            }
        });
    }
});

// Agregar estilos CSS para animaciones
document.addEventListener('DOMContentLoaded', function() {
    if (!document.getElementById('eliminar-styles')) {
        const style = document.createElement('style');
        style.id = 'eliminar-styles';
        style.innerHTML = `
            .spin {
                animation: spin 1s linear infinite;
            }
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
            
            /* Estilos para filas en proceso de eliminación */
            tr.eliminando {
                background-color: #fff3cd !important;
                border-left: 4px solid #ffc107;
            }
            
            /* Transición suave para hover en botones */
            .btn-eliminar-servicio {
                transition: all 0.2s ease;
            }
            
            .btn-eliminar-servicio:hover {
                transform: scale(1.05);
            }
        `;
        document.head.appendChild(style);
    }
});

document.addEventListener('DOMContentLoaded', function () {
    const consultaForm = document.getElementById('consultaEstadoForm');
    if (consultaForm) {
        consultaForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const nombre = document.getElementById('nombreConsulta').value.trim();
            const telefono = document.getElementById('telefonoConsulta').value.trim();
            const resultadoDiv = document.getElementById('resultadoConsulta');
            resultadoDiv.innerHTML = '<div class="text-center text-secondary"><i class="bi bi-arrow-repeat spin"></i> Buscando...</div>';

            fetch(`consultaEstado.jsp?nombre=${encodeURIComponent(nombre)}&telefono=${encodeURIComponent(telefono)}`)
                .then(res => res.text())
                .then(html => {
                    resultadoDiv.innerHTML = html;
                })
                .catch(() => {
                    resultadoDiv.innerHTML = '<div class="alert alert-danger">No se pudo consultar el estado. Intenta de nuevo.</div>';
                });
        });
    }
});